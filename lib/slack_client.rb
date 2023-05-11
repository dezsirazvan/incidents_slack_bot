require 'slack-ruby-client'

module SlackClient
  def self.client(team_id=nil)
    team = Team.find_by(team_id: team_id)
    token = team&.token || ENV['SLACK_API_TOKEN']

    @client ||= Slack::Web::Client.new(token: token)
  end
end