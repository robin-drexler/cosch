require_relative 'helpers/runner'
require 'nokogiri'

describe 'file names' do
  it 'files should contain navigation linking to each day' do
    Test_Helper::Build_Runner.run_build

    index_html = File.read 'build/index.html'
    page = Nokogiri::HTML(index_html)
    link_pointing_to_index_page = page.css('nav a[href$="index.html"]')
    link_pointing_to_second = page.css('nav a[href$="1.html"]')


    navigation_links = page.css('nav a')


    expect(navigation_links.length).to eq(2)

    expect(link_pointing_to_index_page.text).to eq('Saturday')
    expect(link_pointing_to_second.text).to eq('Sunday')
  end

end