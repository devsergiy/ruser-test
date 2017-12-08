FactoryBot.define do
  factory :user do
    sequence(:full_name) {|n|  "User#{n}" }
    sequence(:email) {|n|  "example#{n}@example.com" }
    sequence(:phone_number) {|n|  "123#{n}" }
    password '123456'
  end

  factory :static_user, class: User do
    full_name 'John'
    phone_number '123456'
    password '123456'
    email 'example@example.com'
  end
end
