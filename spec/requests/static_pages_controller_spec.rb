require 'rails_helper'

RSpec.describe StaticPagesController, type: :request do
  describe "GET root" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include full_title('')
    end
  end

  describe "GET #help" do
    it "returns http success" do
      get help_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include full_title('Help')
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get '/about'
      expect(response).to have_http_status(:success)
      expect(response.body).to include full_title('About')
    end
  end

  describe "GET #contact" do
    it "returns http success" do
      get '/contact'
      expect(response).to have_http_status(:success)
      expect(response.body).to include full_title('Contact')
    end
  end
end