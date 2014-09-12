require 'nokogiri'

module Test_Helper
  class Build_Runner
    def self.run_build
      system('ruby ../bin/build.rb')
    end

    def self.build_and_read_index_html
      self.run_build

      index_html = File.read 'build/index.html'
      Nokogiri::HTML(index_html)
    end


  end
end