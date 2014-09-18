# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :application_report do
    application_to '株式会社テスト'
    user_id 1
    user_name '山田 太郎'
    department_name '営業1課'
    kind ApplicationReport::KINDS[:paid_leave]
    start_date 3.days.since.to_date
    end_date 5.days.since.to_date
    term_day 2
    reason '私用のため'
    contact '携帯電話'
    tel '090-0000-0000'
    document '特になし'
    note '特になし'
    application_date Date.today
  end
end
