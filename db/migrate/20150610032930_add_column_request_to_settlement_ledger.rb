class AddColumnRequestToSettlementLedger < ActiveRecord::Migration
  def change
    add_column :settlement_ledgers, :request, :string, limit: 100
  end
end
