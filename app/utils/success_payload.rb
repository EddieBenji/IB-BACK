# msg_key is the key that you put in the es.yml file.
# status is the code status you want to send to the front.
# entity is the object you want to send to the front.
# string_entity is the string to append to the message found in the es.yml file.
class SuccessPayload
  attr_reader :msg_key, :status, :entity, :string_entity

  def initialize(msg_key, status, entity, string_entity)
    @msg_key = msg_key
    @status = status
    @entity = entity
    @string_entity = string_entity
  end

  def translated_payload
    I18n.translate("success_messages.#{msg_key}", entity: string_entity)
  end

  def as_json(*)
    {
      status: Rack::Utils.status_code(status),
      message: translated_payload,
      entity: entity
    }
  end
end
