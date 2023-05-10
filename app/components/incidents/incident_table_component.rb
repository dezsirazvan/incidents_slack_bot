# app/components/incidents/incident_table_component.rb

class Incidents::IncidentTableComponent < ViewComponent::Base
  include ActionView::Helpers::DateHelper

  def initialize(incidents:)
    @incidents = incidents
  end
end
