require 'rails_helper'

RSpec.describe IncidentsController, type: :controller do
  describe "GET #index" do
    let!(:incident1) { FactoryBot.create(:incident, title: "Incident 1", severity: "sev0") }
    let!(:incident2) { FactoryBot.create(:incident, title: "Incident 2", severity: "sev1") }
    
    context "when no sorting params are provided" do
      before { get :index }
      
      it "assigns all incidents to @incidents" do
        expect(assigns(:incidents)).to match_array([incident1, incident2])
      end
      
      it "renders the index template" do
        expect(response).to render_template(:index)
      end
      
      it "responds with a success status" do
        expect(response).to have_http_status(:success)
      end
    end
    
    context "when sorting by title in ascending order" do
      before { get :index, params: { sort_by: "title", order: "asc" } }
      
      it "assigns all incidents to @incidents in ascending order by title" do
        expect(assigns(:incidents)).to eq([incident1, incident2])
      end
      
      it "renders the index template" do
        expect(response).to render_template(:index)
      end
      
      it "responds with a success status" do
        expect(response).to have_http_status(:success)
      end
    end
    
    context "when sorting by severity in descending order" do
      before { get :index, params: { sort_by: "severity", order: "desc" } }
      
      it "assigns all incidents to @incidents in descending order by severity" do
        expect(assigns(:incidents)).to eq([incident2, incident1])
      end
      
      it "renders the index template" do
        expect(response).to render_template(:index)
      end
      
      it "responds with a success status" do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
