class SettlementLedgersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_settlement_ledger,
    only: [:edit, :update, :destroy, :edit_for_settle, :settle]
  authorize_resource

  # GET /settlement_ledgers
  # GET /settlement_ledgers.json
  def index
    params[:page] ||= 1
    @settlement_ledgers = SettlementLedger.order('ledger_number DESC')
    unless params[:target] == "all"
      @settlement_ledgers = @settlement_ledgers.not_completed.not_deleted
    end
   @content = params[:content]
   @note = params[:note]
   @under_price = params[:under_price]
   @over_price = params[:over_price]
   @demand = params[:demand]
   @application_date = params[:application_date]
   @applicant_user_name = params[:applicant_user_name]

   @settlement_ledgers = @settlement_ledgers.like_content(@content).all if @content.present?
   @settlement_ledgers = @settlement_ledgers.like_note(@note).all if @note.present?
   @settlement_ledgers = @settlement_ledgers.under_price(@under_price).all if @under_price.present?
   @settlement_ledgers = @settlement_ledgers.over_price(@over_price).all if @over_price.present?
   @settlement_ledgers = @settlement_ledgers.like_demand(@demand).all if @demand.present?
   @settlement_ledgers = @settlement_ledgers.like_application_date(@application_date).all if @application_date.present?
   @settlement_ledgers = @settlement_ledgers.like_applicant_user_name(@applicant_user_name).all if @applicant_user_name.present?
   @settlement_ledgers = @settlement_ledgers.page(params[:page])
    respond_to do |format|
      format.html
      format.js if request.xhr?
    end
  end

#  20150611_indexアクションに統合
#  def search
#     params[:page] ||= 1
#     @settlement_ledgers = SettlementLedger.order('ledger_number DESC')
#     unless params[:target] == "all"
#       @settlement_ledgers = @settlement_ledgers.not_completed.not_deleted
#     end
#     #respond_to do |format|
#       #format.html
#       #format.js if request.xhr?
#     #end
#     content = params[:content]
#     @settlement_ledgers = @settlement_ledgers.like_content(content).all if content.present?
#     @settlement_ledgers = @settlement_ledgers.page(params[:page])
#     render :index
#  end


  # GET /settlement_ledgers/new
  def new
    @settlement_ledger = SettlementLedger.new
  end

  # GET /settlement_ledgers/1/edit
  def edit
  end

  # POST /settlement_ledgers
  # POST /settlement_ledgers.json
  def create
    @settlement_ledger = SettlementLedger.new(settlement_ledger_params)
    @settlement_ledger.applicant_user_id = current_user.id
    @settlement_ledger.applicant_user_name = current_user.name

    respond_to do |format|
      if @settlement_ledger.save
        format.html { redirect_to settlement_ledgers_url, notice: '精算依頼を登録しました。' }
        format.json { render action: 'index', status: :created, location: @settlement_ledger }
      else
        format.html { render action: 'new' }
        format.json { render json: @settlement_ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settlement_ledgers/1
  # PATCH/PUT /settlement_ledgers/1.json
  def update
    respond_to do |format|
      if @settlement_ledger.update(settlement_ledger_params)
        format.html { redirect_to settlement_ledgers_url, notice: '精算依頼を更新しました。' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @settlement_ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settlement_ledgers/1
  # DELETE /settlement_ledgers/1.json
  def destroy
    #if @settlement_ledger.deleted_at or @settlement_ledger.completed_at
    #  redirect_to settlement_ledgers_url
    #  return
    #end

    @settlement_ledger.update_attributes!(deleted_at: DateTime.now)
    respond_to do |format|
      format.html { redirect_to settlement_ledgers_url }
      format.json { head :no_content }
    end
  end

  def download
    pkg = Axlsx::Package.new
    pkg.workbook do |wb|
      wb.add_worksheet(name: '精算書一覧') do |ws|
        ws.add_row SettlementLedger::EXCEL_HEADER
        SettlementLedger.all.each do |sl|
          ws.add_row sl.to_xlsx_value
        end
      end
    end
    send_data(pkg.to_stream.read,
              filename: '精算書一覧.xlsx',
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  end

  def edit_for_settle
    #redirect_to settlement_ledgers_url if @settlement_ledger.completed_at
  end

  def settle
    #削除済みのものを登録しようとしたら一覧ページにリダイレクト
    #if @settlement_ledger.deleted?# or @settlement_ledger.completed?
    #  redirect_to settlement_ledgers_url
    #  return
    #end
    if params[:settlement_ledger].delete(:completed) == "1"
      params[:settlement_ledger][:completed_at] = DateTime.now
    else
      params[:settlement_ledger][:completed_at] = nil
    end
    respond_to do |format|
      if @settlement_ledger.update(settlement_ledger_params)
        format.html { redirect_to settlement_ledgers_url, notice: '精算依頼を更新しました。' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @settlement_ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_settlement_ledger
      @settlement_ledger = SettlementLedger.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def settlement_ledger_params
      params.require(:settlement_ledger).permit(:content, :note, :price,:demand, :application_date, :settlement_date, :settlement_note, :completed_at)
    end
end
