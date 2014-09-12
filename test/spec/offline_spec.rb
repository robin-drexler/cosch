require_relative 'helpers/runner'
require 'nokogiri'

describe 'offline cache' do
  APPCACHE_FILE_NAME = 'cache.appcache'

  it 'should create a appcache file that contains all html files' do
    Test_Helper::Build_Runner.run_build
    appcache_path = 'build/' + APPCACHE_FILE_NAME

    expect(File.exist? appcache_path).to eq(true)

    appcache_content = File.new(appcache_path).read

    expected_begin = <<CACHECONTENT
CACHE MANIFEST
index.html
1.html
CACHECONTENT

    expect(appcache_content).to include expected_begin
  end

  it 'should contain reference to appcache in html files' do
    page = Test_Helper::Build_Runner.build_and_read_index_html

    expect(page.css('html').attr('manifest').value).to eq(APPCACHE_FILE_NAME)
  end
end