require_relative 'helpers/runner'
require 'nokogiri'
require 'digest'
require_relative '../../appcache_version_generator'

describe 'offline cache' do
  APPCACHE_FILE_NAME = 'cache.appcache'

  it 'should create a appcache file that contains all html files' do
    Test_Helper::Build_Helper.run_build
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
    page = Test_Helper::Build_Helper.build_and_read_index_html

    expect(page.css('html').attr('manifest').value).to eq(APPCACHE_FILE_NAME)
  end

  it 'should generate a md5 of file content md5 of build folder as version identifier' do
    Test_Helper::Build_Helper.wipe_build_folder

    test_content = 'the world is not going to spin itself'
    md5 = Digest::MD5.new
    test_md5 = md5.hexdigest test_content

    File.open('build/' + 'foo', 'w') { |file| file.write(test_content) }

    appcache_version_generator = AppcacheVersionGenerator.new
    expect(appcache_version_generator.generate_appcache_version).to eq(md5.hexdigest test_md5)
  end

  it 'should contain a version identifier' do
    Test_Helper::Build_Helper.run_build

    appcache_path = 'build/' + APPCACHE_FILE_NAME
    appcache_content =  File.new(appcache_path).read
    match_regex = %r{^#VERSION:(.*)#$}

    expect(appcache_content).to match match_regex

  end

end