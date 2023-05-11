require 'slack-ruby-client'

module SlackClient
  def self.client(team_id=nil)
    team = Team.where(team_id: team_id)&.last
    token = team&.token || ENV['SLACK_API_TOKEN']

    @client ||= Slack::Web::Client.new(token: token)
  end
end