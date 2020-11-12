require 'spec_helper'

describe Devise::Strategies::Oauth2PasswordGrantTypeStrategy, type: :request do
  let(:client) { FactoryBot.create(:client) }
  describe 'POST /oauth2/token' do
    describe 'with grant_type=password' do
      context 'with valid params' do
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'test'

          params = {
            :grant_type => 'password',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'test'
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(200) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          expected = token.token_response
          expect(response.body).to match_json(expected)
        end
      end
      context 'with valid params and client id/secret in basic auth header' do
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'test'

          params = {
            :grant_type => 'password',
            :username => @user.email,
            :password => 'test'
          }

          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials client.identifier, client.secret
          post '/oauth2/token', params: params, headers: { 'HTTP_AUTHORIZATION' => auth_header }
        end
        it { expect(response.code.to_i).to eq(200) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          expected = token.token_response
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid client id in basic auth header' do
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'test'
          params = {
            :grant_type => 'password',
            :username => @user.email,
            :password => 'test'
          }
          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials 'invalid client id', client.secret
          post '/oauth2/token', params: params, headers: { 'HTTP_AUTHORIZATION' => auth_header }
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json')  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid client secret in basic auth header' do
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'test'
          params = {
            :grant_type => 'password',
            :username => @user.email,
            :password => 'test'
          }
          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials client.identifier, 'invalid secret'
          post '/oauth2/token', params: params, headers: { 'HTTP_AUTHORIZATION' => auth_header }
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json')  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid password' do
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'test'

          params = {
            :grant_type => 'password',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'bar'
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json')  }
        it 'returns json' do
          expected = {
            :error_description => "invalid password authentication request",
            :error => "invalid_grant"
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid client_id' do
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'test'

          params = {
            :grant_type => 'password',
            :client_id => 'invalid',
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'test'
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json')  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid client_secret' do
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'test'

          params = {
            :grant_type => 'password',
            :client_id => client.identifier,
            :client_secret => 'invalid',
            :username => @user.email,
            :password => 'test'
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json')  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          expect(response.body).to match_json(expected)
        end
      end
    end
  end
end
