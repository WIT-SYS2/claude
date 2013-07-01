# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(40)       not null
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
  validates :name, presence: true, length: { in: 1..20 }
  validates :password, confirmation: true,
                       length: { maximum: 40 }

  has_and_belongs_to_many :roles

  default_scope { where('deleted_at IS NULL') }

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def deleted?
    deleted_at.present?
  end

  def has_role?(role_key)
    roles.any? { |r| r.key.underscore.to_sym == role_key }
  end
end
