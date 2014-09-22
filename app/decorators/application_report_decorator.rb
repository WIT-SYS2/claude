class ApplicationReportDecorator < Draper::Decorator
  delegate_all

  def kind_collections
    ApplicationReport::KINDS.map{|k, v| ["#{v}. #{ApplicationReport::KIND_NAMES[k]}", v] }
  end

  def kind_name
    ApplicationReport::KIND_NAMES[ApplicationReport::KINDS.key(object.kind)].to_s
  end

  def term
    return "YYYY年MM月DD日～YYYY年MM月DD日"
  end

  def status_name
    ApplicationReport::STATUS_NAMES[ApplicationReport::STATUSES.key(object.status)].to_s
  end
end
