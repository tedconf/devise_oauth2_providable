FactoryBot.define do
  factory :client, class: 'Devise::Oauth2Providable::Client' do
    sequence(:name) { |c| "test#{c}" }
    website { 'http://localhost' }
    redirect_uri { 'http://localhost:3000' }
  end
end
