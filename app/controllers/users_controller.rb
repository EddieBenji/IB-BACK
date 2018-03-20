# Class for adding users:
class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  # GET /test
  def test
    render json: {
      message: 'Estás autenticado'
    }, status: 202
  end

  # POST /auth/login
  def login
    authenticate params[:email], params[:password]
  end

  # POST /auth/register
  def register
    # Need to check that the user name / email is not registered before.
    @user = User.create(user_params)
    if @user.save
      render_success_payload('entity_male_added', :created, @user, 'Usuario')
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password
    )
  end

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
        access_token: command.result,
        message: 'Haz iniciado sesión correctamente.'
      }
    else
      render json: {
        message: 'El correo y/o contraseña no concuerdan.',
        status: 400
      }, status: 400
    end
  end
end
