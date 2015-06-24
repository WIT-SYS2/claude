# helper methods for creating login session
#
# params:
#  - mode :system_users or :provider_users or :employees
#  - user_symbol fixture identifier
#  - provider_user_type 'house_head' or 'house_branch' or 'moving' (default 'house_head')
def login_by(mode, user_symbol, provider_user_type = 'house_head')
  token = Authlogic::Random.friendly_token
  case mode
  when :system_users
    SystemUserSession.create(system_users(user_symbol))
    SystemUserLogin.create!(system_user_id: system_users(user_symbol).id, 
                            logined_at: Time.now, 
                            login_ip_address: "127.0.0.1",
                            token: token)
  when :provider_users
    provider_user = provider_users(user_symbol)
    ProviderUserSession.create(provider_user)
    ProviderUserLogin.create!(provider_user_id: provider_user.id, 
                          logined_at: Time.now, 
                          login_ip_address: "127.0.0.1",
                          token: token)
    session[:provider_user_type] = provider_user_type
  when :employees
    EmployeeSession.create(employees(user_symbol))
    EmployeeLogin.create!(employee_id: employees(user_symbol).id, 
                          logined_at: Time.now, 
                          login_ip_address: "127.0.0.1",
                          token: token)
  else
    raise ArgumentError, "Unknown login session mode #{mode}"
  end
  session[:login_token] = token
end
