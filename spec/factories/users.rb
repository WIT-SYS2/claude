# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'ユーザー'
    sequence(:email) {|n| "user#{n}@example.com" }
    password 'applicationuser'
    password_confirmation 'applicationuser'
    confirmed_at DateTime.now
    confirmation_sent_at DateTime.now
  end

  factory :admin, class: User do
    name 'システム管理者'
    sequence(:email) {|n| "admin#{n}@example.com" }
    password 'administrator'
    password_confirmation 'administrator'
    confirmed_at DateTime.now
    confirmation_sent_at DateTime.now

    after(:create) { |u| u.roles << FactoryGirl.create(:admin_role) }
  end

  factory :accountant, class: User do
    name '経理担当者'
    sequence(:email) {|n| "accountant#{n}@example.com" }
    password 'accountant'
    password_confirmation 'accountant'
    confirmed_at DateTime.now
    confirmation_sent_at DateTime.now

    after(:create) { |u| u.roles << FactoryGirl.create(:accountant_role) }
  end
end
