require 'liquid'
require 'fileutils'
require 'yaml'
require_relative '../appcache_path_generator'
require 'find'

VIEW_PATH_ROOT = File.join('views')

module RapidSchedule
  module Commands
    class Build
      def execute!
        p 'Building site'
        config = YAML.load_file 'schedule.yml'
        days = config["days"]
        Liquid::Template.file_system = Liquid::LocalFileSystem.new(VIEW_PATH_ROOT)

        days_decorated = decorate_days_with_file_names(days)

        FileUtils.mkdir_p('build/')
        FileUtils.rm_rf(Dir.glob('build/*'))

        config["days"] = days_decorated
        days_decorated.each do |day|
          html = generate_day_html(day, config)

          File.open('build/' + day['file_name'], 'w') { |file| file.write(html) }
        end

        copy_static_to_build

        appcache_generator = AppcachePathGenerator.new 'build'
        appcache_content = generate_appcache_content(appcache_generator.paths)

        appcache_content << "#VERSION:" + appcache_generator.appcache_version + '#'

        File.open('build/' + 'cache.appcache', 'w') { |file| file.write(appcache_content) }
      end

      private
      def decorate_days_with_file_names(days)
        days_decorated = days.map do |day|
          index = days.index day
          day['file_name'] = index.to_s

          day['file_name'] = 'index' if index == 0
          day['file_name'] += '.html'

          day
        end
      end

      def generate_day_html(day, config)
        html_path = File.join(VIEW_PATH_ROOT, 'day.html')
        file_content = File.new(html_path).read

        Liquid::Template.parse(file_content).render(
          {
            'day' => day,
            'days' => config['days'],
            'active_name' => day['name'],
            'title' => config['title']
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
    end
  end
end