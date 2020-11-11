require 'spec_helper'

describe Devise::Oauth2Providable::AuthorizationCode, type: :model do
  describe 'basic authorization code instance' do
    let(:client) { FactoryBot.create(:client) }
    let(:user) { FactoryBot.create(:user) }
    subject do
      Devise::Oauth2Providable::AuthorizationCode.create! client: client, user: user
    end
    it { is_expected.to validate_presence_of :token }
    it { is_expected.to validate_uniqueness_of :token }
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :client }
    it { is_expected.to validate_presence_of :client }
    it { is_expected.to validate_presence_of :expires_at }
    it { is_expected.to have_db_index :client_id }
    it { is_expected.to have_db_index :user_id }
    it { is_expected.to have_db_index(:token).unique(true) }
    it { is_expected.to have_db_index :expires_at }
  end
end
