require_relative 'commands/build'
require_relative 'commands/deploy_to_github_pages'
require_relative 'commands/new'
require 'mercenary'

module RapidSchedule

  class ScheduleGenerator
    def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    end

    def execute!
      Mercenary.program(:cosch) do |p|
        p.version '1.0.3'
        p.description 'Generate your conference schedule easily'
        p.syntax "cosch <subcommand>"

        # blatantly stolen from jekyll XXX needs tests
        p.action do |args|
          if args.empty?
            puts p
          else
            unless p.has_command?(args.first)
              raise ArgumentError.new("Invalid command. Use --help for more information")
            end
          end
        end

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

        p.command(:new) do |c|
          c.syntax "new PATH"
          c.description "creates a new schedule skeleton at PATH."

          c.action do |args, options|
            RapidSchedule::Commands::New.new.execute! args, options
          end
        end

      end
      @kernel.exit 0
    end
  end

end
