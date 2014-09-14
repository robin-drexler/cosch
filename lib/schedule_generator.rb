require_relative 'commands/build'
require 'mercenary'

module RapidSchedule

  class ScheduleGenerator
    def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    end

    def execute!
      Mercenary.program(:rapidschedule) do |p|
        p.version '0.0.1'
        p.description 'Generate your conference schedule rapidly'
        p.syntax "rapidschedule <subcommand>"

        p.command(:build) do |c|
          c.syntax "build"
          c.description "builds the static site"

          c.action do |args, options|
            RapidSchedule::Commands::Build.new.execute!
          end
        end
      end
      @kernel.exit 0
    end
  end

end
