require 'spec_helper'

describe Devise::Oauth2Providable::TokensController, type: :routing do
  describe 'routing' do
    routes { Devise::Oauth2Providable::Engine.routes }
    it 'routes POST /token' do
      expect(post('/token')).to route_to('devise/oauth2_providable/tokens#create')
    end
  end
end
