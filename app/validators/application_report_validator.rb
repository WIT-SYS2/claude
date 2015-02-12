class ApplicationReportValidator < ActiveModel::Validator
  def validate(record)
    if record.start_date.present? && record.end_date.present? && record.term_day.present?
      if record.start_date > record.end_date
        record.errors[:term] << '申請期間を正しく指定してください。'
      end
    elsif record.start_date.nil? && record.end_date.nil? && record.term_day.nil?
    else
      record.errors[:term] << '申請期間を正しく指定してください。'
    end

    if record.start_date_time.present? && record.end_date_time.present? && record.term_hour.present? && record.term_minutes.present?
      if record.start_date_time >= record.end_date_time
        record.errors[:term] << '申請期間を正しく指定してください。'
      end
    elsif record.start_date_time.nil? && record.end_date_time.nil? && record.term_hour.nil? && record.term_minutes.nil?
    else
      record.errors[:term] << '申請期間を正しく指定してください。'
    end
  end
end
