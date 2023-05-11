require 'rails_helper'
require 'spec_helper'
require 'slack_client'
require_relative '../../app/services/create_incident'

require 'slack_client'

RSpec.describe CreateIncident do
  let(:data) do
    {
      'submission' => {
        'title' => 'test incident',
        'description' => 'this is a test',
        'severity' => 'high'
      },
      'user' => {
        'name' => 'test user',
        'id' => 'U123456'
      },
      'channel' => {
        'id' => 'C123456'
      }
    }
  end
  let(:client) { double('SlackClient') }
  let(:channel) { { 'id' => 'C123456' } }
  let(:incident) { double('Incident', id: 1) }

  subject { described_class.new(data) }

  before do
    allow(SlackClient).to receive(:client).and_return(client)
    allow(client).to receive(:conversations_create).and_return({ 'channel' => channel })
    allow(client).to receive(:chat_postMessage)
    allow(Incident).to receive(:create).and_return(incident)
    allow(client).to receive(:conversations_invite)
  end

  describe '#call' do
    it 'creates a new incident in the database' do
      expect(Incident).to receive(:create).with(
        title: 'test incident',
        description: 'this is a test',
        severity: 'high',
        creator: 'test user',
        status: 'open',
        channel_id: 'C123456'
      )
      subject.call
    end

    it 'creates a new Slack channel for the incident' do
      expect(client).to receive(:conversations_create).with(
        name: 'incident-test incident-' + Time.now.strftime('%F-%H-%M'),
        is_private: false
      )
      subject.call
    end

    it 'invites the creator to the new channel' do
      expect(client).to receive(:conversations_invite).with(
        channel: 'C123456',
        users: 'U123456'
      )
      subject.call
    end

    it 'sends a message to the incident channel with the details of the incident' do
      expect(client).to receive(:chat_postMessage).with(
        channel: 'C123456',
        text: "New incident declared by <@test user>:\nTitle: test incident\nDescription: this is a test\nSeverity: high"
      )
      subject.call
    end

    it 'sends a confirmation message to the user' do
      expect(client).to receive(:chat_postMessage).with(
        channel: 'C123456',
        text: 'Incident created in channel <#C123456>'
      )
      subject.call
    end

    context 'when an error occurs' do
      let(:error_message) { 'Some error occurred' }

      before do
        allow(Incident).to receive(:create).and_raise(error_message)
      end

      it 'raises a CreateIncidentError with the error message' do
        expect { subject.call }.to raise_error(CreateIncidentError, error_message)
      end
    end
  end
end