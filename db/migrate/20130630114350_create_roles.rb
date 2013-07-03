class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, limit: 20, null: false
      t.string :key, limit: 20, null: false
      t.integer :sort, null: false
    end

    add_index(:roles, :key, unique: true)
  end
end
