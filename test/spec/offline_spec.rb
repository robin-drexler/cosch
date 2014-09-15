require_relative 'helpers/runner'
require 'nokogiri'
require 'digest'
require_relative '../../lib/appcache_path_generator'

describe 'offline cache' do
  APPCACHE_FILE_NAME = 'cache.appcache'

  it 'should create a appcache file that contains all build files' do
    Test_Helper::Build_Helper.run_new_and_build
    appcache_path = Test_Helper::Build_Helper::BUILD_DIR + '/' + APPCACHE_FILE_NAME

    expect(File.exist? appcache_path).to eq(true)

    appcache_content = File.new(appcache_path).read

    expect(appcache_content).to include "index.html"
    expect(appcache_content).to include "\n1.html\n"
  end

  it 'should create a appcache file that contains static files' do
    Test_Helper::Build_Helper.run_new
    static_file_name = 'some_file'
    static_path = File.join(Test_Helper::Build_Helper::TEST_CONTENT_DIR, 'static')
    sub_path = File.join(static_path, 'sub')

    FileUtils.mkdir_p(sub_path)

    FileUtils.touch(File.join(sub_path, static_file_name))
    Test_Helper::Build_Helper.run_build


    appcache_path = Test_Helper::Build_Helper::BUILD_DIR + '/' + APPCACHE_FILE_NAME

    appcache_content = File.new(appcache_path).read
    expect(appcache_content).to include "\n#{File.join('sub', static_file_name)}\n"
  end

  it 'should contain reference to appcache in html files' do
    page = Test_Helper::Build_Helper.build_and_read_index_html

    expect(page.css('html').attr('manifest').value).to eq(APPCACHE_FILE_NAME)
  end

  it 'should contain a version identifier' do
    Test_Helper::Build_Helper.run_new_and_build

    appcache_path = Test_Helper::Build_Helper::BUILD_DIR + '/' + APPCACHE_FILE_NAME
    appcache_content =  File.new(appcache_path).read
    match_regex = %r{^#VERSION:(.*)#$}

    expect(appcache_content).to match match_regex

  end

end