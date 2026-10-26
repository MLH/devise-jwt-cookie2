# frozen_string_literal: true

require 'warden'

module Devise
  module JWT
    module Cookie
      # Warden strategy to authenticate an user through a JWT token in
      # an http-only cookie
      class Strategy < Warden::Strategies::Base
        def valid?
          !token.nil? || !refresher.nil?
        end

        def store?
          false
        end

        def authenticate!
          refresh
          # Without a token there is nothing to reject, so other strategies still get a turn.
          return if token.nil?

          aud = Warden::JWTAuth::EnvHelper.aud_header(env)
          user = Warden::JWTAuth::UserDecoder.new.call(token, scope, aud)
          success!(user)
        rescue ::JWT::DecodeError => e
          fail!(e.message)
        end

        private

        def token
          @token ||= CookieHelper.new.read_from(cookies)
        end

        def refresher
          Cookie.config.refresher
        end

        # Warden re-runs a strategy that did not succeed or fail, so only ask the refresher once.
        def refresh
          return if @refreshed

          @refreshed = true
          refreshed_token = refresher&.call(token, scope, env)
          env[Middleware::REFRESHED_TOKEN_KEY] = @token = refreshed_token if refreshed_token
        end
      end
    end
  end
end

Warden::Strategies.add(:jwt_cookie, Devise::JWT::Cookie::Strategy)
