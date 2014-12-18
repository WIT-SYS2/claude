class AddFileNameToSettlementLedgers < ActiveRecord::Migration
  def change
    add_column :settlement_ledgers, :file_name, :string
  end
end
