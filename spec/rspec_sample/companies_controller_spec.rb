# coding: utf-8

require 'spec_helper'

describe Admin::CompaniesController do
  fixtures(:companies, :roles, :system_users, :system_user_roles)

  setup :activate_authlogic

  describe "GET 'index'" do
    context "ログインしている場合" do
      before do
        login_by(:system_users, :admin)
        get :index
      end

      it { response.should be_success }
      it { response.should render_template('index') }

      it "法人の一覧が返されること" do
        assigns[:companies].should_not be_blank
        assigns[:companies].each do |company|
          company.should be_an_instance_of(Company)
        end
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get :index
        response.should redirect_to(admin_login_path)
      end
    end
  end

  describe "GET 'show'" do
    context "ログインしており" do
      before do
        login_by(:system_users, :admin)
      end

      context "存在する法人を指定した場合" do
        before do
          @expected_company = companies(:company1)
          get :show, :id => @expected_company.id
        end

        it { response.should render_template('show') }
        it { assigns[:company].id.should == @expected_company.id }
      end

      context "存在しない法人を指定した場合" do
        it "データが存在しないエラー画面が表示されること" do
          get :show, :id => -1
          response.should render_template('shared/error_record_not_found')
        end
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get :show, id: 1
        response.should redirect_to(admin_login_path)
      end
    end
  end

  describe "GET 'new'" do
    context "ログインしている場合" do
      before do
        login_by(:system_users, :admin)
        get :new
      end

      it { response.should render_template('new') }
      it { assigns[:company].should be_an_instance_of(Company) }
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get :new
        response.should redirect_to(admin_login_path)
      end
    end
  end

  describe "GET 'edit'" do
    context "ログインしており" do
      before do
        login_by(:system_users, :admin)
      end

      context "有効な法人が指定された場合" do
        before do
          @expected_company = companies(:company1)
          get :edit, :id => @expected_company.id
        end

        it { response.should render_template('edit') }
        it { assigns[:company].id.should == @expected_company.id }
      end

      context "存在しない法人を指定した場合" do
        it "データが存在しないエラー画面が表示されること" do
          get :edit, :id => -1
          response.should render_template('shared/error_record_not_found')
        end
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get :edit, id: 1
        response.should redirect_to(admin_login_path)
      end
    end
  end

  describe "POST 'create'" do
    context "ログインしており" do
      before do
        pending ''
        login_by(:system_users, :admin)
      end

      context "法人の登録に成功した場合" do
        it "法人の登録処理が呼び出されること" do
          params = { "code" => "9999", "name" => "テスト法人" }
          sus = SystemUserSession.find
          @company = mock_model(Company)
          @company.should_receive(:modify_user=).with(sus.system_user)
          @company.should_receive(:save).and_return(true)
          Company.should_receive(:new).with(params).and_return(@company)
          Log.stub(:info)
          post :create, company: { code: "9999", name: "テスト法人" }
        end

        it "情報ログが登録されること" do
          sus = SystemUserSession.find
          @company = mock_model(Company)
          @company.stub(:modify_user=)
          @company.stub(:save).and_return(true)
          Company.stub(:new).and_return(@company)
          Log.should_receive(:info).with(sus.system_user, "A08B02", "法人作成", "「テスト法人(9999)」を作成しました", "companies", "create")
          post :create, company: { code: "9999", name: "テスト法人" }
        end

        it "一覧ページにリダイレクトされること" do
          @company = mock_model(Company)
          @company.stub(:modify_user=)
          @company.stub(:save).and_return(true)
          Company.stub(:new).and_return(@company)
          Log.stub(:info)
          post :create, company: { code: "9999", name: "テスト法人" }
          response.should redirect_to(company_url(@company))
        end
      end

      context "法人の登録に失敗した場合" do
        it "新規作成画面が表示されること" do
          @company = mock_model(Company)
          @company.stub(:modify_user=)
          @company.stub(:save).and_return(false)
          Company.stub(:new).and_return(@company)
          Log.should_not_receive(:info)
          post :create, company: { code: "9999", name: "テスト法人" }
          response.should render_template("new")
        end
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        post :create
        response.should redirect_to(admin_login_path)
      end
    end
  end

  describe "PUT 'update'" do
    context "ログインしており" do
      before do
        pending ''
        login_by(:system_users, :admin)
      end

      context "存在しない法人を指定した場合" do
        it "RecordNotFoundエラーが発生すること" do
          expect { put :update, :id => -1 }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "法人の更新に成功した場合" do
        it "法人の更新処理が呼び出されること" do
          params = { "id" => "1", "company" => { "name" => "テスト法人" } }
          sus = SystemUserSession.find
          @company = mock_model(Company)
          @company.stub(:departments).and_return([])
          @company.should_receive(:modify_user=).with(sus.system_user)
          @company.should_receive(:update_attributes).and_return(true)
          Company.should_receive(:find).with("1").and_return(@company)
          Log.stub(:info)
          put :update, params
        end

        it "情報ログが登録されること" do
          sus = SystemUserSession.find
          @company = mock_model(Company)
          @company.stub(:departments).and_return([])
          @company.stub(:modify_user=)
          @company.stub(:update_attributes).and_return(true)
          @company.stub(:name).and_return("テスト法人")
          @company.stub(:code).and_return("9999")
          Company.stub(:find).and_return(@company)
          Log.should_receive(:info).with(sus.system_user, "A08B02", "法人更新", "「#{@company.name}(#{@company.code})」を更新しました", "companies", "update")
          put :update, id: 1, company: { code: "9999", name: "テスト法人" }
        end

        it "一覧ページにリダイレクトされること" do
          @company = mock_model(Company)
          @company.stub(:departments).and_return([])
          @company.stub(:modify_user=)
          @company.stub(:update_attributes).and_return(true)
          Company.stub(:find).and_return(@company)
          Log.stub(:info)
          put :update, id: 1, company: { code: "9999", name: "テスト法人" }
          response.should redirect_to(company_url(@company))
        end
      end

      context "法人の更新に失敗した場合" do
        it "編集画面が表示されること" do
          @company = mock_model(Company)
          @company.stub(:departments).and_return([])
          @company.stub(:modify_user=)
          @company.stub(:update_attributes).and_return(false)
          Company.stub(:find).and_return(@company)
          put :update, id: 1, company: { code: "9999", name: "テスト法人" }
          response.should render_template("edit")
        end
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        put :update, id: 1
        response.should redirect_to(admin_login_path)
      end
    end
  end
