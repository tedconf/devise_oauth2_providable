FactoryGirl.define do
  factory :user do
    sequence(:email) { |c| "ryan#{c}@socialcast.com" }
    password 'testtest'
  end
end
