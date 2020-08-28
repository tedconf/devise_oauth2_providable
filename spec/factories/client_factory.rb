FactoryBot.define do
  factory :client, class: 'Devise::Oauth2Providable::Client' do
    name { 'test' }
    website { 'http://localhost' }
    redirect_uri { 'http://localhost:3000' }
  end
end
