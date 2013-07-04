# == Schema Information
#
# Table name: settlement_ledgers
#
#  id                :integer          not null, primary key
#  ledger_number     :string(9)        not null
#  content           :string(40)       not null
#  note              :string(200)      not null
#  price             :integer          not null
#  application_date  :date             not null
#  applicant_user_id :integer          not null
#  settlement_date   :date
#  settlement_note   :string(40)
#  completed_at      :datetime
#  deleted_at        :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class SettlementLedger < ActiveRecord::Base
  EXCEL_HEADER = %w[台帳No 内容 備考 精算金額 申請日 申請者 精算日 備考 精算完了 削除]

  attr_accessor :completed
  validates :ledger_number, length: { is: 9 },
                            uniqueness: true
  validates :content, presence: true, length: { maximum: 40 }
  validates :note, presence: true, length: { maximum: 200 }
  validates :price, numericality: { only_integer: true, greater_than: 0, less_than: 1000000 }
  validates :application_date, presence: true
  validates :applicant_user_id, presence: true
  validates :settlement_note, length: { maximum: 40 }

  default_scope { order('ledger_number ASC') }

  scope :completed, -> { where('completed_at IS NOT NULL') }
  scope :not_completed, -> { where('completed_at IS NULL') }

  before_validation :assign_ledger_number, on: :create

  def applicant
    User.unscoped.find(applicant_user_id)
  end

  def completed?
    completed_at.present?
  end

  def deleted?
    deleted_at.present?
  end

  def to_xlsx_value
    [
      ledger_number,
      content,
      note,
      price,
      application_date,
      applicant.name,
      settlement_date,
      settlement_note,
      completed? ? '○' : '×',
      deleted? ? '○' : '×'
    ]
  end

  private

  def assign_ledger_number
    latest = SettlementLedger.where('ledger_number LIKE ?', "#{Rails.configuration.ledger_number_prefix}%")
                             .order('ledger_number DESC')
                             .first
    if latest
      self.ledger_number = latest.ledger_number.succ
    else
      self.ledger_number = "#{Rails.configuration.ledger_number_prefix}001"
    end
  end
end
