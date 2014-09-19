require_relative 'helpers/runner'

describe 'file names' do
  it 'should name the first day\'s file index.html and the others by their name' do

    Test_Helper::Build_Helper.run_new_and_build

    expect(File.exist? Test_Helper::Build_Helper::BUILD_DIR + '/index.html').to eq(true)
    expect(File.exist? Test_Helper::Build_Helper::BUILD_DIR + '/Sunday.html').to eq(true)
  end

  it 'should create files for location views per day' do

    Test_Helper::Build_Helper.run_new_and_build

    expect(File.exist? Test_Helper::Build_Helper::BUILD_DIR + '/indexH1.html').to eq(true)
    expect(File.exist? Test_Helper::Build_Helper::BUILD_DIR + '/indexH2.html').to eq(true)
    expect(File.exist? Test_Helper::Build_Helper::BUILD_DIR + '/SundayH1.html').to eq(true)

    # should not create files if no talks in location
    expect(File.exist? Test_Helper::Build_Helper::BUILD_DIR + '/SundayH2.html').to eq(false)

  end

end