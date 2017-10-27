require 'spec_helper'

describe Devise::Oauth2Providable::AccessToken, type: :model do
  it { expect(Devise::Oauth2Providable::AccessToken.table_name).to eq('oauth2_access_tokens') }

  describe 'basic access token instance' do
    with :client
    subject do
      Devise::Oauth2Providable::AccessToken.create! :client => client
    end
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_uniqueness_of(:token) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:client) }
    it { is_expected.to validate_presence_of(:client) }
    it { is_expected.to validate_presence_of(:expires_at) }
    it { is_expected.to belong_to(:refresh_token) }
    it { is_expected.to have_db_index(:client_id) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:token).unique(true) }
    it { is_expected.to have_db_index(:expires_at) }
  end

  describe '#expires_at' do
    context 'when refresh token does not expire before access token' do
      with :client
      before do
        @later = 1.year.from_now
        @refresh_token = client.refresh_tokens.create!
        @refresh_token.expires_at = @soon
        @access_token = Devise::Oauth2Providable::AccessToken.create! :client => client, :refresh_token => @refresh_token
      end
      focus 'should not set the access token expires_at to equal refresh token' do
        expect(@access_token.expires_at).not_to eq(@later)
      end
    end
    context 'when refresh token expires before access token' do
      with :client
      before do
        @soon = 1.minute.from_now
        @refresh_token = client.refresh_tokens.create!
        @refresh_token.expires_at = @soon
        @access_token = Devise::Oauth2Providable::AccessToken.create! :client => client, :refresh_token => @refresh_token
      end
      it 'should set the access token expires_at to equal refresh token' do
        expect(@access_token.expires_at).to eq(@soon)
      end
    end
  end
end
