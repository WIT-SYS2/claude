class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, limit: 20, null: false
      t.string :key, limit: 20, null: false
      t.integer :sort, null: false
    end
  end
end
