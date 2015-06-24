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

describe User do
  describe 'バリデーション' do
    describe 'name' do
      it '未指定の場合は無効であること' do
        expect(User.new(name: nil)).to have(1).error_on(:name)
      end

      it '3文字の場合は無効であること' do
        expect(User.new(name: '123')).to have(1).error_on(:name)
      end

      it '4文字の場合は有効であること' do
        expect(User.new(name: '1234')).to have(:no).error_on(:name)
      end

      it '20文字の場合は有効であること' do
        expect(User.new(name: '1' * 20)).to have(:no).error_on(:name)
      end

      it '21文字の場合は無効であること' do
        expect(User.new(name: '1' * 21)).to have(1).error_on(:name)
      end
    end

    describe 'email' do
      it '未指定の場合は無効であること' do
        expect(User.new(email: '')).to have(1).error_on(:email)
      end

      it '不正な形式の場合は無効であること' do
        expect(User.new(email: 'sample@example')).to have(1).error_on(:email)
      end
      
      it '正しい形式の場合は有効であること' do
        expect(User.new(email: 'sample@example.com')).to have(:no).error_on(:email)
      end

      it '255文字の場合は有効であること' do
        expect(User.new(email: 'sample@example.com'.rjust(255, '0'))).to have(:no).error_on(:email)
      end

      it '256文字の場合は無効であること' do
        expect(User.new(email: 'sample@example.com'.rjust(256, '0'))).to have(1).error_on(:email)
      end
    end
  end

  describe '#deleted?' do
    let(:user) { FactoryGirl.build(:user, deleted_at: deleted_at) }
    let(:deleted_at) { nil }
    subject { user.deleted? }

    context '削除日時が nil の場合' do
      let(:deleted_at) { nil }
      it { is_expected.to be false }
    end

    context '削除日時が設定されている場合' do
      let(:deleted_at) { DateTime.now }
      it { is_expected.to be true }
    end
  end

  describe '#has_role?' do
    before do
      FactoryGirl.create(:admin_role)
      FactoryGirl.create(:treasurer_role)
    end

    let(:admin_role) { Role.find_by(key: 'admin') }
    let(:treasurer_role) { Role.find_by(key: 'treasurer') }

    let(:user) { FactoryGirl.create(:user) }

    describe ':admin' do
      subject { user.has_role?(:admin) }

      context 'システム管理者の場合' do
        before { user.roles << admin_role }
        it { is_expected.to be true }
      end

      context '経理担当者の場合' do
        before { user.roles << treasurer_role }
        it { is_expected.to be false }
      end

      context '通常ユーザの場合' do
        it { is_expected.to be false }
      end
    end

    describe ':treasurer' do
      subject { user.has_role?(:treasurer) }

      context 'システム管理者の場合' do
        before { user.roles << admin_role }
        it { is_expected.to be false }
      end

      context '経理担当者の場合' do
        before { user.roles << treasurer_role }
        it { is_expected.to be true }
      end

      context '通常ユーザの場合' do
        it { is_expected.to be false }
      end
    end
  end
end
