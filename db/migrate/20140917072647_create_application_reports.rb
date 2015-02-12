class CreateApplicationReports < ActiveRecord::Migration
  def change
    create_table :application_reports do |t|
      t.string :application_to, limit: 40, null: false
      t.references :user, null: false
      t.string :user_name, limit: 20, null: false
      t.string :department_name, limit: 40, null: false
      t.integer :kind, null: false
      t.date :start_date
      t.date :end_date
      t.integer :term_day
      t.datetime :start_date_time
      t.datetime :end_date_time
      t.integer :term_hour
      t.integer :term_minutes
      t.string :reason, limit: 100
      t.string :contact, limit: 100
      t.string :tel, limit: 20
      t.string :document, limit: 100
      t.string :note
      t.integer :status, null: false, default: 1
      t.date :application_date, null: false
      t.date :approved_date
      t.timestamps
    end
  end
end
