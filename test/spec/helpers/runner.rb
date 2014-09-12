module Test_Helper
  class Build_Runner
    def self.run_build
      system('ruby ../bin/build.rb')
    end
  end
end