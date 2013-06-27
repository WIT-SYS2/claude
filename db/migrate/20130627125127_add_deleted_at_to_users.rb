class AddDeletedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime, after: :confirmation_sent_at
  end
end
