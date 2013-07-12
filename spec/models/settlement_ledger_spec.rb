# == Schema Information
#
# Table name: settlement_ledgers
#
#  id                  :integer          not null, primary key
#  ledger_number       :string(9)        not null
#  content             :string(40)       not null
#  note                :string(200)      not null
#  price               :integer          not null
#  application_date    :date             not null
#  applicant_user_id   :integer          not null
#  applicant_user_name :string(40)       not null
#  settlement_date     :date
#  settlement_note     :string(40)
#  completed_at        :datetime
#  deleted_at          :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe SettlementLedger do

  describe 'Validation' do
    let(:ledger) { FactoryGirl.create(:settlement_ledger) }
    subject { ledger }

    describe 'ledger_number' do
      context '正しい場合' do
        it { should have(:no).errors_on(:ledger_number) }
      end

      context 'nilの場合' do
        before { ledger.ledger_number = nil }
        it { should have(1).errors_on(:ledger_number) }
      end

      context '9文字でない場合' do
        before { ledger.ledger_number = 'TBT-2300019' }
        it { should have(1).errors_on(:ledger_number) }
      end

      context '重複している場合' do
        before do
          dup = FactoryGirl.create(:settlement_ledger)
          ledger.ledger_number = dup.ledger_number
        end
        it { should have(1).errors_on(:ledger_number)}
      end
    end

    describe 'content' do
      context 'nilの場合' do
        before { ledger.content = nil }
        it { should have(1).errors_on(:content) }
      end

      context '空白の場合' do
        before { ledger.content = '' }
        it { should have(1).errors_on(:content) }
      end

      context '1文字の場合' do
        before { ledger.content = '1' }
        it { should have(:no).errors_on(:content) }
      end

      context '40文字の場合' do
        before { ledger.content = '1' * 40 }
        it { should have(:no).errors_on(:content) }
      end

      context '41文字の場合' do
        before { ledger.content = '1' * 41 }
        it { should have(1).errors_on(:content) }
      end
    end

    describe 'note' do
      context 'nilの場合' do
        before { ledger.note = nil }
        it { should have(1).errors_on(:note) }
      end

      context '空白の場合' do
        before { ledger.note = '' }
        it { should have(1).errors_on(:note) }
      end

      context '1文字の場合' do
        before { ledger.note = '1' }
        it { should have(:no).errors_on(:note) }
      end

      context '200文字の場合' do
        before { ledger.note = '1' * 200 }
        it { should have(:no).errors_on(:note) }
      end

      context '201文字の場合' do
        before { ledger.note = '1' * 201 }
        it { should have(1).errors_on(:note) }
      end
    end

    describe 'price' do
      context 'nilの場合' do
        before { ledger.price = nil }
        it { should have(1).errors_on(:price) }
      end

      context '0の場合' do
        before { ledger.price = 0 }
        it { should have(1).errors_on(:price) }
      end

      context '1の場合' do
        before { ledger.price = 1 }
        it { should have(:no).errors_on(:price) }
      end

      context '999999の場合' do
        before { ledger.price = 999999 }
        it { should have(:no).errors_on(:price) }
      end

      context '1000000の場合' do
        before { ledger.price = 1000000 }
        it { should have(1).errors_on(:price) }
      end

      context '小数の場合' do
        before { ledger.price = 100.5 }
        it { should have(1).errors_on(:price) }
      end
    end

    describe 'application_date' do
      context 'nilの場合' do
        before { ledger.application_date = nil }
        it { should have(1).errors_on(:application_date) }
      end

      context '日付が指定されている場合' do
        before { ledger.application_date = Date.today }
        it { should have(:no).errors_on(:application_date) }
      end
    end

    describe 'applicant_user_id' do
      context 'nilの場合' do
        before { ledger.applicant_user_id = nil }
        it { should have(1).errors_on(:applicant_user_id) }
      end

      context '指定されている場合' do
        before { ledger.applicant_user_id = 1 }
        it { should have(:no).errors_on(:applicant_user_id) }
      end
    end

    describe 'settlement_note' do
      context 'nilの場合' do
        before { ledger.settlement_note = nil }
        it { should have(:no).errors_on(:settlement_note) }
      end

      context '40文字の場合' do
        before { ledger.settlement_note = '1' * 40 }
        it { should have(:no).errors_on(:settlement_note) }
      end

      context '41文字の場合' do
        before { ledger.settlement_note = '1' * 41 }
        it { should have(1).errors_on(:settlement_note) }
      end
    end
  end

  describe '#completed?' do
    subject { ledger.completed? }
    let(:ledger) { FactoryGirl.build(:settlement_ledger, completed_at: completed_at) }

    context '完了日が設定されている場合' do
      let(:completed_at) { DateTime.now }
      it { should be_true }
    end

    context '完了日が設定されていない場合' do
      let(:completed_at) { nil }
      it { should be_false }
    end
  end

  describe '#deleted?' do
    subject { ledger.deleted? }
    let(:ledger) { FactoryGirl.build(:settlement_ledger, deleted_at: deleted_at) }

    context '削除日が設定されている場合' do
      let(:deleted_at) { DateTime.now }
      it { should be_true }
    end

    context '削除日が設定されていない場合' do
      let(:deleted_at) { nil }
      it { should be_false }
    end
  end

  describe '#to_xlsx_value' do
    let(:ledger) { FactoryGirl.build(:settlement_ledger, applicant_user_id: FactoryGirl.create(:user).id) }

    subject { ledger.to_xlsx_value }

    its(:size) { should == 10 }

    describe '台帳No' do
      before { ledger.ledger_number = '123456789' }
      its([0]) { should == '123456789' }
    end

    describe '内容' do
      before { ledger.content = '営業経費精算書' }
      its([1]) { should == '営業経費精算書' }
    end

    describe '備考' do
      before { ledger.note = '５月分' }
      its([2]) { should == '５月分' }
    end

    describe '精算金額' do
      before { ledger.price = 12345 }
      its([3]) { should == 12345 }
    end

    describe '申請日' do
      before { ledger.application_date = Date.today }
      its([4]) { should == Date.today }
    end

    describe '申請者' do
      before { ledger.applicant_user_name = '利用者１' }
      its([5]) { should == '利用者１' }
    end

    describe '精算日' do
      before { ledger.settlement_date = Date.today }
      its([6]) { should == Date.today }
    end

    describe '精算備考' do
      before { ledger.settlement_note = '精算しました' }
      its([7]) { should == '精算しました' }
    end

    describe '精算完了' do
      context '完了している場合' do
        before { ledger.completed_at = DateTime.now }
        its([8]) { should == '○' }
      end
      context '未完了の場合' do
        before { ledger.completed_at = nil }
        its([8]) { should == '×' }
      end
    end

    describe '削除済み' do
      context '削除されている場合' do
        before { ledger.deleted_at = DateTime.now }
        its([9]) { subject; should == '○' }
      end
      context '削除されていない場合' do
        before { ledger.deleted_at = nil }
        its([9]) { should == '×' }
      end
    end
  end

  describe '#assign_ledger_number' do
    let(:ledger) { FactoryGirl.build(:settlement_ledger) }
    subject { ledger.ledger_number }

    context '同年度の精算申請が存在しない場合' do
      before do
        FactoryGirl.create_list(:settlement_ledger, 10)
        SettlementLedger.all.each do |sl|
          new_ledger_number = sl.ledger_number.sub(Rails.configuration.ledger_number_prefix, Rails.configuration.ledger_number_prefix.succ)
          ActiveRecord::Base.connection.execute("UPDATE settlement_ledgers SET ledger_number = '#{new_ledger_number}' WHERE id = #{sl.id}")
        end
        ledger.send(:assign_ledger_number)
      end

      it { should == Rails.configuration.ledger_number_prefix + '001' }
    end

    context '同年度の精算申請が存在し' do
      before do
        FactoryGirl.create_list(:settlement_ledger, 10)
      end

      context 'その申請が有効な場合' do
        before { ledger.send(:assign_ledger_number) }
        it { should == Rails.configuration.ledger_number_prefix + '011' }
      end

      context 'その申請が削除済の場合' do
        before do
          SettlementLedger.update_all(deleted_at: DateTime.now)
          ledger.send(:assign_ledger_number)
        end
        it { should == Rails.configuration.ledger_number_prefix + '011' }
      end
    end
  end
end

