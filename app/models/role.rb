# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string(20)       not null
#  key  :string(20)       not null
#  sort :integer          not null
#

class Role < ActiveRecord::Base
  validates :name, presence: true,
                   length: { maximum: 20 }
  validates :key, presence: true,
                  length: { maximum: 20 },
                  uniqueness: true
  validates :sort, presence: true

  has_and_belongs_to_many :uses

  default_scope { order('sort') }
end
