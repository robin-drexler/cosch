require_relative 'helpers/runner'

describe 'file names' do
  it 'should name the first day\'s file index.html and numerate the others' do
    Test_Helper::Build_Runner.run_build



    expect(File.exist? 'build/index.html').to eq(true)
    expect(File.exist? 'build/1.html').to eq(true)

    expect(Dir['build/*.html'].length).to eq(2)
  end

end