# frozen_string_literal: true

module Devise
  module JWT
    module Cookie
      # Default refresher: re-issues a still-valid JWT once it is past half its lifetime, so a user who
      # keeps making requests never sees the cookie expire. Subclass it to apply your own session
      # rules, such as recovering a session after the JWT has expired or capping its total lifetime.
      #
      # A refresher receives the cookie's token (nil when there is none), the Warden scope and the
      # Rack env, and returns a new token to authenticate the request with, or nil to keep the
      # current one. The middleware writes a returned token to the cookie.
      class Refresher
        def call(token, scope, env)
          return if token.nil?
          return unless renew?(Warden::JWTAuth::TokenDecoder.new.call(token))

          aud = Warden::JWTAuth::EnvHelper.aud_header(env)
          issue(Warden::JWTAuth::UserDecoder.new.call(token, scope, aud), scope, aud)
        rescue ::JWT::DecodeError
          nil
        end

        private

        def renew?(payload)
          issued_at, expires_at = payload.values_at('iat', 'exp')
          return false unless issued_at && expires_at

          Time.now.to_i >= issued_at + ((expires_at - issued_at) / 2)
        end

        # Mirrors devise-jwt's dispatch hook, so revocation strategies such as Allowlist record the token.
        def issue(user, scope, aud)
          token, payload = Warden::JWTAuth::UserEncoder.new.call(user, scope, aud)
          user.on_jwt_dispatch(token, payload) if user.respond_to?(:on_jwt_dispatch)
          token
        end
      end
    end
  end
end
