class AllCasaAdminsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_all_casa_admin!
  before_action :set_custom_error_heading, only: [:update_password]
  after_action :reset_custom_error_heading, only: [:update_password]

  def new
    @all_casa_admin = AllCasaAdmin.new
  end

  def edit
    @user = current_all_casa_admin
  end

  def create
    service = ::CreateAllCasaAdminService.new(params, current_user)
    @all_casa_admin = service.build
    begin
      service.create!
      redirect_to authenticated_all_casa_admin_root_path,
        notice: "New All CASA admin created successfully"
    rescue ActiveRecord::RecordInvalid
      render :new
    end
  end

  def update
    @user = current_all_casa_admin

    if @user.update(all_casa_admin_params)
      flash[:success] = "Profile was successfully updated."
      redirect_to edit_all_casa_admins_path
    else
      render :edit
    end
  end

  def update_password
    @user = current_all_casa_admin

    if @user.update(password_params)
      bypass_sign_in(@user)

      UserMailer.password_changed_reminder(@user).deliver
      flash[:success] = "Password was successfully updated."

      redirect_to edit_all_casa_admins_path
    else
      render "edit"
    end
  end

  private

  def all_casa_admin_params
    params.require(:all_casa_admin).permit(:email)
  end

  def password_params
    params.require(:all_casa_admin).permit(:password, :password_confirmation)
  end

  def set_custom_error_heading
    @custom_error_header = "password change"
  end

  def reset_custom_error_heading
    @custom_error_header = nil
  end
end
