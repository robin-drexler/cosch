require_relative 'helpers/runner'
require 'json'

describe 'json' do

  it 'should contain json representation of schedule' do
    Test_Helper::Build_Helper.run_new_and_build

    json_string = File.read(File.join(Test_Helper::Build_Helper::BUILD_DIR, 'schedule.json'))
    json = JSON.parse(json_string)

    expect(json['days'].length).to be > 0
    expect(json['title'].length).to be > 0
  end

end
