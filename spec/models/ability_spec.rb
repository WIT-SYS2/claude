require 'spec_helper'
require 'cancan/matchers'

describe Ability do

  subject { ability }

  let(:ability) { Ability.new(user) }
  let(:user) { FactoryGirl.create(:user) }

  context 'システム管理者の場合' do
    before do
      user.stub(:has_role?).with(:admin).and_return(true)
      user.stub(:has_role?).with(:treasurer).and_return(false)
    end

    it { should be_able_to(:manage, User) }
    it { should be_able_to(:read, SettlementLedger) }
    it { should be_able_to(:create, SettlementLedger) }
    it { should_not be_able_to(:manage, SettlementLedger) }

    context '自身が登録した申請の場合' do
      let(:target_settlement) { FactoryGirl.create(:settlement_ledger, applicant_user_id: user.id) }

      it { should be_able_to(:update, target_settlement) }
      it { should be_able_to(:destroy, target_settlement) }
    end

    context '他のユーザが登録した申請の場合' do
      let(:target_settlement) { FactoryGirl.create(:settlement_ledger, applicant_user_id: user.id + 1) }

      it { should_not be_able_to(:update, target_settlement) }
      it { should_not be_able_to(:destroy, target_settlement) }
    end
  end

  context '出納担当者の場合' do
    before do
      user.stub(:has_role?).with(:admin).and_return(false)
      user.stub(:has_role?).with(:treasurer).and_return(true)
    end
    
    it { should_not be_able_to(:manage, User) }
    it { should be_able_to(:manage, SettlementLedger) }

    context '自身が登録した申請の場合' do
      let(:target_settlement) { FactoryGirl.create(:settlement_ledger, applicant_user_id: user.id) }

      it { should be_able_to(:update, target_settlement) }
      it { should be_able_to(:destroy, target_settlement) }
    end

    context '他のユーザが登録した申請の場合' do
      let(:target_settlement) { FactoryGirl.create(:settlement_ledger, applicant_user_id: user.id + 1) }

      it { should be_able_to(:update, target_settlement) }
      it { should be_able_to(:destroy, target_settlement) }
    end
  end

  context '一般ユーザの場合' do
    before do
      user.stub(:has_role?).with(:admin).and_return(false)
      user.stub(:has_role?).with(:treasurer).and_return(false)
    end

    it { should_not be_able_to(:manage, User) }
    it { should be_able_to(:read, SettlementLedger) }
    it { should be_able_to(:create, SettlementLedger) }
    it { should_not be_able_to(:manage, SettlementLedger) }

    context '自身が登録した申請の場合' do
      let(:target_settlement) { FactoryGirl.create(:settlement_ledger, applicant_user_id: user.id) }

      it { should be_able_to(:update, target_settlement) }
      it { should be_able_to(:destroy, target_settlement) }
    end

    context '他のユーザが登録した申請の場合' do
      let(:target_settlement) { FactoryGirl.create(:settlement_ledger, applicant_user_id: user.id + 1) }

      it { should_not be_able_to(:update, target_settlement) }
      it { should_not be_able_to(:destroy, target_settlement) }
    end
  end
end
