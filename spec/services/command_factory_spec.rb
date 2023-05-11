require 'spec_helper'
require 'slack_client'
require_relative '../../app/services/command_factory'
require_relative '../../app/commands/declare_command'

RSpec.describe CommandFactory do
  let(:data) { { 'user_name' => 'testuser', 'channel_id' => 'C123456' } }

  describe '.call' do
    context 'when given a valid command' do
      let(:client) { instance_double('Slack::Web::Client') }
      let(:parts) { ['incident', 'description', 'sev1'] }

      before do
        allow(SlackClient).to receive(:client).and_return(client)
      end

      it 'calls the correct command class with the correct arguments' do
        expect(DeclareCommand).to receive(:call).with(client, data)

        CommandFactory.call('declare', data)
      end
    end
  end
end
