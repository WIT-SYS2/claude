# == Schema Information
#
# Table name: roles_users
#
#  user_id :integer          not null
#  role_id :integer          not null
#

class RolesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end
