class ApplicationReportsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_application_report, only: [:edit, :update, :destroy, :download]

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

  def edit
  end

  def create
    @application_report = ApplicationReport.new(application_report_params)
    @application_report.user_id = current_user.id
    if @application_report.save
      redirect_to application_reports_url, notce: '届書を登録しました。'
    else
      render action: 'new'
    end
  end

  def update
  end

  def destroy
  end

  def download
  end

  private

  def set_appliation_report
    @application_report = ApplicationReport.find(params[:id])
  end

  def application_report_params
    params.require(:application_report)
      .permit(:application_to, :application_date, :department_name, :user_name,
              :kind, :start_date, :end_date, :term_day, :start_date_time, :end_date_time,
              :term_hour, :term_minutes, :reason, :contact, :tel, :document, :note)
  end
end
