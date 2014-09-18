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
#  state            :string(255)
#  application_date :datetime         not null
#  approved_date    :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe ApplicationReport do
  describe 'バリデーション' do
    describe 'application_to' do
      it '未指定の場合は無効であること' do
        ApplicationReport.new(application_to: nil).should have(1).errors_on(:application_to)
      end

      it "40文字の場合は有効であること" do
        ApplicationReport.new(application_to: "a" * 40).should have(:no).errors_on(:application_to)
      end

      it "41文字の場合は無効であること" do
        ApplicationReport.new(application_to: "a" * 41).should have(1).errors_on(:application_to)
      end
    end

    describe 'user_id' do
      it '未指定の場合は無効であること' do
        ApplicationReport.new(user_id: nil).should have(1).errors_on(:user_id)
      end
    end

    describe 'user_name' do
      it '未指定の場合は無効であること' do
        ApplicationReport.new(user_name: nil).should have(1).errors_on(:user_name)
      end

      it "20文字の場合は有効であること" do
        ApplicationReport.new(user_name: "a" * 20).should have(:no).errors_on(:user_name)
      end

      it "21文字の場合は無効であること" do
        ApplicationReport.new(user_name: "a" * 21).should have(1).errors_on(:user_name)
      end
    end

    describe 'department_name' do
      it '未指定の場合は無効であること' do
        ApplicationReport.new(department_name: nil).should have(1).errors_on(:department_name)
      end

      it "40文字の場合は有効であること" do
        ApplicationReport.new(department_name: "a" * 40).should have(:no).errors_on(:department_name)
      end

      it "41文字の場合は無効であること" do
        ApplicationReport.new(department_name: "a" * 41).should have(1).errors_on(:department_name)
      end
    end

    describe 'kind' do
      it '未指定の場合は無効であること' do
        ApplicationReport.new(kind: nil).should have(1).errors_on(:kind)
      end

      it '無効な値を指定した場合は無効であること' do
        ApplicationReport.new(kind: 999).should have(1).errors_on(:kind)
      end
    end

    describe 'start_date' do
      it '未指定の場合でも有効であること' do
        ApplicationReport.new(start_date: nil).should have(:no).errors_on(:start_date)
      end
    end

    describe 'end_date' do
      it '未指定の場合でも有効であること' do
        ApplicationReport.new(end_date: nil).should have(:no).errors_on(:end_date)
      end
    end

    describe 'term_day' do
      it '未指定の場合でも有効であること' do
        ApplicationReport.new(term_day: nil).should have(:no).errors_on(:term_day)
      end

      it '0の場合は無効であること' do
        ApplicationReport.new(term_day: 0).should have(1).errors_on(:term_day)
      end

      it '1の場合は有効であること' do
        ApplicationReport.new(term_day: 1).should have(:no).errors_on(:term_day)
      end

      it '999の場合は有効であること' do
        ApplicationReport.new(term_day: 999).should have(:no).errors_on(:term_day)
      end

      it '1000の場合は無効であること' do
        ApplicationReport.new(term_day: 1000).should have(1).errors_on(:term_day)
      end
    end

    describe 'start_date_time' do
      it '未指定の場合でも有効であること' do
        ApplicationReport.new(start_date_time: nil).should have(:no).errors_on(:start_date_time)
      end
    end

    describe 'end_date_time' do
      it '未指定の場合でも有効であること' do
        ApplicationReport.new(end_date_time: nil).should have(:no).errors_on(:end_date_time)
      end
    end

    describe 'term_hour' do
      it '未指定の場合でも有効であること' do
        ApplicationReport.new(term_hour: nil).should have(:no).errors_on(:term_hour)
      end

      it '-1の場合は無効であること' do
        ApplicationReport.new(term_hour: -1).should have(1).errors_on(:term_hour)
      end

      it '0の場合は有効であること' do
        ApplicationReport.new(term_hour: 0).should have(:no).errors_on(:term_hour)
      end

      it '整数でない場合は無効であること' do
        ApplicationReport.new(term_hour: 5.5).should have(1).errors_on(:term_hour)
      end

      it '23の場合は有効であること' do
        ApplicationReport.new(term_hour: 23).should have(:no).errors_on(:term_hour)
      end

      it '24の場合は無効であること' do
        ApplicationReport.new(term_hour: 24).should have(1).errors_on(:term_hour)
      end
    end

    describe 'term_minutes' do
      it '未指定の場合でも有効であること' do
        ApplicationReport.new(term_minutes: nil).should have(:no).errors_on(:term_minutes)
      end

      it '-1の場合は無効であること' do
        ApplicationReport.new(term_minutes: -1).should have(1).errors_on(:term_minutes)
      end

      it '0の場合は有効であること' do
        ApplicationReport.new(term_minutes: 0).should have(:no).errors_on(:term_minutes)
      end

      it '整数でない場合は無効であること' do
        ApplicationReport.new(term_minutes: 50.5).should have(1).errors_on(:term_minutes)
      end

      it '59の場合は有効であること' do
        ApplicationReport.new(term_minutes: 59).should have(:no).errors_on(:term_minutes)
      end

      it '60の場合は無効であること' do
        ApplicationReport.new(term_minutes: 60).should have(1).errors_on(:term_minutes)
      end
    end

    describe 'reason' do
      it '未指定の場合は有効であること' do
        ApplicationReport.new(reason: nil).should have(:no).errors_on(:reason)
      end

      it "100文字の場合は有効であること" do
        ApplicationReport.new(reason: "a" * 100).should have(:no).errors_on(:reason)
      end

      it "101文字の場合は無効であること" do
        ApplicationReport.new(reason: "a" * 101).should have(1).errors_on(:reason)
      end
    end

    describe 'contact' do
      it '未指定の場合は有効であること' do
        ApplicationReport.new(contact: nil).should have(:no).errors_on(:contact)
      end

      it "100文字の場合は有効であること" do
        ApplicationReport.new(contact: "a" * 100).should have(:no).errors_on(:contact)
      end

      it "101文字の場合は無効であること" do
        ApplicationReport.new(contact: "a" * 101).should have(1).errors_on(:contact)
      end
    end

    describe 'tel' do
    end

    describe 'document' do
      it '未指定の場合は有効であること' do
        ApplicationReport.new(document: nil).should have(:no).errors_on(:document)
      end

      it "100文字の場合は有効であること" do
        ApplicationReport.new(document: "a" * 100).should have(:no).errors_on(:document)
      end

      it "101文字の場合は無効であること" do
        ApplicationReport.new(document: "a" * 101).should have(1).errors_on(:document)
      end
    end

    describe 'note' do
      it '未指定の場合は有効であること' do
        ApplicationReport.new(note: nil).should have(:no).errors_on(:note)
      end

      it "255文字の場合は有効であること" do
        ApplicationReport.new(note: "a" * 255).should have(:no).errors_on(:note)
      end

      it "256文字の場合は無効であること" do
        ApplicationReport.new(note: "a" * 256).should have(1).errors_on(:note)
      end
    end

    describe 'state' do
      it '未指定の場合は無効であること' do
        ApplicationReport.new(state: nil).should have(1).errors_on(:state)
      end
    end

    describe 'application_date' do
      it '未指定の場合は無効であること' do
        ApplicationReport.new(application_date: nil).should have(1).errors_on(:application_date)
      end
    end

    describe 'approved_date' do
      it '未指定の場合は有効であること' do
        ApplicationReport.new(approved_date: nil).should have(:no).errors_on(:approved_date)
      end
    end
  end
end
