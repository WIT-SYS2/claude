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

require 'spec_helper'

describe User, '.new' do

  describe '.new' do
    let(:user) { FactoryGirl.build(:user) }
    subject { user }

    describe 'name' do
      context'nil の場合' do
        before { user.name = nil }
        it { should have(1).errors_on(:name) }
      end

      context '3文字の場合' do
        before { user.name = '123' }
        it { should have(1).errors_on(:name) }
      end

      context '4文字の場合' do
        before { user.name = '1234' }
        it { should have(:no).errors_on(:name) }
      end

      context '20文字の場合' do
        before { user.name = '1' * 20 }
        it { should have(:no).errors_on(:name) }
      end

      context '21文字の場合' do
        before { user.name = '1' * 21 }
        it { should have(1).errors_on(:name) }
      end
    end

    describe 'email' do
      context'空白の場合' do
        before { user.email = '' }
        it { should have(1).errors_on(:email) }
      end

      context '不正な形式の場合' do
        before { user.email = 'sample@example' }
        it { should have(1).errors_on(:email) }
      end

      context '正しい形式の場合' do
        before { user.email = 'user@example.com' }
        it { should have(:no).errors_on(:email) }
      end

      context '255文字の場合' do
        before { user.email = 'user@example.com'.rjust(255, '0') }
        it { should have(:no).errors_on(:email) }
      end

      context '256文字の場合' do
        before { user.email = 'user@example.com'.rjust(256, '0') }
        it { should have(1).errors_on(:email) }
      end
    end
  end

  describe '#deleted?' do
    let(:user) { FactoryGirl.build(:user) }
    subject { user.deleted? }

    context '削除日時が nil の場合' do
      before { user.deleted_at = nil }
      it { should be_false }
    end

    context '削除日時が設定されている場合' do
      before { user.deleted_at = DateTime.now }
      it { should be_true }
    end
  end

  describe '#has_role?' do
    before(:all) do
      FactoryGirl.create(:admin_role)
      FactoryGirl.create(:accountant_role)
    end

    let(:user) { FactoryGirl.create(:user) }

    describe ':admin' do
      subject { user.has_role?(:admin) }

      context 'システム管理者の場合' do
        before { user.roles << Role.find_by(key: 'admin') }
        it { should be_true }
      end

      context '経理担当者の場合' do
        before { user.roles << Role.find_by(key: 'accountant') }
        it { should be_false }
      end

      context '通常ユーザの場合' do
        it { user.has_role?(:admin).should be_false }
      end
    end

    describe ':accountant' do
      subject { user.has_role?(:accountant) }

      context 'システム管理者の場合' do
        before { user.roles << Role.find_by(key: 'admin') }
        it { should be_false }
      end

      context '経理担当者の場合' do
        before { user.roles << Role.find_by(key: 'accountant') }
        it { should be_true }
      end

      context '通常ユーザの場合' do
        it { should be_false }
      end
    end
  end
end
