class CreateSettlementLedgers < ActiveRecord::Migration
  def change
    create_table :settlement_ledgers do |t|
      t.string :ledger_number, limit: 9, null: false
      t.string :content, limit: 40, null: false
      t.string :note, limit: 200, null: false
      t.integer :price, null: false
      t.date :application_date, null: false
      t.integer :applicant_user_id, null: false
      t.string :applicant_user_name, limit: 40, null: false
      t.date :settlement_date
      t.string :settlement_note, limit: 40
      t.datetime :completed_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_index(:settlement_ledgers, :ledger_number, unique: true)
  end
end
