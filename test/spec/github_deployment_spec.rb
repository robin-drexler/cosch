require_relative 'helpers/runner'
require_relative '../../lib/commands/deploy_to_github_pages'
require_relative '../../lib/asker'

describe 'github pages deployment' do
  it 'should ask to deploy to determined github remote url' do
    remote_url = 'git@awalkinthepark.org'

    expect(RapidSchedule::DeployToGithubPages).to receive(:retrieve_remote_url) { remote_url }

    expect(RapidSchedule::Asker).to receive(:confirm?)
    .with(/#{remote_url}/)

    deploy_command = RapidSchedule::Commands::DeployToGithubPages.new

    deploy_command.execute!()
  end

  it 'should ask to deploy to provided github remote url if option was set' do
    remote_url = 'git@awalkinthepark.org'

    expect(RapidSchedule::DeployToGithubPages).not_to receive(:retrieve_remote_url)

    expect(RapidSchedule::Asker).to receive(:confirm?)
    .with(/#{remote_url}/)

    deploy_command = RapidSchedule::Commands::DeployToGithubPages.new

    deploy_command.execute!("remote" => remote_url)
  end

  it 'should execute deployment with remote url if user confirmed' do
    remote_url = 'git@awalkinthepark.org'

    allow(RapidSchedule::DeployToGithubPages).to receive(:retrieve_remote_url) { remote_url }
    allow(RapidSchedule::Asker).to receive(:confirm?) { true }

    expect(RapidSchedule::DeployToGithubPages).to receive(:deploy).with(remote_url)

    deploy_command = RapidSchedule::Commands::DeployToGithubPages.new
    deploy_command.execute!()
  end

  it 'should not execute deployment if user denied' do

    allow(RapidSchedule::Asker).to receive(:confirm?) { false }

    expect(RapidSchedule::DeployToGithubPages).not_to receive(:deploy)

    deploy_command = RapidSchedule::Commands::DeployToGithubPages.new
    deploy_command.execute!()
  end

end