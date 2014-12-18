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
  describe 'バリデーション' do
    describe 'ledger_number' do
      let(:ledger) { FactoryGirl.create(:settlement_ledger) }

      it 'nilの場合は無効であること' do
        ledger.ledger_number = nil
        expect(ledger).to have(1).error_on(:ledger_number)
      end

      it '9文字でない場合は無効であること' do
        ledger.ledger_number = 'ABC-2300019'
        expect(ledger).to have(1).error_on(:ledger_number)
      end

      it '重複している場合は無効であること' do
        ledger.ledger_number = FactoryGirl.create(:settlement_ledger).ledger_number
        expect(ledger).to have(1).error_on(:ledger_number)
      end
    end

    describe 'content' do
      it 'nilの場合は無効であること' do
        expect(SettlementLedger.new(content: nil)).to have(1).error_on(:content)
      end

      it '空白の場合は無効であること' do
        expect(SettlementLedger.new(content: '')).to have(1).error_on(:content)
      end

      it '1文字の場合は有効であること' do
        expect(SettlementLedger.new(content: '1')).to have(:no).error_on(:content)
      end

      it '40文字の場合は有効であること' do
        expect(SettlementLedger.new(content: '1' * 40)).to have(:no).error_on(:content)
      end

      it '41文字の場合は有効であること' do
        expect(SettlementLedger.new(content: '1' * 41)).to have(1).error_on(:content)
      end
    end

    describe 'note' do
      it 'nilの場合は無効であること' do
        expect(SettlementLedger.new(note: nil)).to have(1).error_on(:note)
      end

      it '空白の場合は無効であること' do
        expect(SettlementLedger.new(note: '')).to have(1).error_on(:note)
      end

      it '1文字の場合は有効であること' do
        expect(SettlementLedger.new(note: '1')).to have(:no).error_on(:note)
      end

      it '200文字の場合は有効であること' do
        expect(SettlementLedger.new(note: '1' * 200)).to have(:no).error_on(:note)
      end

      it '201文字の場合は無効であること' do
        expect(SettlementLedger.new(note: '1' * 201)).to have(1).error_on(:note)
      end
    end

    describe 'price' do
      it 'nilの場合は無効であること' do
        expect(SettlementLedger.new(price: nil)).to have(1).error_on(:price)
      end

      it '0の場合は無効であること' do
        expect(SettlementLedger.new(price: 0)).to have(1).error_on(:price)
      end

      it '1の場合は有効であること' do
        expect(SettlementLedger.new(price: 1)).to have(:no).error_on(:price)
      end

      it '999999の場合は有効であること' do
        expect(SettlementLedger.new(price: 999999)).to have(:no).error_on(:price)
      end

      it '1000000の場合は無効であること' do
        expect(SettlementLedger.new(price: 1000000)).to have(1).error_on(:price)
      end

      it '小数の場合は無効であること' do
        expect(SettlementLedger.new(price: 100.5)).to have(1).error_on(:price)
      end
    end

    describe 'application_date' do
      it 'nilの場合は無効であること' do
        expect(SettlementLedger.new(application_date: nil)).to have(1).error_on(:application_date)
      end

      it '日付を指定した場合は有効であること' do
        expect(SettlementLedger.new(application_date: Date.today)).to have(:no).error_on(:application_date)
      end
    end

    describe 'applicant_user_id' do
      it 'nilの場合は無効であること' do
        expect(SettlementLedger.new(applicant_user_id: nil)).to have(1).error_on(:applicant_user_id)
      end

      it '正しい値を指定した場合は有効であること' do
        expect(SettlementLedger.new(applicant_user_id: 1)).to have(:no).error_on(:applicant_user_id)
      end
    end

    describe 'applicant_user_name' do
      it 'nilの場合は無効であること' do
        expect(SettlementLedger.new(applicant_user_name: nil)).to have(1).error_on(:applicant_user_name)
      end

      it '空白の場合は無効であること' do
        expect(SettlementLedger.new(applicant_user_name: '')).to have(1).error_on(:applicant_user_name)
      end

      it '1文字の場合は有効であること' do
        expect(SettlementLedger.new(applicant_user_name: '1')).to have(:no).error_on(:applicant_user_name)
      end

      it '40文字の場合は有効であること' do
        expect(SettlementLedger.new(applicant_user_name: '1' * 40)).to have(:no).error_on(:applicant_user_name)
      end

      it '41文字の場合は無効であること' do
        expect(SettlementLedger.new(applicant_user_name: '1' * 41)).to have(1).error_on(:applicant_user_name)
      end
    end

    describe 'settlement_date' do
      it 'nilの場合は有効であること' do
        expect(SettlementLedger.new(settlement_date: nil)).to have(:no).error_on(:settlement_date)
      end

      it '日付を指定した場合は有効であること' do
        expect(SettlementLedger.new(settlement_date: Date.today)).to have(:no).error_on(:settlement_date)
      end
    end

    describe 'settlement_note' do
      it 'nilの場合は有効であること' do
        expect(SettlementLedger.new(settlement_note: nil)).to have(:no).error_on(:settlement_note)
      end

      it '40文字の場合は有効であること' do
        expect(SettlementLedger.new(settlement_note: '1' * 40)).to have(:no).error_on(:settlement_note)
      end

      it '41文字の場合は無効であること' do
        expect(SettlementLedger.new(settlement_note: '1' * 41)).to have(1).error_on(:settlement_note)
      end
    end

    describe 'completed_at' do
      it 'nilの場合は有効であること' do
        expect(SettlementLedger.new(completed_at: nil)).to have(:no).error_on(:completed_at)
      end
    end

    describe 'deleted_at' do
      it 'nilの場合は有効であること' do
        expect(SettlementLedger.new(deleted_at: nil)).to have(:no).error_on(:deleted_at)
      end
    end
  end

  describe '#completed?' do
    subject { ledger.completed? }
    let(:ledger) { FactoryGirl.build(:settlement_ledger, completed_at: completed_at) }

    context '完了日が設定されている場合' do
      let(:completed_at) { DateTime.now }
      it { is_expected.to be true }
    end

    context '完了日が設定されていない場合' do
      let(:completed_at) { nil }
      it { is_expected.to be false }
    end
  end

  describe '#deleted?' do
    subject { ledger.deleted? }
    let(:ledger) { FactoryGirl.build(:settlement_ledger, deleted_at: deleted_at) }

    context '削除日が設定されている場合' do
      let(:deleted_at) { DateTime.now }
      it { is_expected.to be true }
    end

    context '削除日が設定されていない場合' do
      let(:deleted_at) { nil }
      it { is_expected.to be false }
    end
  end

  describe '#to_xlsx_value' do
    let(:user) { FactoryGirl.create(:user) }
    let(:completed_at) { nil }
    let(:deleted_at) { nil }
    let(:ledger) {
      FactoryGirl.create(:settlement_ledger,
                         { content: '営業経費精算書',
                           note: '５月分',
                           price: 10800,
                           application_date: Date.today,
                           applicant_user_id: user.id,
                           applicant_user_name: user.name,
                           settlement_date: 3.days.since.to_date,
                           settlement_note: '完了しました',
                           completed_at: completed_at,
                           deleted_at: deleted_at })
    }

    it { expect(ledger.to_xlsx_value.size).to eq 10 }

    it { expect(ledger.to_xlsx_value[0]).to eq ledger.ledger_number }
    it { expect(ledger.to_xlsx_value[1]).to eq ledger.content }
    it { expect(ledger.to_xlsx_value[2]).to eq ledger.note }
    it { expect(ledger.to_xlsx_value[3]).to eq ledger.price }
    it { expect(ledger.to_xlsx_value[4]).to eq ledger.application_date }
    it { expect(ledger.to_xlsx_value[5]).to eq ledger.applicant_user_name }
    it { expect(ledger.to_xlsx_value[6]).to eq ledger.settlement_date }
    it { expect(ledger.to_xlsx_value[7]).to eq ledger.settlement_note }

    context '精算が完了している場合' do
      let(:completed_at) { Date.today }
      it { expect(ledger.to_xlsx_value[8]).to eq '○' }
    end

    context '精算が完了していない場合' do
      let(:completed_at) { nil }
      it { expect(ledger.to_xlsx_value[8]).to eq '×' }
    end

    context '削除されている場合' do
      let(:deleted_at) { Date.today }
      it { expect(ledger.to_xlsx_value[9]).to eq '○' }
    end

    context '削除されていない場合' do
      let(:deleted_at) { nil }
      it { expect(ledger.to_xlsx_value[9]).to eq '×' }
    end
  end

  describe '#assign_ledger_number' do
    let(:ledger) { FactoryGirl.build(:settlement_ledger, ledger_number: nil) }

    context '同年度の精算申請が存在しない場合' do
      before {
        FactoryGirl.create_list(:settlement_ledger, 10)
        SettlementLedger.all.each do |sl|
          new_ledger_number = sl.ledger_number.sub(Rails.configuration.ledger_number_prefix, Rails.configuration.ledger_number_prefix.succ)
          ActiveRecord::Base.connection.execute("UPDATE settlement_ledgers SET ledger_number = '#{new_ledger_number}' WHERE id = #{sl.id}")
        end
      }

      it { expect { ledger.send(:assign_ledger_number) }.to change(ledger, :ledger_number).to("#{Rails.configuration.ledger_number_prefix}001") }
    end

    context '同年度の精算申請が存在する場合' do
      before { FactoryGirl.create_list(:settlement_ledger, 10) }
      it { expect { ledger.send(:assign_ledger_number) }.to change(ledger, :ledger_number).to("#{Rails.configuration.ledger_number_prefix}011") }
    end
  end

  describe '#file_path' do
    let(:ledger) { FactoryGirl.create(:settlement_ledger) }
    it { expect(ledger.file_path).to eq "public/data/#{ledger.id}" }
  end
end