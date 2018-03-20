# module for the exceptions
module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class DecodeError < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :four_ninety_eight
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::ExpiredSignature, with: :four_ninety_eight
    rescue_from ExceptionHandler::DecodeError, with: :four_zero_one

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { message: e.message }, status: :unprocessable_entity
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    render json: { message: e.message }, status: 403
  end

  # JSON response with message; Status code 401 - Unauthorized
  def four_ninety_eight(_e)
    render json: {
      message: 'El token ha expirado. Por favor, inicie sesión de nuevo.'
    }, status: :unauthorized
  end

  # JSON response with message; Status code 401 - Unauthorized
  def four_zero_one(e)
    render json: { message: 'Invalid token: ' + e.message }, status: 422
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    render json: { message: e.message }, status: 403
  end
end
