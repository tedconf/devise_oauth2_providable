require 'spec_helper'

describe User, type: :model do
  it { is_expected.to have_many(:access_tokens) }
  it { is_expected.to have_many(:authorization_codes) }
end
