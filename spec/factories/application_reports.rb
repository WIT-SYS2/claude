# == Schema Information
#
# Table name: application_reports
#
#  id               :integer          not null, primary key
#  application_to   :string(40)       not null
#  user_id          :integer          not null
#  user_name        :string(20)       not null
#  department_name  :string(40)       not null
#  kind             :integer          not null
#  start_date       :date
#  end_date         :date
#  term_day         :integer
#  start_date_time  :datetime
#  end_date_time    :datetime
#  term_hour        :integer
#  term_minutes     :integer
#  reason           :string(100)
#  contact          :string(100)
#  tel              :string(20)
#  document         :string(100)
#  note             :string(255)
#  status           :integer          default(1), not null
#  application_date :date             not null
#  approved_date    :date
#  created_at       :datetime
#  updated_at       :datetime
#

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
