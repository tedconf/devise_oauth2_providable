require 'spec_helper'

describe Devise::Strategies::Oauth2RefreshTokenGrantTypeStrategy, type: :request do
  let(:client) { FactoryBot.create(:client) }
  let(:user) { FactoryBot.create(:user) }
  let!(:refresh_token) { client.refresh_tokens.create! user: user }

  describe 'POST /oauth2/token' do
    describe 'with grant_type=refresh_token' do
      context 'with valid params' do
        before do
          params = {
            grant_type: 'refresh_token',
            client_id: client.identifier,
            client_secret: client.secret,
            refresh_token: refresh_token.token
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(200) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          expected = {
            token_type: 'bearer',
            expires_in: 899,
            refresh_token: refresh_token.token,
            access_token: token.token
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with expired refresh_token' do
        before do
          two_days_from_now = 2.days.from_now
          allow(Time).to receive(:now).and_return(two_days_from_now)
          params = {
            grant_type: 'refresh_token',
            client_id: client.identifier,
            client_secret: client.secret,
            refresh_token: refresh_token.token
          }
          allow(Time).to receive(:now).and_return(two_days_from_now + 2.months)
          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          expected = {
            error: 'invalid_grant',
            error_description: 'invalid refresh token'
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid refresh_token' do
        before do
          params = {
            grant_type: 'refresh_token',
            client_id: client.identifier,
            client_secret: client.secret,
            refresh_token: 'invalid'
          }

          post '/oauth2/token', params: params
        end
        it { expect(response.code.to_i).to eq(400) }
        it { expect(response.media_type).to eq('application/json') }
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          expected = {
            error: 'invalid_grant',
            error_description: 'invalid refresh token'
          }
          expect(response.body).to match_json(expected)
        end
      end
      context 'with invalid client_id' do
        before do
          params = {
            grant_type: 'refresh_token',
            client_id: 'invalid',
            client_secret: client.secret,
            refresh_token: refresh_token.token
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
      context 'with invalid client_secret' do
        before do
          params = {
            grant_type: 'refresh_token',
            client_id: client.identifier,
            client_secret: 'invalid',
            refresh_token: refresh_token.token
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
