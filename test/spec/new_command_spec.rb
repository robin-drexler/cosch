require_relative 'helpers/runner'
require_relative '../../lib/commands/new'


describe 'new command' do
  it 'it should throw exception when no path is provided' do
    new_command = RapidSchedule::Commands::New.new

    expect{ new_command.execute!([]) }.to raise_error ArgumentError
  end

  it 'it should copy template folder to new path' do
    test_path = 'new_path'
    template_path = File.join(__FILE__, '..', '..', '..', 'lib', 'template')
    template_path = File.expand_path(template_path)

    FileUtils.rm_rf(test_path)

    new_command = RapidSchedule::Commands::New.new

    new_command.execute!([test_path])

    expect(Dir.glob(test_path + '/**/*').length).to eq(Dir.glob(template_path + '/**/*').length)

    # check one actual file to prevent false posivitive assertion when comparing length
    expect(File.exist?(File.join(template_path, 'schedule.yml'))).to eq(true)

    FileUtils.rm_rf(test_path)
  end

end