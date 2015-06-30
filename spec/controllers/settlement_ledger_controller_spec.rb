# coding: utf-8

require 'spec_helper'


RSpec.describe SettlementLedgersController, :type => :controller do
  def login
    admin = FactoryGirl.create(:admin)
    admin_role = FactoryGirl.create(:admin_role)
    treasurer_role = FactoryGirl.create(:treasurer_role)
    admin.roles << [admin_role, treasurer_role]
    login_admin admin
  end
  let(:settle_default) { FactoryGirl.create_list(:settlement_ledger, 4, demand: '要望。') }
  let(:settle_deleted) { FactoryGirl.create_list(:settlement_ledger, 3, 
                                              content: '出張精算書' , 
                                              note: '6月10日～6月15日',
                                              price: 30000, 
                                              application_date: Date.yesterday, 
                                              applicant_user_id: 2, 
                                              applicant_user_name: '利用者',
                                              completed_at: nil,
                                              deleted_at: DateTime.yesterday) }
  let(:settle_completed){FactoryGirl.create_list(:settlement_ledger, 2,
                                              content:  '経費精算書',
                                              note: '7月10日～7月15日',
                                              price: 40000,
                                              application_date:  Date.today.ago(2.days),
                                              applicant_user_id: 2,
                                              applicant_user_name: '希望者',
                                              completed_at: DateTime.yesterday,
                                              deleted_at: nil )}

  describe "GET 'index'" do
    context "ログインしている場合" do
      before do
        login
        settle_default
        settle_deleted
        settle_completed
      end

      context "表示切替タブの'すべて'を選択している場合" do
        context "検索機能を使っている場合" do


          context "内容に関する検索機能を使っている場合" do
            before do
              get :index, target: 'all', content: '営業経費'
            end

            it "内容に営業経費が含まれる申請書が抜き出されていること" do
              expect(assigns[:settlement_ledgers].count).to eq(settle_default.count)
              expect(assigns[:settlement_ledgers].all? {|n| n.content.include?('営業経費')}).to be_truthy
            end

            it "申請書を台帳Noの降順に並べる処理が行われていること" do
              expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settle_default.last.ledger_number)
              expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settle_default.first.ledger_number)
            end


            it "ステータスコードが200であること" do
              expect(response.status).to eq(200)
            end

            it "精算申請一覧画面が表示されること" do
              expect(response).to render_template(:index)
            end
          end


          context "備考に関する検索機能を使っている場合" do
            before do
              get :index, target: 'all', note: '5月10日'
            end

            it "備考に5月10日が含まれる申請書が抜き出されていること" do
              expect(assigns[:settlement_ledgers].count).to eq(settle_default.count)
              expect(assigns[:settlement_ledgers].all? {|n| n.note.include?('5月10日')}).to be_truthy
            end

            it "申請書を台帳Noの降順に並べる処理が行われていること" do
              expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settle_default.last.ledger_number)
              expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settle_default.first.ledger_number)
            end

            it "ステータスコードが200であること" do
              expect(response.status).to eq(200)
            end

            it "精算申請一覧画面が表示されること" do
              expect(response).to render_template(:index)
            end
          end


          context "精算金額(下限)に関する検索機能を使っている場合" do
            before do
              get :index, target: 'all', under_price: 35000
            end

            it "金額が35,000円以上の申請書が抜き出されていること" do
              expect(assigns[:settlement_ledgers].count).to eq(settle_completed.count)
              expect(assigns[:settlement_ledgers].all? {|n| n.price >= 35000}).to be_truthy
            end

            it "申請書を台帳Noの降順に並べる処理が行われていること" do
              expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settle_completed.last.ledger_number)
              expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settle_completed.first.ledger_number)
            end

            it "ステータスコードが200であること" do
              expect(response.status).to eq(200)
            end

            it "精算申請一覧画面が表示されること" do
              expect(response).to render_template(:index)
            end
          end


          context "精算金額(上限)に関する検索機能を使っている場合" do
            before do
              get :index, target: 'all', over_price: 25000
            end

            it "金額が25,000円以下の申請書が抜き出されていること" do
              expect(assigns[:settlement_ledgers].count).to eq(settle_default.count)
              expect(assigns[:settlement_ledgers].all? {|n| n.price <= 25000}).to be_truthy
            end

            it "申請書を台帳Noの降順に並べる処理が行われていること" do
              expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settle_default.last.ledger_number)
              expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settle_default.first.ledger_number)
            end

            it "ステータスコードが200であること" do
              expect(response.status).to eq(200)
            end

            it "精算申請一覧画面が表示されること" do
              expect(response).to render_template(:index)
            end
          end


          context "要望に関する検索機能を使っている場合" do
            before do
              get :index, target: 'all', demand: '要望'
            end

            it "要望に要望が含まれる申請書が抜き出されていること" do
              expect(assigns[:settlement_ledgers].count).to eq(settle_default.count)
              expect(assigns[:settlement_ledgers].all? {|n| n.demand.include?('要望')}).to be_truthy
            end

            it "申請書を台帳Noの降順に並べる処理が行われていること" do
              expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settle_default.last.ledger_number)
              expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settle_default.first.ledger_number)
            end

            it "ステータスコードが200であること" do
              expect(response.status).to eq(200)
            end

            it "精算申請一覧画面が表示されること" do
              expect(response).to render_template(:index)
            end
          end


          context "申請日に関する検索機能を使っている場合" do
            before do
              get :index, target: 'all', application_date: Date.today
            end

            it "申請日が今日の日付の申請書が抜き出されていること" do
              expect(assigns[:settlement_ledgers].count).to eq(settle_default.count)
              expect(assigns[:settlement_ledgers].all? {|n| n.application_date == Date.today}).to be_truthy
            end

            it "申請書を台帳Noの降順に並べる処理が行われていること" do
              expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settle_default.last.ledger_number)
              expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settle_default.first.ledger_numbe)
            end

            it "ステータスコードが200であること" do
              expect(response.status).to eq(200)
            end

            it "精算申請一覧画面が表示されること" do
              expect(response).to render_template(:index)
            end
          end


          context "申請者に関する検索機能を使っている場合" do
            before do
              get :index, target: 'all', applicant_user_name: '申請者'
            end
            
            it "申請者に申請者が含まれる申請書が抜き出されていること" do
              expect(assigns[:settlement_ledgers].count).to eq(settle_default.count)
              expect(assigns[:settlement_ledgers].all? {|n| n.applicant_user_name.include?('申請者')}).to be_truthy
            end
            
            it "申請書を台帳Noの降順に並べる処理が行われていること" do
              expect(assigns[:settlement_ledgers].first.ledger_number).to eq(settle_default.last.ledger_number)
              expect(assigns[:settlement_ledgers].last.ledger_number).to eq(settle_default.first.ledger_number)
            end

            it "ステータスコードが200であること" do
              expect(response.status).to eq(200)
            end

            it "精算申請一覧画面が表示されること" do
              expect(response).to render_template(:index)
            end
          end
        end

        context "検索機能を使っていない場合" do
          before do
            get :index, target: 'all'
          end

          it "検索機能による申請書の抜き出しが行われていないこと" do
            expect(assigns[:settlement_ledgers].count).to eq(SettlementLedger.count)
          end
          
          it "申請書を台帳Noの降順に並べる処理が行われていること" do
            expect(assigns[:settlement_ledgers].first.ledger_number).to eq(SettlementLedger.last.ledger_number)
            expect(assigns[:settlement_ledgers].last.ledger_number).to eq(SettlementLedger.first.ledger_number)
          end

          it "ステータスコードが200であること" do
            expect(response.status).to eq(200)
          end

          it "精算申請一覧画面が表示されること" do
            expect(response).to render_template(:index)
          end
        end
      end


      context "表示切替タブの'すべて'を選択していない場合" do
        before do
          get :index, target: 'not-completed'
        end
        
        it "精算済みでも削除済みでもない申請書のみが抜き出されていること" do
          expect(assigns[:settlement_ledgers].count).to eq(SettlementLedger.not_completed.not_deleted.count)
          expect(assigns[:settlement_ledgers].all? {|n| n.completed_at.nil?}).to be_truthy
          expect(assigns[:settlement_ledgers].all? {|n| n.deleted_at.nil?}).to be_truthy
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "精算申請一覧画面が表示されること" do
          expect(response).to render_template(:index)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        get :index
      end

      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET new" do
    context "ログインしている場合" do
      before do
        login
        get :new
      end
      it "ステータスコードが200であること" do
        expect(response.status).to eq(200)
      end
      it "精算申請の新規作成画面が表示されていること" do
        expect(response).to render_template(:new)
      end
    end

    context "ログインしていない場合" do
      before do
        get :new
      end

      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    context "ログインしている場合" do
      before do
        login
        settle_default
        settle_deleted
        settle_completed

      end

      context "存在する申請書を指定した場合" do
        context "指定した申請書が削除済みの場合" do
          before do
            settlement_ledger = SettlementLedger.deleted.first
            get :edit, id: settlement_ledger.id
          end
          it "ステータスコードが302であること" do
            #pending '未実装'
            expect(response.status).to eq(302)
          end


          it "精算申請一覧画面にリダイレクトされること" do
            #pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end


        context "指定した申請書が精算済みの場合" do
          before do
            settlement_ledger = SettlementLedger.completed.first
            get :edit, id: settlement_ledger.id
          end
          it "ステータスコードが302であること" do
            #pending '未実装'
            expect(response.status).to eq(302)
          end


          it "精算申請一覧画面にリダイレクトされること" do
            #pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end


        context "指定した申請書が削除も精算もされていない場合" do
          before do
            settlement_ledger = SettlementLedger.not_deleted.not_completed.first
            get :edit, id: settlement_ledger.id
          end
          it "精算申請の編集画面が表示されること" do
            expect(response).to render_template(:edit)
          end

          it "ステータスコードが200であること" do
            expect(response.status).to eq(200)
          end

          it "指定した申請書のidと編集画面のidが一致していること" do
            expect(assigns[:settlement_ledger].id).to eq(SettlementLedger.not_deleted.not_completed.first.id)
          end
        end
      end

      context "存在しない申請書を指定した場合" do
        it "申請書が存在しないエラーが発生すること" do
          expect(lambda{put :update, id: -1}).to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        settle_default
        settle_deleted
        settle_completed

        settlement_ledger = SettlementLedger.not_deleted.not_completed.first
        get :edit, id: settlement_ledger.id
      end
      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    context "ログインしている場合" do
      before do
        login
      end
      
      context "申請書の登録に成功した場合" do
        before do
          params = {content: '営業経費精算書',
                    note: '5月10日～5月12日',
                    price: 20000,
                    demand: '要望。',
                    application_date: Date.today}
          post :create, settlement_ledger: params
        end

        it "申請書の登録ができていること" do
          expect(assigns[:settlement_ledger].content).to eq('営業経費精算書')
          expect(assigns[:settlement_ledger].note).to eq('5月10日～5月12日')
          expect(assigns[:settlement_ledger].price).to eq(20000)
          expect(assigns[:settlement_ledger].demand).to eq('要望。')
          expect(assigns[:settlement_ledger].application_date).to eq(Date.today)
        end

        it "ステータスコードが302であること" do
          expect(response.status).to eq(302)
        end

        it "登録成功のメッセージが設定されていること" do
          expect(flash[:notice]).to eq('精算依頼を登録しました。')
        end
        it "精算申請一覧画面にリダイレクトされること" do
          expect(response).to redirect_to(settlement_ledgers_url)
        end
      end

      context "申請書の登録に失敗した場合" do
        before do
          params = {ledger_number: 'AAA-00001',
                    content: '営業経費精算書',
                    note: '5月10日～5月12日',
                    price: 20000,
                    demand: '要望。',
                    application_date: Date.today,
                    pplicant_user_id: 1,
                    applicant_user_name: '申請者'}
          settlement_ledger = FactoryGirl.build(:settlement_ledger)
          allow(settlement_ledger).to receive(:save).and_return(false)
          allow(SettlementLedger).to receive(:new).and_return(settlement_ledger)
          post :create, settlement_ledger: params
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "精算申請の新規作成画面が表示されること" do
          expect(response).to render_template(:new)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        params = {ledger_number: 'AAA-00001',
                  content: '営業経費精算書',
                  note: '5月10日～5月12日',
                  price: 20000,
                  demand: '要望。',
                  application_date: Date.today,
                  pplicant_user_id: 1,
                  applicant_user_name: '申請者'}
        settlement_ledger = FactoryGirl.build(:settlement_ledger)
        allow(settlement_ledger).to receive(:save).and_return(true)
        allow(SettlementLedger).to receive(:new).and_return(settlement_ledger)
        post :create, settlement_ledger: params
      end
      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "PUT update" do
    context "ログインしている場合" do
      before do
        login
        settle_default
        settle_deleted
        settle_completed
      end

      context "存在する申請書を指定した場合" do
        context "指定した申請書が削除済みの場合" do
          before do
            settlement_ledger = SettlementLedger.deleted.first
            put :update, id: settlement_ledger.id, settlement_ledger: {
              content: 'test',
              note: 'test',
              price: 5000
            }
          end

          it "更新処理が行われないこと" do
            #pending '未実装'
            expect(assigns[:settlement_ledger].content).not_to eq('test')
            expect(assigns[:settlement_ledger].note).not_to eq('test')
            expect(assigns[:settlement_ledger].price).not_to eq(5000)
          end

          it "ステータスコードが302であること" do
            expect(response.status).to eq(302)
          end

          it "精算申請一覧画面にリダイレクトされること" do
            #pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end
        context "指定した申請書が精算済みの場合" do
          before do
            settlement_ledger = SettlementLedger.completed.first
            put :update, id: settlement_ledger.id, settlement_ledger: {
              content: 'test',
              note: 'test',
              price: 5000
            }
          end

          it "更新処理が行われないこと" do
            #pending '未実装'
            expect(assigns[:settlement_ledger].content).not_to eq('test')
            expect(assigns[:settlement_ledger].note).not_to eq('test')
            expect(assigns[:settlement_ledger].price).not_to eq(5000)
          end
          it "精算申請一覧画面にリダイレクトされること" do
            #pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end

        context "指定した申請書が削除も精算もされていない場合" do
          context "申請書の更新に成功した場合" do
            before do
              settlement_ledger = SettlementLedger.not_deleted.not_completed.first
              allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
              put :update, id: settlement_ledger.id, settlement_ledger: {
                content: "test",
                note: "test",
                price: 5000,
                demand: "test。"
              }
            end
            it "更新処理が行われていること" do
              expect(assigns[:settlement_ledger].content).to eq("test")
              expect(assigns[:settlement_ledger].note).to eq("test")
              expect(assigns[:settlement_ledger].price).to eq(5000)
              expect(assigns[:settlement_ledger].demand).to eq("test。")
            end

            it "ステータスコードが302であること" do
              expect(response.status).to eq(302)
            end

            it "更新成功のメッセージが設定されていること" do
              expect(flash[:notice]).to eq('精算依頼を更新しました。')
            end
            it "精算申請一覧画面にリダイレクトされること" do
              expect(response).to redirect_to(settlement_ledgers_url)
            end

          end

          context "申請書の更新に失敗した場合" do
            before do
              settlement_ledger = SettlementLedger.not_deleted.not_completed.first
              allow(settlement_ledger).to receive(:update).and_return(false)
              allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
              put :update, id: settlement_ledger.id, settlement_ledger: {
                content: "test",
                note: "test",
                price: 5000
              }
            end
            it "精算申請の編集画面が表示されること" do
              expect(response).to render_template(:edit)
            end
          end
       end
      end

      context "存在しない申請書を指定した場合" do
        it "申請書が存在しないエラーが発生すること" do
          expect(lambda{put :update, id: -1}).to raise_error(ActiveRecord::RecordNotFound)
        end
      end

    end

    context "ログインしていない場合" do
      before do
        settle_default
        settle_deleted
        settle_completed

        settlement_ledger = SettlementLedger.not_deleted.not_completed.first
        allow(settlement_ledger).to receive(:update).and_return(true)
        allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
        put :update, id: settlement_ledger.id, settlement_ledger: {
          content: "test",
          note: "test",
          price: 5000
        }
        
      end
      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe  "DELETE destroy" do
    context "ログインしている場合" do
      before do
        login
        settle_default
        settle_deleted
        settle_completed
      end

      context "存在する申請書を指定した場合" do
        context "指定した申請書が削除済みの場合" do
          before do
            settlement_ledger = SettlementLedger.deleted.first
            allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
            delete :destroy, id: settlement_ledger.id
          end
          it "申請書を削除する処理を行わないこと" do
            #pending '未実装'
            expect(assigns[:settlement_ledger].deleted_at).to eq(DateTime.yesterday.to_time)
          end
          it "ステータスコードが302であること" do
            expect(response.status).to eq(302)
          end
          it "精算申請一覧画面にリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end

        context "指定した申請書が精算済みの場合" do
          before do
            settlement_ledger = SettlementLedger.completed.first
            allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
            delete :destroy, id: settlement_ledger.id
          end

          it "申請書を削除する処理を行わないこと" do
            #pending '未実装'
            expect(assigns[:settlement_ledger].deleted_at).to eq(nil)
          end
          it "ステータスコードが302であること" do
            expect(response.status).to eq(302)
          end
          it "精算申請一覧画面にリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end


        context "指定した申請書が削除も精算もされていない場合" do
          before do
            settlement_ledger = SettlementLedger.not_completed.not_deleted.first
            allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
            delete :destroy, id: settlement_ledger.id
          end

          it "申請書を削除する処理が行われていること" do
            expect(assigns[:settlement_ledger].deleted_at).not_to eq(nil)
            #expect(assigns[:settlement_ledger].deleted_at).to be >= DateTime.now - 1
          end
          it "ステータスコードが302であること" do
            expect(response.status).to eq(302)
          end
          it "精算申請一覧画面にリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end
      end
      context "存在しない申請書を指定した場合" do
        it "申請書が存在しないエラーが発生すること" do
          expect(lambda{delete :destroy, id: -1}).to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "ログインしていない場合" do
      before do
        settle_default
        settle_deleted
        settle_completed

        settlement_ledger = SettlementLedger.not_deleted.not_completed.first
        allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
        delete :destroy, id: settlement_ledger.id
      end
      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET download" do
    context "ログインしている場合" do
      before do
        login
        settle_default
        settle_deleted
        settle_completed
        get :download
      end
      it "ステータスコードが200であること" do
        expect(response.status).to eq(200)
      end
      it "ファイル名が'精算所一覧.xlsxになっていること" do
        expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"精算書一覧.xlsx\"")
      end
      it "ファイルがエクセル形式になっていること" do
        expect(response.content_type).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      end
    end
    context "ログインしていない場合" do
      before do
        get :download
      end
      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit_for_settle" do
    context "ログインしている場合" do
      before do
        login
        settle_default
        settle_deleted
        settle_completed
      end

      context "存在する申請書が指定された場合" do
        context "指定した申請書が削除済みの場合" do
          before do
            settlement_ledger = SettlementLedger.deleted.first
            get :edit_for_settle, id: settlement_ledger.id
          end
          it "ステータスコードが302であること" do
            #pending '未実装'
            expect(response.status).to eq(302)
          end
          it "精算申請一覧画面にリダイレクトされること" do
            #pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end


        context "指定した申請書が精算済みの場合" do
          before do
            settlement_ledger = SettlementLedger.completed.first
            get :edit_for_settle, id: settlement_ledger.id
          end
          it "ステータスコードが302であること" do
            #pending '未実装'
            expect(response.status).to eq(302)
          end
          it "精算申請一覧画面にリダイレクトされること" do
            #pending '未実装'
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end


        context "指定した申請書が削除も精算もされていない場合" do
          before do
            settlement_ledger = SettlementLedger.not_completed.not_deleted.first 
            get :edit_for_settle, id: settlement_ledger
          end
          it "ステータスコードが200であること" do
            expect(response.status).to eq(200)
          end
          it "精算結果の登録画面が表示されること" do
            expect(response).to render_template(:edit_for_settle)
          end
          it "指定した申請書のidと精算結果の登録画面の申請書のidが一致していること" do
            expect(assigns[:settlement_ledger].id).to eq(SettlementLedger.not_completed.not_deleted.first.id)
          end
        end

      end
      context "存在しない申請書を指定した場合" do
        it "申請書が存在しないエラーが発生すること" do
          expect(lambda{get :edit_for_settle, id: -1}).to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
    context "ログインしていない場合" do
      before do
        settle_default
        settle_deleted
        settle_completed

        settlement_ledger = SettlementLedger.not_deleted.not_completed.first
        get :edit_for_settle, id: settlement_ledger.id
      end

      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "PUT settle" do
    context "ログインしている場合" do
      before do
        login
        settle_default
        settle_deleted
        settle_completed
      end

      context "存在する申請書を指定した場合" do
        context "指定した申請書が削除済みの場合" do
          before do
            settlement_ledger = SettlementLedger.deleted.first
            allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
            put :settle, id: settlement_ledger.id,  settlement_ledger: {
              completed: 1, 
              settlement_date: Date.today, 
              settlement_note: 'test' 
            }
          end

          it "申請書の更新がされていないこと" do
            #pending '未実装'
            expect(assigns[:settlement_ledger].completed).to eq(nil)
            expect(assigns[:settlement_ledger].completed).not_to eq(DateTime.now -1)
            expect(assigns[:settlement_ledger].settlement_date).not_to eq(Date.today)
            expect(assigns[:settlement_ledger].settlement_note).not_to eq('test')
          end

          it "ステータスコードが302であること" do
            expect(response.status).to eq(302)
          end

          it "精算申請一覧画面にリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end
      
        context "指定した申請書が精算済みの場合" do
          before do
            settlement_ledger = SettlementLedger.completed.first
            allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
            put :settle, id: settlement_ledger.id, settlement_ledger: {
              conpleted: 1,
              settlement_date: Date.today,
              settlement_note: 'test'
            }
          end

          it "申請書の更新がされていないこと" do
            #pending '未実装'
            expect(assigns[:settlement_ledger].completed).to eq(nil)
            expect(assigns[:settlement_ledger].completed).not_to eq(DateTime.now -1)
            expect(assigns[:settlement_ledger].settlement_date).not_to eq(Date.today)
            expect(assigns[:settlement_ledger].settlement_note).not_to eq('test')
          end

          it "ステータスコードが302であること" do
            expect(response.status).to eq(302)
          end
          it "精算申請一覧画面にリダイレクトされること" do
            expect(response).to redirect_to(settlement_ledgers_url)
          end
        end

        context "指定した申請書が削除も精算もされていない場合" do
          context "精算完了のチェックボックスがチェックされている場合" do
            context "精算結果の更新に成功した場合" do
              before do
                settlement_ledger = SettlementLedger.not_completed.not_deleted.first
                allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
                put :settle, id: settlement_ledger.id, settlement_ledger: {
                  completed: 1,
                  settlement_date: Date.today,
                  settlement_note: 'test'
                }
              end

              it "登録処理が行われていること" do
                expect(assigns[:settlement_ledger].settlement_date).to eq(Date.today)
                expect(assigns[:settlement_ledger].settlement_note).to eq('test')
              end

              it "申請書の精算完了日に現在時刻が入っていること" do
                expect(assigns[:settlement_ledger].completed_at).not_to eq(nil)
              end
              it "ステータスコードが302であること" do
                expect(response.status).to eq(302)
              end
              it "精算結果更新のメッセージが設定されていること" do
                expect(flash[:notice]).to eq('精算依頼を更新しました。')
              end
              it "精算申請一覧画面にリダイレクトされること" do
                expect(response).to redirect_to(settlement_ledgers_url)
              end
            end



            context "精算結果の更新に失敗した場合" do
              before do
                settlement_ledger = SettlementLedger.not_completed.not_deleted.first
                allow(settlement_ledger).to receive(:update).and_return(false)
                allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
                put :settle, id: settlement_ledger.id, settlement_ledger: {
                  conpleted: 1,
                  settlement_date: Date.today,
                  settlement_note: 'test'
                }
              end

              it "精算結果の登録画面が表示されること" do
                #pending '未実装'
                expect(response).to render_template(:edit_for_settle)
              end
            end
          end

          context "精算完了のチェックボックスがチェックされていない場合" do
            context "精算結果の登録に成功した場合" do
              before do
                settlement_ledger = SettlementLedger.not_completed.not_deleted.first
                allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
                put :settle, id: settlement_ledger.id, settlement_ledger: {
                  conpleted: 0,
                  settlement_date: Date.today,
                  settlement_note: 'test'
                }
              end

              it "登録処理が行われていること" do
                expect(assigns[:settlement_ledger].settlement_date).to eq(Date.today)
                expect(assigns[:settlement_ledger].settlement_note).to eq('test')
              end

              it "精算書の精算完了日が空のままになっていること" do
                expect(assigns[:settlement_ledger].completed_at).to eq(nil)
              end

              it "精算結果更新のメッセージが設定されていること" do
                expect(flash[:notice]).to eq('精算依頼を更新しました。')
              end
              it "ステータスコードが302であること" do
                expect(response.status).to eq(302)
              end
              it "精算申請一覧画面にリダイレクトされること" do
                expect(response).to redirect_to(settlement_ledgers_url)
              end
            end


            context "精算結果の登録に失敗した場合" do
              before do
                settlement_ledger = SettlementLedger.not_completed.not_deleted.first
                allow(settlement_ledger).to receive(:update).and_return(false)
                allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
                put :settle, id: settlement_ledger.id, settlement_ledger: {
                  conpleted: 0,
                  settlement_date: Date.today,
                  settlement_note: 'test'
                }
              end

              it "精算結果の登録画面が表示されること" do
                #pending '未実装'
                expect(response).to render_template(:edit_for_settle)
              end
            end

          end
        end
      end
      context "存在しない申請書を指定した場合" do
        it "申請書が存在しないエラーが発生すること" do
          expect(lambda{put :settle, id: -1}).to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context "ログインしていない場合" do
      before do
        settle_default
        settle_deleted
        settle_completed

        settlement_ledger = SettlementLedger.not_deleted.not_completed.first
        allow(settlement_ledger).to receive(:settle).and_return(true)
        allow(SettlementLedger).to receive(:find).and_return(settlement_ledger)
        put :settle, id: settlement_ledger.id, settlement_ledger: {
          completed: 1,
          settlement_date: Date.today,
          settlement_note: 'test'
        }
      end

      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end
      it "ログイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end

