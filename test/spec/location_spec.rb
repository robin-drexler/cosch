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

    expect(page.css('.slot-time-start')[0].text).to include '12:00'
    expect(page.css('.slot-time-end')[0].text).to include '13:00'

  end

  it 'should contain conference title' do
    Test_Helper::Build_Helper.run_new_and_build
    path = File.read File.join(Test_Helper::Build_Helper::BUILD_DIR, 'indexH1.html')
    page = Nokogiri::HTML(path)

    expect(page.css('header').text).to include 'My awesome conference'
  end

end