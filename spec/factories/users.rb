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
  end

  factory :treasurer, class: User do
    name '出納担当者'
    sequence(:email) {|n| "treasurer#{n}@example.com" }
    password 'treasurer'
    password_confirmation 'treasurer'
    confirmed_at DateTime.now
    confirmation_sent_at DateTime.now
  end
end
