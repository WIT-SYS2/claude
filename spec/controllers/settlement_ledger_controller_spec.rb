#coding: utf-8

require '../spec_helper'

RSpec.describe SettlementLedgersController, :type => :controller do
#adminユーザ作成
def login
  admin = create(:admin)
  admin_role = create(:admin_role)
  treasurer_role = create(:treasurer_role)
  admin.roles << [admin_role, treasurer_role]
  login_admin admin
end
#未精算のデータ作成 id: 962～965
let(:settlement_ledger) { create_list(:settlement_ledger, 4, 
                                                        content: "未精算・未削除") }
#削除済みのデータ作成 id: 966～968
let(:settlement_ledger_deleted) { create_list(:settlement_ledger, 3,
                                                                content: "削除済",
                                                                deleted_at: DateTime.now )}
#精算済みのデータ作成 id: 969～971
let(:settlement_ledger_completed) { create_list(:settlement_ledger, 3,
                                                                  content: "精算済",
                                                                  completed_at: DateTime.now )}

  describe "GET index" do

    context "ログインしている場合" do

      before do
        login
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
      end

      context "レコードが0件の場合" do
        before do
          SettlementLedger.delete_all
          get :index
        end
        
        it "ステータスコード200が返ってくること" do
          expect(response).to be_success
        end
        it "一覧ページを取得していること" do
          expect(response).to render_template(:index)
        end
        it "表示されるデータが存在しないこと" do
          expect(assigns[:settlement_ledgers].count).to eq(0)
        end
      end

      context "レコードが1件以上ある場合" do
        it "ステータスコード200が返ってくること" do
          get :index
          expect(response).to be_success
        end
        it "一覧ページを取得していること" do
          get :index
          expect(response).to render_template(:index)
        end
        
        context "一覧ページの「未完了」タブを表示する場合" do
          before do
            get :index, target: 'not-completed'
          end
          it "未完了かつ削除されていない申請の一覧が表示されること" do
            expect(assigns[:settlement_ledgers].all? { |s| s.deleted_at.nil? }).to be_truthy
            expect(assigns[:settlement_ledgers].all? { |s| s.completed_at.nil? }).to be_truthy
            expect(assigns[:settlement_ledgers].all? { |s| s.deleted_at.nil? and s.completed_at.nil? }).to be_truthy
            expect(assigns[:settlement_ledgers].count).to eq(4)
            expect(assigns[:settlement_ledgers].find(962).ledger_number).to eq("ABC-00001") 
            expect(assigns[:settlement_ledgers].find(963).ledger_number).to eq("ABC-00002") 
            expect(assigns[:settlement_ledgers].find(964).ledger_number).to eq("ABC-00003") 
            expect(assigns[:settlement_ledgers].find(965).ledger_number).to eq("ABC-00004") 
          end
          it "表示の順番が台帳Noの降順になっていること" do
            expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settlement_ledger.last.ledger_number)
            expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settlement_ledger.first.ledger_number)
          end
        end
        
        context "一覧ページの「すべて」タブを表示する場合" do
          before do
            get :index, target: 'all'
          end
          it "すべての情報が表示されること" do
            expect(assigns[:settlement_ledgers].count).to eq(10)
            expect(assigns[:settlement_ledgers].find(962).ledger_number).to eq("ABC-00001") 
            expect(assigns[:settlement_ledgers].find(963).ledger_number).to eq("ABC-00002") 
            expect(assigns[:settlement_ledgers].find(964).ledger_number).to eq("ABC-00003") 
            expect(assigns[:settlement_ledgers].find(965).ledger_number).to eq("ABC-00004") 
            expect(assigns[:settlement_ledgers].find(966).ledger_number).to eq("ABC-00005") 
            expect(assigns[:settlement_ledgers].find(967).ledger_number).to eq("ABC-00006") 
            expect(assigns[:settlement_ledgers].find(968).ledger_number).to eq("ABC-00007") 
            expect(assigns[:settlement_ledgers].find(969).ledger_number).to eq("ABC-00008") 
            expect(assigns[:settlement_ledgers].find(970).ledger_number).to eq("ABC-00009") 
            expect(assigns[:settlement_ledgers].find(971).ledger_number).to eq("ABC-00010") 
          end
          it "表示の順番が台帳Noの降順になっていること" do
            expect(assigns[:settlement_ledgers].first.ledger_number).to eq(SettlementLedger.last.ledger_number)
            expect(assigns[:settlement_ledgers].last.ledger_number).to eq(SettlementLedger.first.ledger_number)
          end
        end
      
      end
    end

    context "ログインしていない場合" do
      before do
        get :index
      end

      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "GET new" do

    context "ログインしている場合" do
      before do
        login
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
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "GET edit" do

    context "ログインしている場合" do
      before do
        login
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
      end

      it "ステータスコード200が返ってくること" do
        get :edit, id: settlement_ledger.first.id
        expect(response).to be_success
      end
      
      context "編集可能な申請を選択した場合" do
        it "編集ページを取得していること" do
          get :edit, id: settlement_ledger.first.id
          expect(response).to render_template(:edit)
        end
      end

      context "編集不可能な申請を選択した場合" do

        context "既に削除された申請を選択した場合" do
          before do
            get :edit, id: settlement_ledger_deleted.first.id
          end

          it "ステータスコード302が返ってくること" do
            pending '未実装'
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に削除されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に削除されています。')
          end
        end

        context "既に精算が完了された申請を選択した場合" do
          before do
            get :edit, id: settlement_ledger_completed.first.id
          end

          it "ステータスコード302が返ってくること" do
            pending '未実装'
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に精算が完了されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に精算が完了されています。')
          end
        end

        context "作成されていない申請を選択した場合" do
          before do
            pending '未実装'
            get :edit, id: -1
          end

          it "ステータスコード302が返ってくること" do
            pending '未実装'
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            pending '未実装'
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
        get :edit, id: -1
      end

      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "POST create" do

    context "ログインしている場合" do
      before do
        login
      end

      context "申請の登録に成功した場合" do
        before do
          post :create, settlement_ledger: { content: "test",
                                             note: "test",
                                             price: 10000, 
                                             application_date: Date.today}
        end
        
        it "申請者が、現在ログインしているユーザになっていること" do
          expect(assigns[:settlement_ledger].applicant_user_id).to eq(1)
          expect(assigns[:settlement_ledger].applicant_user_name).to eq("システム管理者")
        end
        it "申請が正しく登録されていること" do
          expect(assigns[:settlement_ledger].id).to eq(SettlementLedger.first.id)
          expect(assigns[:settlement_ledger].ledger_number).to eq(SettlementLedger.first.ledger_number)
          expect(assigns[:settlement_ledger].content).to eq(SettlementLedger.first.content)
          expect(assigns[:settlement_ledger].note).to eq(SettlementLedger.first.note)
          expect(assigns[:settlement_ledger].price).to eq(SettlementLedger.first.price)
          expect(assigns[:settlement_ledger].application_date).to eq(SettlementLedger.first.application_date)
          expect(assigns[:settlement_ledger].applicant_user_id).to eq(SettlementLedger.first.applicant_user_id)
          expect(assigns[:settlement_ledger].applicant_user_name).to eq(SettlementLedger.first.applicant_user_name)
        end
        it "ステータスコード302が返ってくること" do
          expect(response).to be_redirect
        end
        it "一覧ページにリダイレクトされること" do
          expect(response).to redirect_to(settlement_ledgers_path)
        end
        it "精算依頼を登録しました。というフラッシュメッセージが設定されること。" do
          expect(flash[:notice]).to eq('精算依頼を登録しました。')
        end
      end

      context "申請の登録に失敗した場合" do
        before do
          settlement_ledgers = build(SettlementLedger)
          allow(settlement_ledgers).to receive(:save).and_return(false)
          allow(SettlementLedger).to receive(:new).and_return(settlement_ledgers)
          post :create, settlement_ledger: { content: "test",
                                             note: "test",
                                             price: 10000,
                                             application_date: Date.today }
        end
        it "登録処理が行われていないこと" do
          expect(SettlementLedger.count).to eq(0)
        end
        it "新規作成ページが表示されること" do
          expect(response).to render_template(:new)
        end
      end

    end

    context "ログインしていない場合" do
      before do
         post:create
      end

      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "PUT update" do

    context "ログインしている場合" do
      before do
        login
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
      end

      context "申請の更新に成功した場合" do
        before do
          put :update, id: settlement_ledger.first.id, settlement_ledger:{ content: "テスト" }
        end

        it "更新処理が正しく行われていること" do
          expect(SettlementLedger.find(settlement_ledger.first.id).id).to eq(settlement_ledger.first.id)
          expect(SettlementLedger.find(settlement_ledger.first.id).ledger_number).to eq(settlement_ledger.first.ledger_number)
          expect(SettlementLedger.find(settlement_ledger.first.id).content).to eq("テスト")
          expect(SettlementLedger.find(settlement_ledger.first.id).note).to eq(settlement_ledger.first.note)
          expect(SettlementLedger.find(settlement_ledger.first.id).price).to eq(settlement_ledger.first.price)
          expect(SettlementLedger.find(settlement_ledger.first.id).application_date).to eq(settlement_ledger.first.application_date)
          expect(SettlementLedger.find(settlement_ledger.first.id).applicant_user_id).to eq(settlement_ledger.first.applicant_user_id)
          expect(SettlementLedger.find(settlement_ledger.first.id).applicant_user_name).to eq(settlement_ledger.first.applicant_user_name)
        end
        it "ステータスコード302が返ってくること" do
          expect(response).to be_redirect
        end
        it "一覧ページにリダイレクトされること" do
          expect(response).to redirect_to(settlement_ledgers_path)
        end
        it "精算依頼を更新しました。というフラッシュメッセージが設定されること" do
          expect(flash[:notice]).to eq('精算依頼を更新しました。')
        end
      end

      context "申請の更新に失敗した場合" do

        context "既に削除された申請を選択した場合" do
          before do
            put :update, id: settlement_ledger_deleted.first.id, settlement_ledger:{ content: "テスト" }
          end

          it"申請の更新が行われていないこと" do 
            pending '未実装'
            expect(SettlementLedger.find(settlement_ledger_deleted.first.id).content).not_to eq("テスト")
          end
          it "ステータスコード302が返ってくること" do
            expect(response).to be_redirect
          end
          it"一覧ページにリダイレクトされること" do 
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に削除されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に削除されています。')
          end
        end

        context "既に精算が完了された申請を選択した場合" do
          before do
            put :update, id: settlement_ledger_completed.first.id, settlement_ledger:{ content: "テスト" }
          end

          it"申請の更新が行われていないこと" do 
            pending '未実装'
            expect(SettlementLedger.find(settlement_ledger_completed.first.id).content).not_to eq("テスト")
          end
          it "ステータスコード302が返ってくること" do
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do 
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に精算が完了されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に精算が完了されています。')
          end
        end

        context "作成されていない申請を選択した場合" do
          before do
            pending '未実装'
            put :update, id: -1, settlement_ledger:{ content: "テスト" }
          end

          it"申請の更新が行われていないこと" do 
            pending '未実装'
            expect(SettlementLedger.find(-1).content).not_to eq("テスト")
          end
          it "ステータスコード302が返ってくること" do
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do 
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
         put :update, id: -1
      end
      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "DELETE destroy" do

    context "ログインしている場合" do
      before do
        login
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
      end

      context "申請の削除に成功した場合" do
        before do
          allow(SettlementLedger).to receive(:find).and_return(settlement_ledger.first)
          delete :destroy, id: settlement_ledger.first.id
        end

        it "削除処理が行われていること" do
          expect(settlement_ledger.first.deleted_at).not_to eq(nil) 
        end
        it "ステータスコード302が返ってくること" do
          expect(response).to be_redirect
        end
        it "一覧ページにリダイレクトされること" do
          expect(response).to redirect_to(settlement_ledgers_path)
        end
      end

      context "申請の削除に失敗した場合" do

        context "既に削除された申請を選択した場合" do
          before do
            allow(SettlementLedger).to receive(:find).and_return(settlement_ledger_deleted.first)
            delete :destroy, id: settlement_ledger_deleted.first.id
          end

          it "申請の削除が行われていないこと" do
            pending '未実装'
            expect(settlement_ledger_deleted.first.deleted_at).to eq(nil) 
          end
          it "一覧ページにリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択した申請は既に削除されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に削除されています。')
          end
        end

        context "既に精算された申請を選択した場合" do
          before do
            allow(SettlementLedger).to receive(:find).and_return(settlement_ledger_completed.first)
            delete :destroy, id: settlement_ledger_completed.first.id
          end

          it "申請の削除が行われていないこと" do
            pending '未実装'
            expect(settlement_ledger_completed.first.completed_at).to eq(nil) 
          end
          it "一覧ページにリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択した申請は既に精算が完了されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に精算が完了されています。')
          end
        end

        context "作成されていない申請を選択した場合" do
          before do
            pending '未実装'
            delete :destroy, id: -1
          end

          it "申請の削除が行われていないこと" do
            pending '未実装'
            expect(settlement_ledger.first.deleted_at).to eq(nil) 
          end
          it "一覧ページにリダイレクトされること" do
            pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択した申請は作成されていません。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に精算が完了されています。')
          end
        end

      end

    end

    context "ログインしていない場合" do
      before do
        settlement_ledger
        delete :destroy, id: -1
      end
      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "GET download" do

    context "ログインしている場合" do
      before do
        login
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
        get :download
      end

      it "ステータスコード200が返ってくること" do
        expect(response).to be_success
      end
      it "ファイル名が「精算書一覧.xlsx」となっていること" do
        expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"精算書一覧.xlsx\"")
      end
      it "ファイル形式がエクセル形式となっていること" do
        expect(response.content_type).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      end
    end

    context "ログインしていない場合" do
      before do
        get :download
      end

      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "GET edit_for_settle" do

    context "ログインしている場合" do
      before do
        login
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
      end

      context "編集可能な申請を選択した場合" do
        before do
          get :edit_for_settle, id: settlement_ledger.first.id
        end

        it "ステータスコード200が返ってくること" do
          expect(response).to be_success
        end
        it "精算ページを取得していること" do
          expect(response).to render_template(:edit_for_settle)
        end
      end

      context "編集不可能な申請を選択した場合" do 

        context "既に削除された申請を選択した場合" do
          before do
            get :edit_for_settle, id: settlement_ledger_deleted.first.id
          end

          it "ステータスコード302が返ってくること" do
            pending '未実装'
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に削除されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に削除されています。')
          end
        end

        context "既に精算が完了された申請を選択した場合" do
          before do
            get :edit_for_settle, id: settlement_ledger_completed.first.id
          end

          it "ステータスコード302が返ってくること" do
            pending '未実装'
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は既に精算が完了されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に精算が完了されています。')
          end
        end

        context "作成されていない申請を選択した場合" do
          before do
            pending '未実装'
            get :edit_for_settle, id: -1
          end

          it "ステータスコード302が返ってくること" do
            pending '未実装'
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択された申請は精算できません。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は精算できません。')
          end
        end
      end

    end

    context "ログインしていない場合" do
      before do
        get :edit_for_settle, id: -1
      end

      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "PUT settle" do

    context "ログインしている場合" do
      before do
        login
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
      end

      context "精算に成功した場合" do

        context "精算を完了させる場合" do
          before do
            put :settle, id: settlement_ledger.first.id, settlement_ledger:{ settlement_date: Date.today,
                                                                             settlement_note: "test",
                                                                             completed: "1" }
          end
  
          it "ステータスコード302が返ってくること" do
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "精算完了処理が行われていること" do
            expect(SettlementLedger.find(settlement_ledger.first.id).completed_at).not_to eq(nil)
          end
          it "精算処理が行われていること" do
            expect(SettlementLedger.find(settlement_ledger.first.id).settlement_date).to eq(Date.today)
          end
          it "精算依頼を更新しました。というフラッシュメッセージが設定されること。" do
              expect(flash[:notice]).to eq('精算依頼を更新しました。')
          end
        end

        context "精算を完了させない場合" do
          before do
            put :settle, id: settlement_ledger.first.id, settlement_ledger:{ settlement_date: Date.today,
                                                                             settlement_note: "test",
                                                                             completed: "0" }
          end
          it "ステータスコード302が返ってくること" do
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "精算完了処理が行われていないこと" do
            expect(SettlementLedger.find(settlement_ledger.first.id).completed_at).to eq(nil)
          end
          it "精算処理が行われていること" do
            expect(SettlementLedger.find(settlement_ledger.first.id).settlement_date).to eq(Date.today)
          end
          it "精算依頼を更新しました。というフラッシュメッセージが設定されること。" do
            expect(flash[:notice]).to eq('精算依頼を更新しました。')
          end
        end

      end

      context "精算に失敗した場合" do

        context "既に削除された申請を選択した場合" do
          before do
            put :settle, id: settlement_ledger_deleted.first.id, settlement_ledger:{ settlement_date: Date.today,
                                                                                     settlement_note: "test" }
          end

          it "精算処理が行われていないこと" do
            pending '未実装'
            expect(SettlementLedger.find(settlement_ledger_deleted.first.id).settlement_date).not_to eq(Date.today)
          end
          it "ステータスコード302が返ってくること" do
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択した申請は既に削除されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に削除されています。')
          end
        end

        context "既に精算が完了された申請を選択した場合" do
          before do
            put :settle, id: settlement_ledger_completed.first.id, settlement_ledger:{ settlement_date: Date.today,
                                                                                       settlement_note: "test" }
          end

          it "精算処理が行われていないこと" do
            pending '未実装'
            expect(SettlementLedger.find(settlement_ledger_completed.first.id).settlement_date).not_to eq(Date.today)
          end
          it "ステータスコード302が返ってくること" do
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択した申請は既に精算が完了されています。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は既に精算が完了されています。')
          end
        end

        context "存在しない申請を選択した場合" do
          before do
            pending '未実装'
            put :settle, id: -1, settlement_ledger:{ settlement_date: Date.today,
                                                     settlement_note: "test" }
          end

          it "精算処理が行われていないこと" do
            pending '未実装'
            expect(SettlementLedger.find(-1).settlement_date).not_to eq(Date.today)
          end
          it "ステータスコード302が返ってくること" do
            expect(response).to be_redirect
          end
          it "一覧ページにリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_path)
          end
          it "選択した申請は作成されていません。というフラッシュメッセージが設定されること" do
            pending '未実装'
            expect(flash[:notice]).to eq('選択された申請は作成されていません。')
          end
        end

      end

    end

    context "ログインしていない場合" do
      before do
          put :settle, id: -1
      end

      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "GET search" do

    context "ログインしている場合" do
      before do
        login
        settlement_ledger
        settlement_ledger_deleted
        settlement_ledger_completed
      end

      context "レコードが0件の場合" do
        before do
          SettlementLedger.delete_all
          get :search
        end
        
        it "ステータスコード200が返ってくること" do
          expect(response).to be_success
        end
        it "一覧ページを取得していること" do
          expect(response).to render_template(:index)
        end
        it "表示されるデータが存在しないこと" do
          expect(assigns[:settlement_ledgers].count).to eq(0)
        end
      end

      context "レコードが1件以上ある場合" do
        before do
          get :search
        end

        it "ステータスコード200が返ってくること" do
          expect(response).to be_success
        end
        it "一覧ページを取得していること" do
          expect(response).to render_template(:index)
        end

        context "一覧ページの「未完了」タブを表示する場合" do
          before do
            get :index, target: 'not-completed'
          end
          it "未完了かつ削除されていない申請の一覧が表示されること" do
            expect(assigns[:settlement_ledgers].all? { |s| s.deleted_at.nil? }).to be_truthy
            expect(assigns[:settlement_ledgers].all? { |s| s.completed_at.nil? }).to be_truthy
            expect(assigns[:settlement_ledgers].all? { |s| s.deleted_at.nil? and s.completed_at.nil? }).to be_truthy
            expect(assigns[:settlement_ledgers].count).to eq(4)
            expect(assigns[:settlement_ledgers].find(962).ledger_number).to eq("ABC-00001") 
            expect(assigns[:settlement_ledgers].find(963).ledger_number).to eq("ABC-00002") 
            expect(assigns[:settlement_ledgers].find(964).ledger_number).to eq("ABC-00003") 
            expect(assigns[:settlement_ledgers].find(965).ledger_number).to eq("ABC-00004") 
          end
          it "表示の順番が台帳Noの降順になっていること" do
            expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settlement_ledger.last.ledger_number)
            expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settlement_ledger.first.ledger_number)
          end
        end

        context "一覧ページの「すべて」タブを表示する場合" do
          before do
            get :index, target: 'all'
          end
          it "すべての情報が表示されること" do
            expect(assigns[:settlement_ledgers].count).to eq(10)
            expect(assigns[:settlement_ledgers].find(962).ledger_number).to eq("ABC-00001") 
            expect(assigns[:settlement_ledgers].find(963).ledger_number).to eq("ABC-00002") 
            expect(assigns[:settlement_ledgers].find(964).ledger_number).to eq("ABC-00003") 
            expect(assigns[:settlement_ledgers].find(965).ledger_number).to eq("ABC-00004") 
            expect(assigns[:settlement_ledgers].find(966).ledger_number).to eq("ABC-00005") 
            expect(assigns[:settlement_ledgers].find(967).ledger_number).to eq("ABC-00006") 
            expect(assigns[:settlement_ledgers].find(968).ledger_number).to eq("ABC-00007") 
            expect(assigns[:settlement_ledgers].find(969).ledger_number).to eq("ABC-00008") 
            expect(assigns[:settlement_ledgers].find(970).ledger_number).to eq("ABC-00009") 
            expect(assigns[:settlement_ledgers].find(971).ledger_number).to eq("ABC-00010") 
          end
          it "表示の順番が台帳Noの降順になっていること" do
            expect(assigns[:settlement_ledgers].first.ledger_number).to eq(SettlementLedger.last.ledger_number)
            expect(assigns[:settlement_ledgers].last.ledger_number).to eq(SettlementLedger.first.ledger_number)
          end
        end

      end

      context "検索結果が0件の場合" do

        it "検索が行われていること" do
          get :search, content: "test"
          expect(assigns[:settlement_ledgers].count).to eq(0)
        end
      end

      context "検索条件が空の場合" do

        it "検索が行われていること" do
          get :search, content: ""
          expect(assigns[:settlement_ledgers].count).to eq(SettlementLedger.count)
        end
      end

      context "検索条件が空でない場合" do

        it "検索が行われていること" do
          get :search, content: "未精算"
          expect(assigns[:settlement_ledgers].count).to eq(settlement_ledger.count)
        end
      end

    end
      
    context "ログインしていない場合" do
      before do
        get :search
      end

      it "ステータスコード302が返ってくること" do
        expect(response).to be_redirect
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

end 
