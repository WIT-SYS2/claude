module ControllerMacros
  def login_admin(admin)
    #allow(controller).to receive(:authenticate_user!).and_return(true)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
    #allow(controller).to receive(:current_user).and_return(admin)
  end

  def login_user(user)
   # @request.env["devise.mapping"] = Devise.mapping[:user]
   # user.confirm!
    sign_in user
  end

  def login_treasurer(treasurer)
    @request.env["devise.mapping"] = Devise.mapping[:treasurer]
    sign_in treasurer
  end
end
