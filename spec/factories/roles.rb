# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_role, class: Role do
    name 'システム管理者'
    key 'admin'
    sort 1
  end
  
  factory :treasurer_role, class: Role do
    name '出納担当者'
    key 'treasurer'
    sort 2
  end
end
