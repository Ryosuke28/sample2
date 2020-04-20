FactoryBot.define do
  factory :user do
    # name { "Example User" }
    sequence(:name) { |n| "Example User#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end
end
