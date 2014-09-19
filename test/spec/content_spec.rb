require_relative 'helpers/runner'
require 'nokogiri'

describe 'content' do
  it 'should contain slots with talks' do
    page = Test_Helper::Build_Helper.build_and_read_index_html
    slots = page.css('.slot-container')

    expect(slots.length).to eq(2)

    # smoke test first slot content
    slot = slots[0]

    # slot contains start and end time
    expect(slot.css('.slot-time-start').text).to include '12:00'
    expect(slot.css('.slot-time-end').text).to include '13:00'

    # slots have talks
    expect(slot.css('.talk-container').length).to eq(2)
  end

  it 'should contain talk data' do
    page = Test_Helper::Build_Helper.build_and_read_index_html
    talk = page.css('.talk-container')[0]

    expect(talk.css('.talk-speaker').text).to include 'Robin'
    expect(talk.css('.talk-location').text).to include 'H1'
    expect(talk.css('.talk-title').text).to include 'How Geloet will save us all'

  end

  it 'should contain conference title' do
    page = Test_Helper::Build_Helper.build_and_read_index_html
    header = page.css('header h1')

    expect(header.text).to include 'My awesome conference'
  end

  it 'should contain talks with links to their location views' do
    expected_location_view_path = 'indexH1.html'

    page = Test_Helper::Build_Helper.build_and_read_index_html
    talk = page.css('.talk-container')[0]
    location = talk.css('.talk-location')

    expect(location.css('a[href$="indexH1.html"]').length).to eq(1)

    # make sure linked file actually exists
    location_view_path = File.join(Test_Helper::Build_Helper::BUILD_DIR, expected_location_view_path)
    expect(File.exist? location_view_path).to eq(true)

  end

end