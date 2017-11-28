require 'spec_helper'

describe Devise::Oauth2Providable::AuthorizationsController, type: :controller do
  routes { Devise::Oauth2Providable::Engine.routes }
  describe 'GET #new' do
    context 'with valid redirect_uri' do
      with :user
      with :client
      let(:redirect_uri) { client.redirect_uri }
      before do
        sign_in user
        get :new, :client_id => client.identifier, :redirect_uri => redirect_uri, :response_type => 'code'
      end
      it { is_expected.to respond_with :ok }
      # it { is_expected.to respond_with_content_type :html }
      it 'should have the right content_type' do
        expect(response.content_type.to_s)
          .to eq(Mime::Type.lookup_by_extension(:html).to_s)
      end
      # it { is_expected.to assign_to(:redirect_uri).with(redirect_uri) }
      # it { is_expected.to assign_to(:response_type) }
      it { expect(subject.instance_variable_get(:@redirect_uri)).to eq(redirect_uri) }
      it { expect(subject.instance_variable_get(:@response_type)).not_to eq(nil)  }
      it { is_expected.to render_template 'devise/oauth2_providable/authorizations/new' }
      it { is_expected.to render_with_layout 'application' }
    end
    context 'with invalid redirect_uri' do
      with :user
      with :client
      let(:redirect_uri) { 'http://example.com/foo/bar' }
      before do
        sign_in user
        get :new, :client_id => client.identifier, :redirect_uri => redirect_uri, :response_type => 'code'
      end
      it { is_expected.to respond_with :bad_request }
      it 'should have the right content_type' do
        expect(response.content_type.to_s)
        .to eq(Mime::Type.lookup_by_extension(:html).to_s)
      end
      # it { is_expected.to respond_with_content_type :html }
    end
  end
end
