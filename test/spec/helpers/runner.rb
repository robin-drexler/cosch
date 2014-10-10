require 'nokogiri'


module Test_Helper
  class Build_Helper
    TEST_CONTENT_DIR = 'test_content'
    BUILD_DIR="#{TEST_CONTENT_DIR}/build"

    def self.run_new
      self.wipe_new_folder
      system('ruby ../bin/cosch.rb new ' + TEST_CONTENT_DIR)
    end

    def self.run_new_and_build
      self.run_new
      self.run_build
    end

    def self.run_build
      system("cd #{TEST_CONTENT_DIR} && ruby ../../bin/cosch.rb build")
    end

    def self.build_and_read_index_html
      self.run_new_and_build

      index_html = File.read BUILD_DIR + '/index.html'
      Nokogiri::HTML(index_html)
    end

    def self.wipe_build_folder
      FileUtils.rm_rf(Dir.glob(BUILD_DIR + '/*'))
    end

    def self.wipe_new_folder
      FileUtils.rm_rf(TEST_CONTENT_DIR)
    end
  end
end