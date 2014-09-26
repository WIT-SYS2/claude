class ApplicationReportDecorator < Draper::Decorator
  delegate_all

  def kind_collections
    ApplicationReport::KINDS.map{|k, v| ["#{v}. #{ApplicationReport::KIND_NAMES[k]}", v] }
  end

  def kind_name
    ApplicationReport::KIND_NAMES[ApplicationReport::KINDS.key(object.kind)].to_s
  end

  def term_date
    return '' if object.start_date.nil?
    return "#{I18n.l object.start_date} ～ #{I18n.l object.end_date} (#{object.term_day}日間)"
  end

  def term_date_time
    return '' if object.start_date_time.nil?
    return "#{I18n.l object.start_date_time} ～ #{object.end_date_time.strftime('%H時%M分')} (#{object.term_hour}時間 #{object.term_minutes}分)"
  end

  def start_date_time_date
    return nil if object.start_date_time.nil?
    return object.start_date_time.to_date
  end

  def start_date_time_hour
    return nil if object.start_date_time.nil?
    return object.start_date_time.hour
  end

  def start_date_time_minutes
    return nil if object.start_date_time.nil?
    return object.start_date_time.min
  end

  def end_date_time_hour
    return nil if object.end_date_time.nil?
    return object.end_date_time.hour
  end

  def end_date_time_minutes
    return nil if object.end_date_time.nil?
    return object.end_date_time.min
  end

  def status_name
    ApplicationReport::STATUS_NAMES[ApplicationReport::STATUSES.key(object.status)].to_s
  end
end
