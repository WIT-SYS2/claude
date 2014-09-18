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
#  state            :string(255)
#  application_date :datetime         not null
#  approved_date    :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class ApplicationReport < ActiveRecord::Base
  KINDS = {
    paid_leave: 1,
    compensatory_leave: 2,
    menstrual_leave: 3,
    congratulation_or_condolence_leave: 4,
    special_leave: 5,
    absence: 6,
    tardiness: 7,
    early_leaving: 8,
    private_outing: 9,
    business_trip: 10,
    holiday_work: 11,
    address_change: 12,
    marriage: 13,
    nativity: 14,
    other: 15,
  }

  validates :application_to, presence: true, length: { maximum: 40 }
  validates :user_id, presence: true
  validates :user_name, presence: true, length: { maximum: 20 }
  validates :department_name, presence: true, length: { maximum: 40 }
  validates :kind, inclusion: { in: KINDS.values }
  validates :term_day, numericality: { only_integer: true, greater_than: 0, less_than: 1000, allow_nil: true }
  validates :term_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24, allow_nil: true }
  validates :term_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60, allow_nil: true }
  validates :reason, length: { maximum: 100 }
  validates :contact, length: { maximum: 100 }
  validates :tel, length: { maximum: 20 }, format: { with: /\A^[0-9-]*\Z/ }
  validates :document, length: { maximum: 100 }
  validates :note, length: { maximum: 255 }
  validates :application_date, presence: true

  state_machine initial: :before_application do
    state :before_application
    state :applying
    state :approved
    state :rejected

    event :apply do
      transition before_application: :applying
    end

    event :approve do
      transition applying: :approved
    end

    event :reject do
      transition applying: :rejected
    end
  end

  def generate_pdf
    pdf_file_path = File.join(Dir.tmpdir, 'claude', "#{self.id}.pdf")
    FileUtils.mkdir_p(File.dirname(pdf_file_path))
    report = ThinReports::Report.generate(filename: pdf_file_path, layout: Rails.configuration.application_report_template_path) do |r|
      r.start_new_page do |page|
        page.item(:department).value(self.department_name)
        page.item(:name).value(self.user_name)
        page.item(:application_date).value(self.application_date)
        page.item(:approved_date).value(self.approved_date)
        page.item("kind_#{self.kind}".to_sym).show
        page.item(:start_date).value(self.start_date)
        page.item(:end_date).value(self.end_date)
        page.item(:term_day).value(self.term_day)
        page.item(:start_date_time).value(self.start_date_time)
        page.item(:end_date_time).value(self.end_date_time)
        page.item(:term_hour).value(self.term_hour)
        page.item(:term_minutes).value(self.term_minutes)
        page.item(:reason).value(self.reason)
        page.item(:contact).value(self.contact)
        page.item(:tel).value(self.tel)
        page.item(:document).value(self.document)
        page.item(:note).value(self.note)
      end
    end
    return pdf_file_path
  end
end
