class SettlementLedgersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_settlement_ledger,
    only: [:edit, :update, :destroy, :edit_for_settle, :settle]

  # GET /settlement_ledgers
  # GET /settlement_ledgers.json
  def index
    @settlement_ledgers = SettlementLedger.all
  end

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
    @settlement_ledger.update_attributes!(deleted_at: DateTime.now)
    respond_to do |format|
      format.html { redirect_to settlement_ledgers_url }
      format.json { head :no_content }
    end
  end

  def edit_for_settle
  end

  def settle
    if params[:settlement_ledger][:completed] == "1"
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
      params.require(:settlement_ledger).permit(:content, :note, :price, :application_date, :settlement_date, :settlement_note, :completed_at)
    end
end
