json.array!(@settlement_ledgers) do |settlement_ledger|
  json.extract! settlement_ledger, :ledger_number, :content, :note, :price, :application_date, :applicant_user_id, :settlement_date, :settlement_note, :completed_at
  json.url settlement_ledger_url(settlement_ledger, format: :json)
end
