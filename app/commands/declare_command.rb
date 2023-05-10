class DeclareCommandError < StandardError; end
class DeclareCommand
  def self.call(client, data)
    begin
      trigger_id = data['trigger_id']

      dialog = {
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

      client.dialog_open(trigger_id: trigger_id, dialog: dialog)
    rescue StandardError => e
      raise DeclareCommandError.new(e.message)
    end
  end
end
