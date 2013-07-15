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
  treasurer = User.create!(name: '出納担当者',
                           email: 'treasurer@example.com',
                           password: 'treasurer',
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
  treasurer_role = Role.create!(name: '出納担当者', key: 'treasurer', sort: 2)

  admin.roles << [admin_role, treasurer_role]
  admin.save!

  treasurer.roles << [treasurer_role]
  treasurer.save!
end
