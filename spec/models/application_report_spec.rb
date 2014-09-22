# == Schema Information
#
# Table name: application_reports
#
#  id               :integer          not null, primary key
#  application_to   :string(40)       not null
#  user_id          :integer          not null
#  user_name        :string(20)       not null
#  department_name  :string(40)       not null
#  kind             :integer          not null
#  start_date       :date
#  end_date         :date
#  term_day         :integer
#  start_date_time  :datetime
#  end_date_time    :datetime
#  term_hour        :integer
#  term_minutes     :integer
#  reason           :string(100)
#  contact          :string(100)
#  tel              :string(20)
#  document         :string(100)
#  note             :string(255)
#  status           :integer          default(1), not null
#  application_date :date             not null
#  approved_date    :date
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe ApplicationReport do
  describe 'バリデーション' do
    describe 'application_to' do
      it '未指定の場合は無効であること' do
        expect(ApplicationReport.new(application_to: nil)).to have(1).errors_on(:application_to)
      end

      it "40文字の場合は有効であること" do
        expect(ApplicationReport.new(application_to: "a" * 40)).to have(:no).errors_on(:application_to)
      end

      it "41文字の場合は無効であること" do
        expect(ApplicationReport.new(application_to: "a" * 41)).to have(1).errors_on(:application_to)
      end
    end

    describe 'user_id' do
      it '未指定の場合は無効であること' do
        expect(ApplicationReport.new(user_id: nil)).to have(1).errors_on(:user_id)
      end
    end

    describe 'user_name' do
      it '未指定の場合は無効であること' do
        expect(ApplicationReport.new(user_name: nil)).to have(1).errors_on(:user_name)
      end

      it "20文字の場合は有効であること" do
        expect(ApplicationReport.new(user_name: "a" * 20)).to have(:no).errors_on(:user_name)
      end

      it "21文字の場合は無効であること" do
        expect(ApplicationReport.new(user_name: "a" * 21)).to have(1).errors_on(:user_name)
      end
    end

    describe 'department_name' do
      it '未指定の場合は無効であること' do
        expect(ApplicationReport.new(department_name: nil)).to have(1).errors_on(:department_name)
      end

      it "40文字の場合は有効であること" do
        expect(ApplicationReport.new(department_name: "a" * 40)).to have(:no).errors_on(:department_name)
      end

      it "41文字の場合は無効であること" do
        expect(ApplicationReport.new(department_name: "a" * 41)).to have(1).errors_on(:department_name)
      end
    end

    describe 'kind' do
      it '未指定の場合は無効であること' do
        expect(ApplicationReport.new(kind: nil)).to have(1).errors_on(:kind)
      end

      it '無効な値を指定した場合は無効であること' do
        expect(ApplicationReport.new(kind: 999)).to have(1).errors_on(:kind)
      end
    end

    describe 'start_date' do
      it '未指定の場合でも有効であること' do
        expect(ApplicationReport.new(start_date: nil)).to have(:no).errors_on(:start_date)
      end
    end

    describe 'end_date' do
      it '未指定の場合でも有効であること' do
        expect(ApplicationReport.new(end_date: nil)).to have(:no).errors_on(:end_date)
      end
    end

    describe 'term_day' do
      it '未指定の場合でも有効であること' do
        expect(ApplicationReport.new(term_day: nil)).to have(:no).errors_on(:term_day)
      end

      it '0の場合は無効であること' do
        expect(ApplicationReport.new(term_day: 0)).to have(1).errors_on(:term_day)
      end

      it '1の場合は有効であること' do
        expect(ApplicationReport.new(term_day: 1)).to have(:no).errors_on(:term_day)
      end

      it '999の場合は有効であること' do
        expect(ApplicationReport.new(term_day: 999)).to have(:no).errors_on(:term_day)
      end

      it '1000の場合は無効であること' do
        expect(ApplicationReport.new(term_day: 1000)).to have(1).errors_on(:term_day)
      end
    end

    describe 'start_date_time' do
      it '未指定の場合でも有効であること' do
        expect(ApplicationReport.new(start_date_time: nil)).to have(:no).errors_on(:start_date_time)
      end
    end

    describe 'end_date_time' do
      it '未指定の場合でも有効であること' do
        expect(ApplicationReport.new(end_date_time: nil)).to have(:no).errors_on(:end_date_time)
      end
    end

    describe 'term_hour' do
      it '未指定の場合でも有効であること' do
        expect(ApplicationReport.new(term_hour: nil)).to have(:no).errors_on(:term_hour)
      end

      it '-1の場合は無効であること' do
        expect(ApplicationReport.new(term_hour: -1)).to have(1).errors_on(:term_hour)
      end

      it '0の場合は有効であること' do
        expect(ApplicationReport.new(term_hour: 0)).to have(:no).errors_on(:term_hour)
      end

      it '整数でない場合は無効であること' do
        expect(ApplicationReport.new(term_hour: 5.5)).to have(1).errors_on(:term_hour)
      end

      it '23の場合は有効であること' do
        expect(ApplicationReport.new(term_hour: 23)).to have(:no).errors_on(:term_hour)
      end

      it '24の場合は無効であること' do
        expect(ApplicationReport.new(term_hour: 24)).to have(1).errors_on(:term_hour)
      end
    end

    describe 'term_minutes' do
      it '未指定の場合でも有効であること' do
        expect(ApplicationReport.new(term_minutes: nil)).to have(:no).errors_on(:term_minutes)
      end

      it '-1の場合は無効であること' do
        expect(ApplicationReport.new(term_minutes: -1)).to have(1).errors_on(:term_minutes)
      end

      it '0の場合は有効であること' do
        expect(ApplicationReport.new(term_minutes: 0)).to have(:no).errors_on(:term_minutes)
      end

      it '整数でない場合は無効であること' do
        expect(ApplicationReport.new(term_minutes: 50.5)).to have(1).errors_on(:term_minutes)
      end

      it '59の場合は有効であること' do
        expect(ApplicationReport.new(term_minutes: 59)).to have(:no).errors_on(:term_minutes)
      end

      it '60の場合は無効であること' do
        expect(ApplicationReport.new(term_minutes: 60)).to have(1).errors_on(:term_minutes)
      end
    end

    describe 'reason' do
      it '未指定の場合は有効であること' do
        expect(ApplicationReport.new(reason: nil)).to have(:no).errors_on(:reason)
      end

      it "100文字の場合は有効であること" do
        expect(ApplicationReport.new(reason: "a" * 100)).to have(:no).errors_on(:reason)
      end

      it "101文字の場合は無効であること" do
        expect(ApplicationReport.new(reason: "a" * 101)).to have(1).errors_on(:reason)
      end
    end

    describe 'contact' do
      it '未指定の場合は有効であること' do
        expect(ApplicationReport.new(contact: nil)).to have(:no).errors_on(:contact)
      end

      it "100文字の場合は有効であること" do
        expect(ApplicationReport.new(contact: "a" * 100)).to have(:no).errors_on(:contact)
      end

      it "101文字の場合は無効であること" do
        expect(ApplicationReport.new(contact: "a" * 101)).to have(1).errors_on(:contact)
      end
    end

    describe 'tel' do
      it '未指定の場合は有効であること' do
        expect(ApplicationReport.new(tel: nil)).to have(:no).errors_on(:tel)
      end

      it '空白の場合は有効であること' do
        expect(ApplicationReport.new(tel: '')).to have(:no).errors_on(:tel)
      end

      it '20文字の場合は有効であること' do
        expect(ApplicationReport.new(tel: '1' * 20)).to have(:no).errors_on(:tel)
      end

      it '21文字の場合は無効であること' do
        expect(ApplicationReport.new(tel: '1' * 21)).to have(1).errors_on(:tel)
      end

      it '数字・ハイフン以外の文字が含まれる場合は無効であること' do
        expect(ApplicationReport.new(tel: '000-0000-000A')).to have(1).errors_on(:tel)
      end
    end

    describe 'document' do
      it '未指定の場合は有効であること' do
        expect(ApplicationReport.new(document: nil)).to have(:no).errors_on(:document)
      end

      it "100文字の場合は有効であること" do
        expect(ApplicationReport.new(document: "a" * 100)).to have(:no).errors_on(:document)
      end

      it "101文字の場合は無効であること" do
        expect(ApplicationReport.new(document: "a" * 101)).to have(1).errors_on(:document)
      end
    end

    describe 'note' do
      it '未指定の場合は有効であること' do
        expect(ApplicationReport.new(note: nil)).to have(:no).errors_on(:note)
      end

      it "255文字の場合は有効であること" do
        expect(ApplicationReport.new(note: "a" * 255)).to have(:no).errors_on(:note)
      end

      it "256文字の場合は無効であること" do
        expect(ApplicationReport.new(note: "a" * 256)).to have(1).errors_on(:note)
      end
    end

    describe 'status' do
      let(:target) { FactoryGirl.create(:application_report) }

      it '未指定の場合は無効であること' do
        target.status = nil
        expect(target).to have(1).errors_on(:status)
      end

      it '有効でない値を指定した場合は無効であること' do
        target.status = 99
        expect(target).to have(1).errors_on(:status)
      end
    end

    describe 'application_date' do
      it '未指定の場合は無効であること' do
        expect(ApplicationReport.new(application_date: nil)).to have(1).errors_on(:application_date)
      end
    end

    describe 'approved_date' do
      it '未指定の場合は有効であること' do
        expect(ApplicationReport.new(approved_date: nil)).to have(:no).errors_on(:approved_date)
      end
    end
  end
end
