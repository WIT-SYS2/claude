# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  admin = User.create!(name: 'システム管理者',
                       email: 'admin@example.com',
                       password: 'administrator',
                       confirmed_at: DateTime.now,
                       confirmation_sent_at: DateTime.now)
  accountant = User.create!(name: '経理担当者',
                            email: 'accountant@example.com',
                            password: 'accountant',
                            confirmed_at: DateTime.now,
                            confirmation_sent_at: DateTime.now)
  user1 = User.create!(name: '利用者1',
                       email: 'user1@example.com',
                       password: 'applicationuser',
                       confirmed_at: DateTime.now,
                       confirmation_sent_at: DateTime.now)
  user2 = User.create!(name: '利用者2',
                       email: 'user2@example.com',
                       password: 'applicationuser',
                       confirmed_at: DateTime.now,
                       confirmation_sent_at: DateTime.now)

  admin_role = Role.create!(name: 'システム管理者', key: 'admin', sort: 1)
  accountant_role = Role.create!(name: '経理担当者', key: 'accountant', sort: 2)

  admin.roles << [admin_role, accountant_role]
  admin.save!

  accountant.roles << [accountant_role]
  accountant.save!
end
