require_relative 'helpers/runner'
require_relative '../../lib/appcache_path_generator'

describe 'app cache path generator' do
  it 'should return files in given folder with relative paths' do
    test_dir = 'test_dir'
    FileUtils.rm_rf(test_dir)


    FileUtils.mkdir_p(File.join(test_dir, 'empty_sub'))
    FileUtils.mkdir_p(File.join(test_dir, 'sub'))

    FileUtils.touch(File.join(test_dir, 'a_file'))
    FileUtils.touch(File.join(test_dir, 'sub', 'another_file'))

    appcache_generator = AppcachePathGenerator.new test_dir
    paths = appcache_generator.paths

    expect(paths).to include 'a_file'
    expect(paths).to include File.join('sub', 'another_file')
    expect(paths).not_to include File.join('empty_sub')

    FileUtils.rm_rf(test_dir)
  end

  it 'should return version based on content in paths' do
    test_dir = 'test_dir'
    content = 'lala'
    another_content = 'lili'

    #hash of hash of both contents
    expected_version = 'ef3288b44ae7f0b0e49f75e9bcfbcb91'

    FileUtils.rm_rf(test_dir)
    FileUtils.mkdir_p(test_dir)


    File.open(File.join(test_dir, 'a_file'), 'w') { |file| file.write(content) }
    File.open(File.join(test_dir, 'a_file2'), 'w') { |file| file.write(another_content) }

    appcache_generator = AppcachePathGenerator.new test_dir
    version = appcache_generator.appcache_version

    expect(version).to eq(expected_version)

    FileUtils.rm_rf(test_dir)
  end

end