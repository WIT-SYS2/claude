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
    @settlement_ledgers = @settlement_ledgers.page(params[:page])
    respond_to do |format|
      format.html
      format.js if request.xhr?
    end
  end

  # GET /settlement_ledgers/new
  def new
    @settlement_ledger = SettlementLedger.new
  end

  # GET /settlement_ledgers/1/edit
  def edit
    respond_to do |format|
      if  @settlement_ledger.nil?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は編集できません。'}
      elsif @settlement_ledger.deleted?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に削除されています。'}
      elsif @settlement_ledger.completed?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に精算が完了されています。'}
      else
        format.html
      end
    end
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
      
      if  @settlement_ledger.nil?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は編集できません。'}
      elsif @settlement_ledger.deleted?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に削除されています。'}
      elsif @settlement_ledger.completed?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に精算が完了されています。'}
      elsif @settlement_ledger.update(settlement_ledger_params)
        format.html{ redirect_to settlement_ledgers_url, notice: '精算依頼を更新しました。'}
      end

    end
  end

  # DELETE /settlement_ledgers/1
  # DELETE /settlement_ledgers/1.json
  def destroy
    respond_to do |format|
      if  @settlement_ledger.nil?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は編集できません。'}
      elsif @settlement_ledger.deleted?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に削除されています。' }
      elsif @settlement_ledger.completed?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に精算が完了されています。'}
      else
        @settlement_ledger.update_attributes!(deleted_at: DateTime.now)
        format.html{ redirect_to settlement_ledgers_url }
      end
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
    respond_to do |format|
      if  @settlement_ledger.nil?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は精算できません。'}
      elsif @settlement_ledger.deleted?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に削除されています。'}
      elsif @settlement_ledger.completed?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に精算が完了されています。'}
      else
        format.html
      end
    end
  end

  def settle
    respond_to do |format|

      if params[:settlement_ledger].delete(:completed) == "1"
        params[:settlement_ledger][:completed_at] = DateTime.now
      else
        params[:settlement_ledger][:completed_at] = nil
      end

      if  @settlement_ledger.nil?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は精算できません。'}
      elsif @settlement_ledger.deleted?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に削除されています。'}
      elsif @settlement_ledger.completed?
        format.html{ redirect_to settlement_ledgers_url, notice: '選択された申請は既に精算が完了されています。'}
      elsif @settlement_ledger.update(settlement_ledger_params)
        format.html { redirect_to settlement_ledgers_url, notice: '精算依頼を更新しました。' }
      else
        format.html { render action: 'edit_for_settle' }
      end
    end

  end

  def search
    params[:page] ||= 1
    @settlement_ledgers = SettlementLedger.order('ledger_number DESC')
    unless params[:target] == "all"
      @settlement_ledgers = @settlement_ledgers.not_deleted.not_completed
    end
    content = params[:content]
    @settlement_ledgers = @settlement_ledgers.like_content(content).all if content.present?
    @settlement_ledgers = @settlement_ledgers.page(params[:page])
    render :index
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_settlement_ledger
      @settlement_ledger = SettlementLedger.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def settlement_ledger_params
      params.require(:settlement_ledger).permit(:content, :note, :price, :request, :application_date, :settlement_date, :settlement_note, :completed_at)


    end
end
