require 'liquid'
require 'fileutils'
require 'yaml'
require_relative '../appcache_path_generator'
require_relative '../location_data_generator'
require 'find'

VIEW_PATH_ROOT = File.join('views')

module RapidSchedule
  module Commands
    class Build
      def execute!
        p 'Building site'
        @config = YAML.load_file 'schedule.yml'
        @days = days = @config["days"]
        @location_data_generator = RapidSchedule::LocationDataGenerator.new(@days)

        Liquid::Template.file_system = Liquid::LocalFileSystem.new(VIEW_PATH_ROOT)


        @days = decorate_days_with_file_names(days)

        FileUtils.mkdir_p('build/')
        FileUtils.rm_rf(Dir.glob('build/*'))


        @days.each do |day|
          create_day_view_for_day(day, @location_data_generator.locations_for_day(day))
          create_location_views_for_day(day)
        end

        copy_static_to_build

        appcache_generator = AppcachePathGenerator.new 'build'
        appcache_content = generate_appcache_content(appcache_generator.paths)

        appcache_content << "#VERSION:" + appcache_generator.appcache_version + '#'

        File.open('build/' + 'cache.appcache', 'w') { |file| file.write(appcache_content) }
      end

      private

      def create_day_view_for_day(day, locations)
        day_html = generate_day_html(day, locations)
        write_with_wrapper_markup(day_html, 'build/' + day['file_name'] + '.html')
      end

      def create_location_views_for_day(day)
        locations = @location_data_generator.locations_for_day(day)

        locations.each do |location|
          html = generate_location_html(location, @location_data_generator.talks_for_location_for_day(location, day), day)
          write_with_wrapper_markup(html, generate_location_path_for_day(day, location))
        end

      end

      def generate_location_html(location, talks, day)
        html_path = File.join(VIEW_PATH_ROOT, 'location.html')
        file_content = File.new(html_path).read

        Liquid::Template.parse(file_content).render(
          {
            'day' => day,
            'talks' => talks,
            'days' => @days,
            'title' => @config['title'],
            'location' => location
          })
      end

      def generate_location_path_for_day(day, location)
        'build/' + day['file_name'] + sanitize_filename(location) + '.html'
      end

      # XXX file names not unique anymore! Could be overridden
      def decorate_days_with_file_names(days)
        days_decorated = days.map do |day|
          index = days.index day
          day['file_name'] = sanitize_filename(day["name"])

          if index === 0
            day['file_name'] = 'index'
          end

          # sanitize location paths
          day['slots'].each do |slot|
            slot['talks'].each do |talk|
              talk['location_file_name'] = sanitize_filename(talk['location'])
            end
          end

          day
        end
      end

      def write_with_wrapper_markup(html, path)
        wrapper_path = File.join(VIEW_PATH_ROOT, 'wrapper.html')
        html = Liquid::Template.parse(File.new(wrapper_path).read).render('content' => html)

        File.open(path, 'w') { |file| file.write(html) }
      end

      def generate_day_html(day, locations)
        html_path = File.join(VIEW_PATH_ROOT, 'day.html')
        file_content = File.new(html_path).read

        Liquid::Template.parse(file_content).render(
          {
            'day' => day,
            'days' => @days,
            'active_name' => day['name'],
            'title' => @config['title']
          })
      end

      def generate_appcache_content(paths)
        Liquid::Template.parse(File.new(File.join(VIEW_PATH_ROOT, 'cache.appcache')).read).render 'resources' => paths
      end

      def copy_static_to_build
        static_folder_path = 'static'

        return unless Dir.exist? static_folder_path

        FileUtils.cp_r(Dir[static_folder_path + '/*'], 'build')
      end

      def sanitize_filename(filename)
        # Split the name when finding a period which is preceded by some
        # character, and is followed by some character other than a period,
        # if there is no following period that is followed by something
        # other than a period (yeah, confusing, I know)
        fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

        # We now have one or two parts (depending on whether we could find
        # a suitable period). For each of these parts, replace any unwanted
        # sequence of characters with an underscore
        fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

        # Finally, join the parts with a period and return the result
        return fn.join '.'
      end
    end
  end
end