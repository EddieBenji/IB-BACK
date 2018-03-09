class ErrorPayload
  attr_reader :identifier, :status

  def initialize(identifier, status)
    @identifier = identifier
    @status = status
  end

  def translated_payload
    I18n.translate("custom_errors.#{identifier}")
  end

  def as_json(*)
    {
      status: Rack::Utils.status_code(status),
      statusText: translated_payload,
      message: translated_payload
    }
  end

end