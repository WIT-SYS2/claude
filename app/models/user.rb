# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(40)       default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  deleted_at             :datetime
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  validates :name, presence: true, length: { in: 4..20, allow_nil: true }
  validates :password, confirmation: true, length: { maximum: 40 }
  validates :email, length: { maximum: 255 }

  has_and_belongs_to_many :roles

  default_scope { where('deleted_at IS NULL') }

  scope :with_deleted, -> { unscoped.order('CASE WHEN deleted_at IS NULL THEN 0 ELSE 1 END, deleted_at ASC, id ASC') }

  # Include selected devise modules only not deliver email.
  devise :database_authenticatable, :trackable, :validatable, :rememberable

  def deleted?
    deleted_at.present?
  end

  def has_role?(role_key)
    roles.any? { |r| r.key.underscore.to_sym == role_key }
  end
end
