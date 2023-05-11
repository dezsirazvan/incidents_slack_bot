require 'rails_helper'

RSpec.describe SlackBotController, type: :controller do
  describe "POST #handle" do
    let(:params) do
      {
        token: 'example_token',
        team_id: 'T0001',
        team_domain: 'example_team',
        channel_id: 'C12345',
        channel_name: 'test',
        user_id: 'U12345',
        user_name: 'testuser',
        command: '/test',
        text: 'example_text',
        response_url: 'https://example.com'
      }
    end

    before do
      ENV['SLACK_SIGNING_SECRET'] = 'example_secret'
      allow_any_instance_of(SlackBotController).to receive(:verify_slack_request).and_return(true)
    end

    context "with a valid command" do
      before do
        allow(CommandFactory).to receive(:call).and_return({ status: :ok })
      end

      it "responds with a 200 status code" do
        post :handle, params: params
        expect(response.status).to eq(200)
      end
    end

    context "with an invalid command" do
      before do
        allow(CommandFactory).to receive(:call).and_raise(StandardError.new('example_error'))
      end

      it "responds with an error message" do
        post :handle, params: params
        expect(response.body).to eq({ error: 'example_error' }.to_json)
      end
    end
  end

  describe "POST #actions" do
    let(:payload) do
      {
        "type": "interactive_message",
        "callback_id": "declare_incident",
        "user": { "id": "USER_ID" },
        "channel": { "id": "CHANNEL_ID" },
        "response_url": "https://hooks.slack.com/actions/TOKEN",
        "actions": [
          {
            "name": "declare",
            "type": "button",
            "value": "incident",
            "text": "Declare Incident"
          }
        ]
      }
    end

    before do
      allow(controller).to receive(:verify_slack_request).and_return(true)
    end

    it "calls CreateIncident service with the correct payload" do
      expect_any_instance_of(CreateIncident).to receive(:call)

      post :actions, params: { payload: payload.to_json }

      expect(response).to have_http_status(:ok)
    end
  end
end
