module RapidSchedule
  class DeployToGithubPages
    def self.deploy(remote_url)
      script_path = File.join(File.dirname(__FILE__), 'scripts', 'deploy_to_github_pages.sh')
      system(script_path, remote_url)
    end

    # xxx handle no git rep
    def self.retrieve_remote_url
      `git remote show -n origin | grep 'Push' | awk '{print $NF}'`.strip
    end
  end
end