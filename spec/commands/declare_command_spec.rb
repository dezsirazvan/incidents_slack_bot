require 'rails_helper'

RSpec.describe DeclareCommand do
  let(:client) { instance_double(Slack::Web::Client) }
  let(:data) { { 'trigger_id' => '1234' } }

  describe '.call' do
    it 'opens a dialog with the correct options' do
      dialog_options = {
        title: 'Declare Incident',
        callback_id: 'declare_incident',
        submit_label: 'Declare',
        close: true,
        elements: [
          {
            label: 'Title',
            name: 'title',
            type: 'text',
            placeholder: 'Enter the incident title',
            hint: 'This field is required'
          },
          {
            label: 'Description',
            name: 'description',
            type: 'textarea',
            placeholder: 'Enter the incident description',
            hint: 'This field is required',
            optional: true
          },
          {
            label: 'Severity',
            name: 'severity',
            type: 'select',
            options: [
              { label: 'SEV0', value: 'sev0' },
              { label: 'SEV1', value: 'sev1' },
              { label: 'SEV2', value: 'sev2' }
            ],
            placeholder: 'Select the incident severity',
            hint: 'This field is optional',
            optional: true
          }
        ]
      }

      allow(client).to receive(:dialog_open)

      described_class.call(client, data)

      expect(client).to have_received(:dialog_open).with(trigger_id: '1234', dialog: dialog_options)
    end
  end
end
