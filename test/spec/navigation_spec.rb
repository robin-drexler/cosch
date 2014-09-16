require_relative 'helpers/runner'
require 'nokogiri'

describe 'navigation' do
  it 'should contain links to each day' do
    Test_Helper::Build_Helper.run_new_and_build

    page = Test_Helper::Build_Helper.build_and_read_index_html

    link_pointing_to_index_page = page.css('nav a[href$="index.html"]')
    link_pointing_to_second = page.css('nav a[href$="1.html"]')

    navigation_links = page.css('nav a')

    expect(navigation_links.length).to eq(2)

    expect(link_pointing_to_index_page.text).to eq('Saturday')
    expect(link_pointing_to_second.text).to eq('Sunday')
  end

  it 'marks current navigation point as active one' do
    page = Test_Helper::Build_Helper.build_and_read_index_html

    active_li = page.css('nav ul li.active')
    active_li_a = active_li.css('a')

    # make sure it's the only active one
    expect(active_li.length).to eq(1)
    expect(active_li_a.attr('href').content).to include('index.html')
  end

end