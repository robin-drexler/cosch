require_relative 'helpers/runner'
require 'nokogiri'

describe 'location views' do

  it 'should contain talk data for location' do
    Test_Helper::Build_Helper.run_new_and_build
    path = File.read File.join(Test_Helper::Build_Helper::BUILD_DIR, 'indexH1.html')

    page = Nokogiri::HTML(path)

    talk = page.css('.talk-container')[0]

    expect(talk.css('.talk-speaker').text).to include 'Robin'
    expect(talk.css('.talk-location').text).to include 'H1'
    expect(talk.css('.talk-title').text).to include 'How Geloet will save us all'

  end

  it 'should contain conference title' do
    Test_Helper::Build_Helper.run_new_and_build
    path = File.read File.join(Test_Helper::Build_Helper::BUILD_DIR, 'indexH1.html')
    page = Nokogiri::HTML(path)

    expect(page.css('header').text).to include 'My awesome conference'
  end

end