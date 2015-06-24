#coding: utf-8

require '../spec_helper'

RSpec.describe SettlementLedgersController, :type => :controller do
#未精算のデータ作成 id: 962～965
let(:settlement_ledger) { create_list(:settlement_ledger, 4 ) }
#精算済みのデータ作成 id: 966～968
let(:settlement_ledger_completed) { create_list(:settlement_ledger, 3,
                                                            completed_at: DateTime.now )}
#削除済みのデータ作成 id: 969～971
let(:settlement_ledger_deleted) { create_list(:settlement_ledger, 3,
                                                            deleted_at: DateTime.now )}
#adminユーザ作成
let(:admin) { create(:admin) }

  describe "GET index" do

    context "ログインしている場合" do

      before do
        login_admin admin
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
        get :index
      end

      it "ステータスコード200が返ってくること" do
        settlement_ledgers = SettlementLedger.order('ledger_number DESC')
        expect(response).to be_success
      end
      it "一覧ページを取得していること" do
        settlement_ledgers = SettlementLedger.order('ledger_number DESC')
        expect(response).to render_template(:index)
        SettlementLedger.all.each do |a|
          p a.id
        end
        p settlement_ledger_deleted
      end

      context "一覧ページの「未完了」タブを表示する場合" do
      let(:settlement_ledger_params) { { :target => 'not-completed' } }
        it "未完了かつ削除されていない申請の一覧が表示されること" do
          settlement_ledgers = SettlementLedger.order('ledger_number DESC')
          expect(settlement_ledgers.not_completed.not_deleted.count).to eq(4)
        end
        it "表示の順番が台帳Noの降順になっていること" do
          settlement_ledgers = SettlementLedger.order('ledger_number DESC')
          expect(settlement_ledgers.first.ledger_number).to eq(SettlementLedger.last.ledger_number)
          expect(settlement_ledgers.last.ledger_number).to eq(SettlementLedger.first.ledger_number)
        end
      end

      context "一覧ページの「すべて」タブを表示する場合" do
      let(:settlement_ledger_params) { { target: all} }
        it "すべての情報が表示されること" do
          settlement_ledgers = SettlementLedger.order('ledger_number DESC')
          expect(settlement_ledgers.count).to eq(SettlementLedger.all.count)
        end
        it "表示の順番が台帳Noの降順になっていること" do
          settlement_ledgers = SettlementLedger.order('ledger_number DESC')
          expect(settlement_ledgers.first.ledger_number).to eq(SettlementLedger.last.ledger_number)
          expect(settlement_ledgers.last.ledger_number).to eq(SettlementLedger.first.ledger_number)
        end
      end

    end

    context "ログインしていない場合" do
      before do
        get :index
      end

      it "ステータスコード302が返ってくること" do
        expect(response.status).to eq(302)
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "GET new" do

    context "ログインしている場合" do
      before do
        login_admin admin
        get :new
      end
      it "ステータスコード200が返ってくること" do
        expect(response).to be_success
      end
      it "登録ページを取得していること" do
        expect(response).to render_template(:new)
      end
    end

    context "ログインしていない場合" do
      before do
        get :new
      end
      it "ステータスコード302が返ってくること" do
        expect(response.status).to eq(302)
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "GET edit" do

    context "ログインしている場合" do
      before do
        login_admin admin
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
        expected_settlement_ledger = create(:settlement_ledger)
        get :edit, id: expected_settlement_ledger.id
      end
      it "ステータスコード200が返ってくること" do
        expect(response).to be_success
      end
      
      context "編集可能な申請を選択した場合" do
        it "編集ページを取得していること" do
          expect(response).to render_template(:edit)
        end
      end

      context "編集不可能な申請を選択した場合" do

        context "既に削除された申請を選択した場合" do
          it "一覧ページが表示されること" do
            pending '未実装'
            get :edit, id: settlement_ledger_deleted.first.id
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に削除されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に削除されています。')
          end
        end

        context "既に精算が完了された申請を選択した場合" do
          it "一覧ページが表示されること" do
            pending '未実装'
            get :edit, id: settlement_ledger_completed.first.id
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に精算が完了されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に精算が完了されています。')
          end
        end

        context "作成されていない申請を選択した場合" do
          it "一覧ページが表示されること" do
            pending '未実装'
            get :edit, id: -1
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は編集できません。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は編集できません。')
          end
        end
      end

    end

    context "ログインしていない場合" do
      before do
        get :edit, id: 1
      end

      it "ステータスコード302が返ってくること" do
        expect(response.status).to eq(302)
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "POST create" do

    context "ログインしている場合" do
      before do
        login_admin admin
      end

      it "ステータスコード200が返ってくること" do
        expect(response).to be_success
      end

      context "申請の登録に成功した場合" do
        before do
          post :create, settlement_ledger: { ledger_number: "ABC-00001",
                                             content: "test",
                                             note: "test",
                                             price: 10000,
                                             application_date: Date.today,
                                             applicant_user_id: 1,
                                             applicant_user_name: "申請者" }
        end

        it "申請が正しく登録されていること" do
          expect(SettlementLedger.count).to eq(1)
        end
        it "一覧ページにリダイレクトされること" do
          expect(response).to redirect_to(settlement_ledgers_path)
        end
        it "精算申請を登録しました。というフラッシュメッセージが設定されること。" do
          expect(flash[:notice]).to eq('精算依頼を登録しました。')
        end
      end

      context "申請の登録に失敗した場合" do
        before do
          @settlement_ledger = create(SettlementLedger)
        end
        it "新規作成ページが表示されること" do
          allow(@settlement_ledger).to receive(:save).and_return(false)
          allow(SettlementLedger).to receive(:new).and_return(@settlement_ledger)
          post :create, settlement_ledger: { ledger_number: "ABC-00001",
                                             content: "test",
                                             note: "test",
                                             price: 10000,
                                             application_date: Date.today,
                                             applicant_user_id: 1,
                                             applicant_user_name: "申請者" }
          expect(response).to render_template(:new)
        end
      end

    end

    context "ログインしていない場合" do
      before do
         post:create
      end

      it "ステータスコード302が返ってくること" do
        expect(response.status).to eq(302)
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "PUT update" do

    context "ログインしている場合" do
      before do
        login_admin admin
      end

      it "ステータスコード200が返ってくること" do
        expect(response).to be_success
      end

      context "申請の更新に成功した場合" do
        before do
          @settlement_ledger = create(:settlement_ledger, id: 1,
                                      ledger_number: "ABC-99999",
                                      content: "test",
                                      note: "test",
                                      price: 10000,
                                      application_date: Date.yesterday,
                                      applicant_user_id: 1,
                                      applicant_user_name: "申請者")

          put :update, id: 1, settlement_ledger:{ content: "テスト",
                                                  note: "テスト",
                                                  price: 50000,
                                                  application_date: Date.today,
                                                  applicant_user_id: 99,
                                                  applicant_user_name: "テスト"}
        end

        it "更新処理が正しく行われていること" do
          expect(SettlementLedger.find(1)).not_to equal(@settlement_ledger)
        end
        it "一覧ページにリダイレクトされること" do
          expect(response).to redirect_to(settlement_ledgers_path)
        end
        it "精算申請を更新しました。というフラッシュメッセージが設定されること" do
          expect(flash[:notice]).to eq('精算依頼を更新しました。')
        end
      end

      context "申請の更新に失敗した場合" do
        before do
          login_admin admin
          settlement_ledger
          settlement_ledger_deleted
          settlement_ledger_completed
        end

        context "既に削除された申請を選択した場合" do
          before do
            put :update, id: 968, settlement_ledger:{ content: "テスト" }
          end

          it"申請の更新が行われていないこと" do 
            pending '未実装'
            expect(SettlementLedger.find(968).content).not_to eq("テスト")
          end
          it"一覧ページが表示されること" do 
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に削除されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に削除されています。')
          end
        end

        context "既に精算が完了された申請を選択した場合" do
          before do
            put :update, id: 971, settlement_ledger:{ content: "テスト" }
          end

          it"申請の更新が行われていないこと" do 
            pending '未実装'
            expect(SettlementLedger.find(971).content).not_to eq("テスト")
          end
          it "一覧ページが表示されること" do 
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に精算が完了されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に精算が完了されています。')
          end
        end

        context "作成されていない申請を選択した場合" do
          before do
            put :update, id: 971, settlement_ledger:{ content: "テスト" }
          end

          it"申請の更新が行われていないこと" do 
            pending '未実装'
            expect(SettlementLedger.find(971).content).not_to eq("テスト")
          end
          it "一覧ページが表示されること" do 
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は作成されていません。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は編集できません。')
          end
        end

      end

    end

    context "ログインしていない場合" do
      before do
         put :update, id: 1
      end
      it "ステータスコード302が返ってくること" do
        expect(response.status).to eq(302)
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "DELETE destroy" do

    context "ログインしている場合" do
      before do
        login_admin admin
      end

      it "ステータスコード200が返ってくること" do
        expect(response).to be_success
      end

      context "申請の削除に成功した場合" do
        before do
          @settlement_ledger = create_list(:settlement_ledger, 2)
        end
          
        it "削除処理が行われていること" do
          delete :destroy, id: 962
          expect(SettlementLedger.count).to eq(1)
        end
        it "一覧ページにリダイレクトされること" do
        end
      end

      context "申請の削除に失敗した場合" do

        context "既に削除された申請を選択した場合" do
          it "一覧ページが表示されること" do
          end
          it "選択した申請は既に削除されています。というフラッシュメッセージが設定されること" do
          end
        end

        context "作成されていない申請を選択した場合" do
          it "一覧ページが表示されること" do
          end
          it "選択した申請は作成されていません。というフラッシュメッセージが設定されること" do
          end
        end

      end

    end

    context "ログインしていない場合" do
      it "ステータスコード302が返ってくること" do
      end
      it "ログインページにリダイレクトされること" do
      end
    end

  end

  describe "GET download" do
    context "ログインしている場合" do
      it "ステータスコード200が返ってくること" do
      end
      it "ファイル名が「精算書一覧.xlsx」となっていること" do
      end
      it "ファイル形式がとエクセル形式となっていること" do
      end
    end

    context "ログインしていない場合" do
      it "ステータスコード302が返ってくること" do
      end
      it "ログインページにリダイレクトされること" do
      end
    end

  end

  describe "GET edit_for_settle" do

    context "ログインしている場合" do
      it "ステータスコード200が返ってくること" do
      end
      
      context "編集可能な申請を選択した場合" do
        it "精算ページを取得していること" do
        end
      end

      context "編集不可能な申請を選択した場合" do 
        it "一覧ページにリダイレクトされること" do
        end
        it "選択された申請は編集できません。というフラッシュメッセージが設定されること。" do
        end
      end

    end

    context "ログインしていない場合" do
      it "ステータスコード302が返ってくること" do
      end
      it "ログインページにリダイレクトされること" do
      end
    end

  end

  describe "PUT settle" do

    context "ログインしている場合" do
      it "ステータスコード200が返ってくること" do
      end

      context "精算を完了させる場合" do
        it "精算完了処理が行われていること" do
        end
      end

      context "精算を完了させない場合" do
        it "精算完了処理が行われていないこと" do
        end
      end

      context "精算に成功した場合" do
        it "一覧ページにリダイレクトされること" do
        end
        it "精算申請を更新しました。というフラッシュメッセージが設定されること。" do
        end
      end

      context "精算に失敗した場合" do

        context "既に削除された申請を選択した場合" do
          it "一覧ページが再度表示されること" do
          end
          it "選択した申請は既に削除されています。というフラッシュメッセージが設定されること" do
          end
        end

        context "既に精算が完了された申請を選択した場合" do
          it "一覧ページが再度表示されること" do
          end
          it "選択した申請は既に精算が完了されています。というフラッシュメッセージが設定されること" do
          end
        end

        context "存在しない申請を選択した場合" do
          it "一覧ページが表示されること" do
          end
          it "選択した申請は作成されていません。というフラッシュメッセージが設定されること" do
          end
        end

      end

    end

    context "ログインしていない場合" do
      it "ステータスコード302が返ってくること" do
      end
      it "ログインページにリダイレクトされること" do
      end
    end

  end

  describe "GET search" do

    context "ログインしている場合" do
      it "ステータスコード200が返ってくること" do
      end
      it "一覧ページを取得していること" do
      end
      it "スコープの「:like_content」が選択され正しい検索が行われていること" do
      end

      context "一覧ページの「未完了」タブを表示する場合" do
        it "未完了かつ未削除の申請の一覧が表示されること" do
        end
        it "表示の順番が台帳Noの降順になっていること" do
        end
      end

      context "一覧ページの「すべて」タブを表示する場合" do
        it "すべての情報が表示されること" do
        end
        it "表示の順番が台帳Noの降順になっていること" do
        end
      end

      context "検索条件が空の場合" do
        it "検索が行われていること" do
        end
        it "検索結果が一覧ページに表示されていること" do
        end
      end

      context "検索条件が空でない場合" do
        it "検索が行われていること" do
        end
        it "検索結果が一覧ページに表示されていること" do
        end
      end

    end
      
    context "ログインしていない場合" do
      it "ステータスコード302が返ってくること" do
      end
      it "ログインページにリダイレクトされること" do
      end
    end

  end

end 
