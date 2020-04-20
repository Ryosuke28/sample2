FactoryBot.define do
  factory :user do
    name { "Example User" }
    # email { "user@example.com" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
