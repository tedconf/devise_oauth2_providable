require 'spec_helper'

describe Devise::Oauth2Providable::Client, type: :model do
  it { Devise::Oauth2Providable::Client.table_name.should == 'oauth2_clients' }

  describe 'basic client instance' do
    with :client
    subject { client }
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :website }
    it { should validate_uniqueness_of :identifier }
    it { should have_db_index(:identifier).unique(true) }
    it { should have_many :refresh_tokens }
    it { should have_many :authorization_codes }
  end
end
