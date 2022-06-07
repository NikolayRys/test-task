TokenError = Class.new(StandardError)

class TokenService
  def self.encode(payload)
    JWT.encode(payload, secret_key)
  end

  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, secret_key, true)[0])
  rescue JWT::DecodeError
    raise TokenError, 'Invalid token'
  end

  private

  def self.secret_key
    Rails.application.secrets.secret_key_base
  end
end
