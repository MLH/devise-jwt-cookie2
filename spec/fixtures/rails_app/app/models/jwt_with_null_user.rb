# frozen_string_literal: true

class JwtWithNullUser < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :jwt_cookie_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
end
