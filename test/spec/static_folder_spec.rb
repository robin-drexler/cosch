require_relative 'helpers/runner'

describe 'static content folder' do
  it 'should copy static content to build folder' do
    Test_Helper::Build_Helper.run_build

    expect(File.exist? 'build/a_file').to eq(true)
    expect(File.exist? 'build/sub_dir/.another_file').to eq(true)
  end

end