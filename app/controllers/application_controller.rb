class ApplicationController < ActionController::API

  def render_success_payload(msg_key, status, entity, string_entity)
    render json: SuccessPayload.new(msg_key, status, entity, string_entity),
           status: status
  end

  def render_error_payload(msg_key, status: :bad_request)
    render json: ErrorPayload.new(msg_key, status), status: status
  end
end
