require_relative '../../app/commands/resolve_command'
require 'spec_helper'
require 'rails_helper'

RSpec.describe ResolveCommand do
  let(:client) { double(:client) }
  let(:data) { { 'channel_id' => 'incident-channel-id', 'user_name' => 'username' } }
  let(:incident) { double(:incident, created_at: 1.hour.ago, resolved_at: Time.now, update: true) }

  describe '.call' do
    before do
      allow(client).to receive(:chat_postMessage)
      allow(client).to receive(:conversations_archive)
    end

    context 'when the command is executed in an incident channel' do
      before do
        allow(ResolveCommand).to receive(:fetch_incident).with('incident-channel-id').and_return(incident)
      end

      it 'updates the incident status in the database' do
        expect(incident).to receive(:update).with(status: 'resolved', resolved_at: Time)
        ResolveCommand.call(client, data)
      end

      it 'calculates the time to resolution' do
        expect(client).to receive(:chat_postMessage).with(channel: 'incident-channel-id', text: /Incident resolved by <@username> in \d+ minutes/)
        ResolveCommand.call(client, data)
      end

      it 'archives the incident channel' do
        expect(client).to receive(:conversations_archive).with(channel: 'incident-channel-id')
        ResolveCommand.call(client, data)
      end
    end

    context 'when the command is not executed in an incident channel' do
      before do
        allow(ResolveCommand).to receive(:fetch_incident).with('non-incident-channel-id').and_return(nil)
      end

      it 'returns early and does not update the incident status' do
        expect(incident).not_to receive(:update)
        ResolveCommand.call(client, data.merge('channel_id' => 'non-incident-channel-id'))
      end

      it 'sends a message indicating the command can only be used in an incident channel' do
        expect(client).to receive(:chat_postMessage).with(channel: 'non-incident-channel-id', text: 'This command can only be used in an incident channel')
        ResolveCommand.call(client, data.merge('channel_id' => 'non-incident-channel-id'))
      end

      it 'does not archive the incident channel' do
        expect(client).not_to receive(:conversations_archive)
        ResolveCommand.call(client, data.merge('channel_id' => 'non-incident-channel-id'))
      end
    end
  end
end