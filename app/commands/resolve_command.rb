class ResolveCommandError < StandardError; end
class ResolveCommand
  def self.call(client_service, data)
    begin
      client = client_service.client(data.dig('user', 'team_id'))
      # Check if the command is being executed in an incident channel
      incident = fetch_incident(data['channel_id'])
      unless incident
        client.chat_postMessage(channel: data['channel_id'], text: 'This command can only be used in an incident channel')
        return
      end

      # Update the incident status in the database
      incident.update(status: 'resolved', resolved_at: Time.now)

      # Calculate the time to resolution
      time_to_resolution = (incident.resolved_at - incident.created_at).to_i

      # Send a message to the incident channel with the resolution details
      client.chat_postMessage(channel: data['channel_id'], text: "Incident resolved by <@#{ data['user_name']}> in #{time_to_resolution / 60} minutes")

      # Archive the incident channel
      client.conversations_archive(channel: data['channel_id'])
    rescue StandardError => e
      ResolveCommandError.new(e.message)
    end
  end

  def self.fetch_incident(channel_id)
    Incident.find_by(channel_id: channel_id)
  end
end
