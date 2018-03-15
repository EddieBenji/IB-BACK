# Main controller.
class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  include ExceptionHandler

  def render_success_payload(msg_key, status, entity, string_entity)
    render json: SuccessPayload.new(msg_key, status, entity, string_entity),
           status: status
  end

  def render_error_payload(msg_key, status: :bad_request)
    render json: ErrorPayload.new(msg_key, status), status: status
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
