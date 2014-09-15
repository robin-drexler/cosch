require_relative 'helpers/runner'

describe 'static content folder' do
  it 'should copy static content to build folder' do
    Test_Helper::Build_Helper.run_new

    static_folder = File.join(Test_Helper::Build_Helper::TEST_CONTENT_DIR, 'static')

    FileUtils.mkdir_p(File.join(static_folder, 'sub'))

    FileUtils.touch(File.join(static_folder, 'sub', '.another_file'))
    FileUtils.touch(File.join(static_folder, 'a_file'))

    Test_Helper::Build_Helper.run_build

    expect(File.exist? File.join(Test_Helper::Build_Helper::BUILD_DIR, 'a_file')).to eq(true)
    expect(File.exist? File.join(Test_Helper::Build_Helper::BUILD_DIR, 'sub', '.another_file')).to eq(true)
  end

end