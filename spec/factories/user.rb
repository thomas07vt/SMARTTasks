FactoryGirl.define do
  factory :user do
    name "Douglas Adams"
    sequence(:email, 100) { |n| "person#{n}@example.com" }
    sequence(:username, 100) { |n| "username#{n}" }
    password "helloworld"
    password_confirmation "helloworld"
    confirmed_at Time.now
  end
end