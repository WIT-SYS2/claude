module ControllerMacros

  def login_admin(admin)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    #admin = FactoryGirl.create(:admin)
    sign_in admin
  end

  def login_user(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    sign_in user
  end

end
