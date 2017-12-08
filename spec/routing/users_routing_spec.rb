require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/users").to route_to("users#index")
    end


    it "routes to #create" do
      expect(:post => "/api/users").to route_to("users#create")
    end
  end
end
