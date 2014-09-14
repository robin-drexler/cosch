require_relative 'commands/build'
require_relative 'commands/deploy_to_github_pages'
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

        p.command(:deploy) do |c|
          c.syntax "deploy"
          c.description "deploys site to Github pages."
          c.option 'remote', '--remote [REMOTE_URL]', 'Set the git remote url where gh-pages branch is pushed to.'

          c.action do |args, options|
            RapidSchedule::Commands::DeployToGithubPages.new.execute! options
          end
        end

      end
      @kernel.exit 0
    end
  end

end
