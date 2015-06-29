class AddColumnDemandToSettlementLedgers < ActiveRecord::Migration
  def change
    add_column :settlement_ledgers, :demand, :string, limit: 100, null: true, default: ''
  end
end
