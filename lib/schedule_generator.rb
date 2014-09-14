require_relative 'commands/build'

module RapidSchedule

  class ScheduleGenerator
    def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    end

    def execute!
      build_command = RapidSchedule::Commands::Build.new
      build_command.execute!

      @kernel.exit 0
    end
  end

end