end

describe Admin::CompaniesController, "DELETE 'destroy'" do
  fixtures(:companies, :roles, :system_user_roles, :system_users)

  setup :activate_authlogic

  context "存在しない法人を指定した場合" do
    before do
      login_by(:system_users, :admin)
    end

    it "データが存在しないエラー画面が表示されること" do
      delete :destroy, :id => -1
      response.should render_template('shared/error_record_not_found')
    end
  end

  context "削除不可の場合" do
    before do
      pending ''
      Department.update_all(deleted_at: DateTime.now)
      login_by(:system_users, :admin)
    end

    it "削除に失敗すること" do
      @error_messages = ["msg1", "msg2"]
      company = mock_model(Company)
      company.should_receive(:deletable?).and_return([false, @error_messages])
      Company.should_receive(:find).with("1").and_return(company)
      delete :destroy, id: 1
      flash[:alert].should == @error_messages
    end
  end

  context "法人の削除に成功した場合" do
    before do
      pending ''
      login_by(:system_users, :admin)
    end

    it "法人の削除処理が呼び出されること" do
      t = DateTime.now
      DateTime.stub(:now).and_return(t)
      params = { "id" => "1" }
      sus = SystemUserSession.find
      @company = mock_model(Company)
      @company.should_receive(:deletable?).and_return(true)
      @company.should_receive(:update_attributes).with(deleted_at: t, delete_user: sus.system_user).and_return(true)
      Company.should_receive(:find).with("1").and_return(@company)
      Log.stub(:info)
      delete :destroy, params
    end

    it "情報ログが登録されること" do
      sus = SystemUserSession.find
      @company = mock_model(Company)
      @company.stub(:name).and_return("テスト法人")
      @company.stub(:code).and_return("0001")
      @company.stub(:update_attributes).and_return(true)
      @company.stub(:deletable?).and_return(true)
      Company.stub(:find).and_return(@company)
      Log.should_receive(:info).with(sus.system_user, "A08B02", "法人削除", "「#{@company.name}(#{@company.code})」を削除しました", "admin/companies", "destroy")
      delete :destroy, id: 1
      flash[:notice].should == "法人を削除しました"
    end

    it "一覧ページにリダイレクトされること" do
      @company = mock_model(Company)
      @company.stub(:deletable?).and_return(true)
      @company.stub(:update_attributes).and_return(true)
      Company.stub(:find).and_return(@company)
      Log.stub(:info)
      delete :destroy, id: 1
      response.should redirect_to(admin_companies_url)
    end
  end

  context "法人の削除に失敗した場合" do
    before do
      login_by(:system_users, :admin)
    end

    it "エラーメッセージが設定されること" do
      @company = mock_model(Company)
      @company.stub(:deletable?).and_return(true)
      @company.stub(:update_attributes).and_return(false)
      Company.stub(:find).and_return(@company)
      delete :destroy, id: 1
      flash[:alert].should == "法人を削除できませんでした"
    end
  end

  context "ログインしていない場合" do
    it "ログインページにリダイレクトされること" do
      delete :destroy, id: 1
      response.should redirect_to(admin_login_path)
    end
  end
end
