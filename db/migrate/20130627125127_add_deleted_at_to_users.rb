class AddDeletedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime, after: :unconfirmed_email
  end
end
