require 'liquid'
require 'fileutils'

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
},{
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


Liquid::Template.file_system = Liquid::LocalFileSystem.new("views")

days_curated = days.map do |day|
  index = days.index day
  day['file_name'] = index.to_s

  day['file_name'] = 'index' if index == 0
  day['file_name'] += '.html'

  day
end
FileUtils.mkdir_p('build')
FileUtils.rm_rf(Dir.glob('build/*'))
days_curated.each do |day|
  html = Liquid::Template.parse(File.read 'views/day.html').render 'day' => day, 'days' => days_curated

  File.open('build/' + day['file_name'], 'w') { |file| file.write(html) }
end
