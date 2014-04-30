# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo do
    body "MyString"
    list nil
    completed false
  end
end
