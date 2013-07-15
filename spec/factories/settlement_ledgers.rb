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
