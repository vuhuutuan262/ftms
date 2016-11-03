class PasswordsController < Devise::PasswordsController
  def create
    self.resource =
      resource_class.send_reset_password_instructions resource_params
    yield resource if block_given?
    if successfully_sent?(resource)
      redirect_to root_url
    else
      flash[:notice] = "Email Not available"
      redirect_to root_url
    end
  end
end
