require_relative '../deploy_to_github_pages'
require_relative '../asker'

module RapidSchedule
  module Commands
    class DeployToGithubPages
      def execute!(options = {})
        gh_remote_url = options["remote"]

        unless gh_remote_url
          gh_remote_url = RapidSchedule::DeployToGithubPages.retrieve_remote_url
        end

        ok = RapidSchedule::Asker.confirm? "Will push to: #{gh_remote_url} gh-pages branch"

        if ok
          RapidSchedule::DeployToGithubPages.deploy gh_remote_url
        end
      end
    end
  end
end