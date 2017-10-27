require 'spec_helper'

describe Devise::Oauth2Providable::AuthorizationsController, type: :routing do
  describe 'routing' do
    routes { Devise::Oauth2Providable::Engine.routes }

    it 'routes POST /authorizations' do
      expect(post('/authorizations'))
        .to route_to('devise/oauth2_providable/authorizations#create')
    end
    it 'routes GET /authorize' do
      expect(get('/authorize'))
        .to route_to('devise/oauth2_providable/authorizations#new')
    end
    it 'routes POST /authorize' do
      #FIXME: this is valid, but the route is not being loaded into the test
      expect(post('/authorize'))
        .to route_to('devise/oauth2_providable/authorizations#new')
    end
  end
end
