require_relative 'helpers/runner'

describe 'file names' do
  it 'should name the first day\'s file index.html and numerate the others' do

    Test_Helper::Build_Helper.run_new_and_build

    expect(File.exist? Test_Helper::Build_Helper::BUILD_DIR + '/index.html').to eq(true)
    expect(File.exist? Test_Helper::Build_Helper::BUILD_DIR + '/1.html').to eq(true)

    expect(Dir[Test_Helper::Build_Helper::BUILD_DIR + '/*.html'].length).to eq(2)
  end

end