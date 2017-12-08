require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe UsersController, type: :controller do
  render_views

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:response_json) { JSON.parse(response.body).deep_symbolize_keys }

  describe "GET #index" do
    context 'without params' do
      describe 'get list' do
        let!(:user) { create(:static_user) }
        let(:response_user) { response_json[:users][0] }

        it "returns a success response" do
          get :index, params: {}, session: valid_session, format: :json
          expect(response).to be_success

          expect(response_user[:full_name]).to eq('John')
        end
      end

      describe 'records order' do
        let!(:user1) { create(:user) }
        let!(:user2) { create(:user) }

        let(:response_user) { response_json[:users][0] }
        let(:response_user2) { response_json[:users][1] }

        it "returns a success response" do
          get :index, params: {}, session: valid_session, format: :json
          expect(response).to be_success

          expect(response_user[:full_name]).to eq(user2.full_name)
          expect(response_user2[:full_name]).to eq(user1.full_name)
        end
      end
    end

    context 'with params' do
      let!(:user_with_email) { create(:user, email: 'some@email.com') }
      let!(:user_with_meta) { create(:user, metadata: 'OTHER') }

      describe 'search with email' do
        it "returns a success response" do
          get :index, params: { query: { email: 'some@email.com' }}, session: valid_session, format: :json
          expect(response).to be_success

          expect(response_json[:users][0][:full_name]).to eq(user_with_email.full_name)
          expect(response_json[:users].length).to eq(1)
        end
      end

      describe 'search with metadata' do
        it "returns a success response" do
          get :index, params: { query: { metadata: 'OTHER' }}, session: valid_session, format: :json
          expect(response).to be_success

          expect(response_json[:users][0][:full_name]).to eq(user_with_meta.full_name)
          expect(response_json[:users].length).to eq(1)
        end
      end
    end
  end


  describe "POST #create" do
    context "with valid params" do
      let(:last_user) { User.last }

      it "creates a new User" do
        expect {
          post :create, params: {user: attributes_for(:user)}, session: valid_session, format: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post :create, params: {user: attributes_for(:user)}, session: valid_session, format: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response_json[:full_name]).to eq(last_user.full_name)
      end

      it "sets key for the user" do
        post :create, params: {user: attributes_for(:user)}, session: valid_session, format: :json
        expect(response).to have_http_status(:created)

        expect(last_user.key).to be_present
      end

      it "sets password for the user" do
        post :create, params: {user: attributes_for(:user, password: '123456')}, session: valid_session, format: :json
        expect(response).to have_http_status(:created)

        expect(last_user.password_digest).to be_present
        expect(last_user.password_digest).not_to eq('123456')
      end

      context 'obtain account key' do
        it "calls job to get an account key" do
          expect(GetAccountKeyJob).to receive(:perform_later).with(an_instance_of(User)).once

          post :create, params: {user: attributes_for(:user, password: '123456')}, session: valid_session, format: :json
          expect(response).to have_http_status(:created)
        end
      end
    end

    context "with invalid params" do
      before { create(:static_user) }

      it "renders a JSON response with errors for the new user" do
        post :create, params: {user: attributes_for(:static_user)}, session: valid_session, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end


  end
end
