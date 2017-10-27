require 'spec_helper'

describe User, type: :model do
  it { should have_many :access_tokens }
  it { should have_many :authorization_codes }
end
