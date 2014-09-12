require 'liquid'
require 'fileutils'

class ScheduleGenerator
  def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    view_path = File.join(File.dirname(__FILE__), 'views')


# noinspection RubyStringKeysInHashInspection
    days = [{
              'name' => 'Saturday',
              'talks' => [
                {
                  'speaker' => "Katrin",
                  'title' => "BWL is my pony"
                }, {
                  'speaker' => "Robin",
                  'title' => "Why everything is awesome"
                }
              ]
            }, {
              'name' => 'Sunday',
              'talks' => [
                {
                  'speaker' => "Peter",
                  'title' => "Wurst"
                }, {
                  'speaker' => "Robin",
                  'title' => "Käse"
                }
              ]
            }]


    Liquid::Template.file_system = Liquid::LocalFileSystem.new(view_path)

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
      html = Liquid::Template.parse(File.read File.join(view_path, 'day.html')).render 'day' => day, 'days' => days_decorated, 'active_name' => day['name']

      File.open('build/' + day['file_name'], 'w') { |file| file.write(html) }
    end


    exitstatus = 0
    p "GO!"
    @kernel.exit(exitstatus)
  end
end