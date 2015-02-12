# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(40)       default(""), not null
#  deleted_at             :datetime
#

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
