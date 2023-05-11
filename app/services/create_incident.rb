require 'slack_client'

class CreateIncidentError < StandardError; end
class CreateIncident
  def initialize(data)
    @data = data
  end

  def call
    # Parse the title, description and severity from the dialog submission
    title = @data['submission']['title']
    description = @data['submission']['description']
    severity = @data['submission']['severity']

    # Create a new Slack channel for the incident
    channel_name = "incident-#{title}-#{Time.now.strftime('%F-%H-%M')}"
    channel = client.conversations_create(name: channel_name, is_private: false).dig('channel')
    # Create a new incident in the database
    incident = Incident.create(
      title: title,
      description: description,
      severity: severity,
      creator: @data['user']['name'],
      status: 'open',
      channel_id: channel['id']
    )

    # Invite the creator in the new channel
    client.conversations_invite(channel: channel['id'], users: @data['user']['id'])

    # Send a message to the incident channel with the details of the incident
    client.chat_postMessage(
      channel: channel['id'],
      text: "New incident declared by <@#{@data['user']['name']}>:\nTitle: #{title}\nDescription: #{description}\nSeverity: #{severity}"
    )

    # Send a confirmation message to the user
    client.chat_postMessage(
      channel: @data['channel']['id'],
      text: "Incident created in channel <##{channel['id']}>"
    )
  rescue StandardError => e
    raise CreateIncidentError.new(e.message)
  end

  private

  def client
    @client ||= SlackClient.client(@data['team_id'])
  end
end
