require 'spec_helper'

describe Devise::Strategies::Oauth2AuthorizationCodeGrantTypeStrategy, type: :request do
  let(:client) { FactoryBot.create(:client) }
  let(:user) { FactoryBot.create(:user) }
  let(:authorization_code) do
    user.authorization_codes.create!(
      client: client, redirect_uri: client.redirect_uri
    )
  end
  describe 'POST /oauth2/token' do
    describe 'with grant_type=authorization_code' do
      context 'with valid params' do
        before do
          params = {
            grant_type: 'authorization_code',
            client_id: client.identifier,
            client_secret: client.secret,
            code: authorization_code.token
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(200) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          refresh_token = Devise::Oauth2Providable::RefreshToken.last
          expected = {
            token_type: 'bearer',
            expires_in: 899,
            refresh_token: refresh_token.token,
            access_token: token.token
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with expired authorization_code' do
        before do
          timenow = 2.days.from_now
          allow(Time).to receive(:now).and_return(timenow)
          params = {
            grant_type: 'authorization_code',
            client_id: client.identifier,
            client_secret: client.secret,
            code: authorization_code.token
          }
          allow(Time).to receive(:now).and_return(timenow + 10.minutes)

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          expected = {
            error: 'invalid_grant',
            error_description: 'invalid authorization code request'
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid authorization_code' do
        before do
          params = {
            grant_type: 'authorization_code',
            client_id: client.identifier,
            client_secret: client.secret,
            code: 'invalid'
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          expected = {
            error: 'invalid_grant',
            error_description: 'invalid authorization code request'
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid client_secret' do
        before do
          params = {
            grant_type: 'authorization_code',
            client_id: client.identifier,
            client_secret: 'invalid',
            code: authorization_code.token
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          expected = {
            error: 'invalid_client',
            error_description: 'invalid client credentials'
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid client_id' do
        before do
          params = {
            grant_type: 'authorization_code',
            client_id: 'invalid',
            client_secret: client.secret,
            code: authorization_code.token
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          expected = {
            error: 'invalid_client',
            error_description: 'invalid client credentials'
          }
          expect(response.body).to match_json(expected)
        end
      end
    end
  end
end
