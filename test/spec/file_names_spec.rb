def run_build
  system('ruby ../bin/build.rb')
end

describe 'file names' do
  it 'it should name the first day\'s file index.html and numerate the others' do
    run_build
    expect(File.exist? 'build/index.html').to eq(true)
    expect(File.exist? 'build/1.html').to eq(true)

    expect(Dir['build/*.html'].length).to eq(2)
  end

end