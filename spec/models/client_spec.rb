require 'spec_helper'

describe Devise::Oauth2Providable::Client, type: :model do
  it { expect(Devise::Oauth2Providable::Client.table_name).to eq('oauth2_clients') }

  describe 'basic client instance' do
    let(:client) { FactoryBot.create(:client) }
    subject { client }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_presence_of :website }
    it { is_expected.to validate_uniqueness_of :identifier }
    it { is_expected.to have_db_index(:identifier).unique(true) }
    it { is_expected.to have_many :refresh_tokens }
    it { is_expected.to have_many :authorization_codes }
  end
end
