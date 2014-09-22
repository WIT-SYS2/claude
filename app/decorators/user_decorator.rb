class UserDecorator < Draper::Decorator
  delegate_all

  def avatar_url
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=32"
  end
end
