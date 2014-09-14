require 'liquid'
require 'fileutils'
require 'yaml'
require_relative 'appcache_version_generator'

VIEW_PATH_ROOT = File.join(File.dirname(__FILE__), 'views')

class ScheduleGenerator
  def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    days = YAML.load_file 'schedule.yml'
    Liquid::Template.file_system = Liquid::LocalFileSystem.new(VIEW_PATH_ROOT)

    days_decorated = days.map do |day|
      index = days.index day
      day['file_name'] = index.to_s

      day['file_name'] = 'index' if index == 0
      day['file_name'] += '.html'

      day
    end


    FileUtils.mkdir_p('build/')
    FileUtils.rm_rf(Dir.glob('build/*'))

    days_decorated.each do |day|
      html = generate_day_html(day, days_decorated)

      File.open('build/' + day['file_name'], 'w') { |file| file.write(html) }
    end

    copy_static_to_build

    appcache_version_generator = AppcacheVersionGenerator.new
    appcache_content = generate_appcache_content(days_decorated)

    appcache_content << "#VERSION:" + appcache_version_generator.generate_appcache_version + '#'

    File.open('build/' + 'cache.appcache', 'w') { |file| file.write(appcache_content) }

    exitstatus = 0
    p "GO!"
    @kernel.exit(exitstatus)
  end

  private
  def generate_day_html(day, days_decorated)
    html_path = File.join(VIEW_PATH_ROOT, 'day.html')
    file_content = File.new(html_path).read

    Liquid::Template.parse(file_content).render({
        'day' => day,
        'days' => days_decorated,
        'active_name' => day['name']
      })
  end


  def generate_appcache_content(days_decorated)
    appcache_content = Liquid::Template.parse(File.new(File.join(VIEW_PATH_ROOT, 'cache.appcache')).read).render 'resources' => days_decorated.map { |day| day['file_name'] }
  end

  def copy_static_to_build
    static_folder_path = 'static'

    return unless Dir.exist? static_folder_path

    FileUtils.cp_r(Dir[static_folder_path + '/*'], 'build')
  end

end