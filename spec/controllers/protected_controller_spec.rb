require 'spec_helper'

describe ProtectedController, type: :controller do
  let(:client) { FactoryBot.create(:client) }
  let(:user) { FactoryBot.create(:user) }
  let(:refresh_token) { client.refresh_tokens.create! user: user }
  let(:access_token) {
    Devise::Oauth2Providable::AccessToken.create!(
      client: client, user: user, refresh_token: refresh_token
    )
  }

  describe 'get :index' do
    context 'with valid bearer token in header' do
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{access_token.token}"
        get :index, as: :json
      end
      it { is_expected.to respond_with :ok }
    end

    context 'with valid bearer token in query string' do
      before do
        get :index, params: { access_token: access_token.token }, as: :json
      end
      it { is_expected.to respond_with :ok }
    end

    context 'with invalid bearer token in query param' do
      before do
        get :index, params: { access_token: 'invalid' }, as: :json
      end
      it { is_expected.to respond_with :unauthorized }
    end

    context 'with valid bearer token in header and query string' do
      before do
      end
      it 'raises error' do
        expect {
          @request.env['HTTP_AUTHORIZATION'] = "Bearer #{access_token.token}"
          get :index, params: { access_token: access_token.token }, as: :json
        }.to raise_error(Exception)
      end
    end
  end
end
