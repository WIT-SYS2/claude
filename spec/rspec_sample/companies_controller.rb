# coding: utf-8

class Admin::CompaniesController < Admin::BaseController
  authorize_resource
  before_filter :verify_onetime_token, only: [:create, :update]
  before_filter :set_onetime_token, only: [:new, :edit, :create, :update]

  def index
    params[:page] ||= 1
    @companies = Company.scoped
    @total_count = @companies.count
    @companies = @companies.page(params[:page]).per(Rails.configuration.paginate_count)
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    session[:company_params] = {}
    session[:company_step] = nil
    @company = Company.new
  end

  def edit
    session[:company_params] = { }
    session[:company_step] = nil
    @company = Company.find(params[:id])
  end

  def create
    @transfer_regulation = params[:company].delete(:transfer_regulation) unless params[:previous_button]
    session[:company_params].deep_merge!(params[:company]) if params[:company]
    @company = Company.new(session[:company_params])
    @company.current_step = session[:company_step]
    if @company.valid?
      if params[:previous_button]
        @company.previous_step
      elsif @company.last_step?
        @company.transfer_regulation = nil if @transfer_regulation.present?
        @company.transfer_regulation = File.open(@transfer_regulation) if @transfer_regulation.present?
        @company.save
      else
        if @transfer_regulation
          t = DateTime.now
          rnd = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)[0..8]
          tmp_dir = File.join(Dir.tmpdir, 'adh', 'tmp_transfer_regulation', t.year.to_s, t.month.to_s, t.day.to_s, rnd)
          FileUtils.mkdir_p(File.join(tmp_dir, 'transfer_regulation'))
          @transfer_regulation_tmp = File.join(tmp_dir, 'transfer_regulation', @transfer_regulation.original_filename)
          File.open(@transfer_regulation_tmp, 'wb') { |f| f.write(@transfer_regulation.read) }
        end
        @company.next_step
        @company.transfer_regulation_file_name = @transfer_regulation.original_filename if @transfer_regulation
      end
      session[:company_step] = @company.current_step
    end

    if @company.new_record?
      flash.now[:alert] = @company.errors.full_messages unless @company.errors.blank?
      render 'new'
    else
      session[:company_step] = session[:company_params] = nil
      Log.info(@current_system_user, "A08B02", "法人作成", "「#{@company.name}(#{@company.code})」を作成しました", params[:controller], params[:action])
      redirect_to admin_company_path(@company), notice: I18n.t('adh.companies.create_success')
    end
  end

  def update
    @transfer_regulation = params[:company].delete(:transfer_regulation) unless params[:previous_button]
    @transfer_regulation_delete = params[:transfer_regulation_delete]
    session[:company_params].deep_merge!(params[:company]) if params[:company]
    @company = Company.find(params[:id])
    @company.attributes = session[:company_params]
    @company.current_step = session[:company_step]
    if @company.valid?
      if params[:previous_button]
        @company.previous_step
      elsif @company.last_step?
        @company.transfer_regulation = nil if @transfer_regulation_delete
        @company.transfer_regulation = File.open(@transfer_regulation) if @transfer_regulation.present?
        @company.save
        session[:company_step] = session[:company_params] = nil
        Log.info(@current_system_user, "A08B02", "法人更新", "「#{@company.name}(#{@company.code})」を更新しました", params[:controller], params[:action])
        redirect_to admin_company_path(@company), notice: I18n.t('adh.companies.update_success')
        return
      else
        if @transfer_regulation
          t = DateTime.now
          rnd = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)[0..8]
          tmp_dir = File.join(Dir.tmpdir, 'adh', 'tmp_transfer_regulation', t.year.to_s, t.month.to_s, t.day.to_s, rnd)
          FileUtils.mkdir_p(File.join(tmp_dir, 'transfer_regulation'))
          @transfer_regulation_tmp = File.join(tmp_dir, 'transfer_regulation', @transfer_regulation.original_filename)
          File.open(@transfer_regulation_tmp, 'wb') { |f| f.write(@transfer_regulation.read) }
        end
        @company.next_step
        @company.transfer_regulation_file_name = @transfer_regulation.original_filename if @transfer_regulation
      end
      session[:company_step] = @company.current_step
    end
  
    flash.now[:alert] = @company.errors.full_messages unless @company.errors.blank?
    render 'edit'
  end

  def destroy
    @company = Company.find(params[:id])
    deletable, msg = @company.deletable?
    unless deletable
      redirect_to admin_companies_path, alert: msg
      return
    end

    if @company.update_attributes(deleted_at: DateTime.now)
      flash[:notice] = I18n.t('adh.companies.destroy_success')
      Log.info(@current_system_user, "A08B02", "法人削除", "「#{@company.name}(#{@company.code})」を削除しました", params[:controller], params[:action])
    else
      flash[:alert] = I18n.t('adh.companies.destroy_fail')
    end

    redirect_to admin_companies_path
  end

  def download
    send_file(params[:path].to_s, disposition: 'inline')
  end
end
