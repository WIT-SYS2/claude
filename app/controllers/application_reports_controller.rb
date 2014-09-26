class ApplicationReportsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_application_report, only: [:show, :edit, :update, :destroy, :download]

  def index
    params[:page] ||= 1
    @application_reports = current_user.application_reports
  end

  def new
    @application_report = ApplicationReport.new
    @application_report.application_to = Rails.configuration.application_to
    @application_report.user_name = current_user.name
    @application_report.application_date = Date.today
  end

  def show
  end

  def edit
  end

  def create
    @application_report = ApplicationReport.new(application_report_params)
    @application_report.user_id = current_user.id
    if @application_report.save
      redirect_to application_report_url(@application_report), notice: '届書を登録しました。'
    else
      render action: 'new'
    end
  end

  def update
    if @application_report.update(application_report_params)
      redirect_to application_report_url(@application_report), notice: '届書を更新しました。'
    else
      render action: 'new'
    end
  end

  def destroy
  end

  def download
    pdf_file_path = @application_report.generate_pdf
    send_file(pdf_file_path, filename: ERB::Util.url_encode('届書.pdf'), type: 'application/pdf')
  end

  private

  def set_application_report
    @application_report = ApplicationReport.find(params[:id])
  end

  def application_report_params
    if params[:start_date_time_date].present? && params[:start_date_time_hour].present? && params[:start_date_time_minutes].present?
      params[:application_report][:start_date_time] = "#{params[:start_date_time_date]} #{params[:start_date_time_hour]}:#{params[:start_date_time_minutes]}"
    else
      params[:application_report][:start_date_time] = ''
    end
    if params[:start_date_time_date].present? && params[:end_date_time_hour].present? && params[:end_date_time_minutes].present?
      params[:application_report][:end_date_time] = "#{params[:start_date_time_date]} #{params[:end_date_time_hour]}:#{params[:end_date_time_minutes]}"
    else
      params[:application_report][:end_date_time] = ''
    end
    params.require(:application_report)
      .permit(:application_to, :application_date, :department_name, :user_name,
              :kind, :start_date, :end_date, :term_day, :start_date_time, :end_date_time,
              :term_hour, :term_minutes, :reason, :contact, :tel, :document, :note)
  end
end
