require 'spec_helper'

describe Devise::Oauth2Providable::RefreshToken, type: :model do

  it { expect(Devise::Oauth2Providable::RefreshToken.table_name).to eq('oauth2_refresh_tokens') }

  describe 'basic refresh token instance' do
    let(:user) { FactoryBot.create(:user) }
    let(:client) { FactoryBot.create(:client) }
    subject do
      Devise::Oauth2Providable::RefreshToken.create! client: client, user: user
    end
    it { is_expected.to validate_presence_of :token }
    it { is_expected.to validate_uniqueness_of :token }
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :client }
    it { is_expected.to validate_presence_of :client }
    it { is_expected.to validate_presence_of :expires_at }
    it { is_expected.to have_many :access_tokens }
    it { is_expected.to have_db_index :client_id }
    it { is_expected.to have_db_index :user_id }
    it { is_expected.to have_db_index(:token).unique(true) }
    it { is_expected.to have_db_index :expires_at }
  end
end
