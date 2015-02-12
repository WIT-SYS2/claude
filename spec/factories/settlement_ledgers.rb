# == Schema Information
#
# Table name: settlement_ledgers
#
#  id                  :integer          not null, primary key
#  ledger_number       :string(9)        not null
#  content             :string(40)       not null
#  note                :string(200)      not null
#  price               :integer          not null
#  application_date    :date             not null
#  applicant_user_id   :integer          not null
#  applicant_user_name :string(40)       not null
#  settlement_date     :date
#  settlement_note     :string(40)
#  completed_at        :datetime
#  deleted_at          :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :settlement_ledger do
    ledger_number 'AAA-00001'
    content '営業経費精算書'
    note '5月10日〜5月12日'
    price 20000
    application_date Date.today
    applicant_user_id 1
    applicant_user_name '申請者'
  end
end
