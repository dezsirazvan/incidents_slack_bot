require 'slack-ruby-client'

module SlackClient
  def self.client
    @client ||= Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
  end
end