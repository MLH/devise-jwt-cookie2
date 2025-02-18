# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Devise do
  describe '::jwt::cookie' do
    it 'yields to Devise::JWT::Cookie.config' do
      described_class.jwt_cookie { |jwt_cookie| jwt_cookie.secure = false }

      expect(Devise::JWT::Cookie.config.secure).to be(false)
    end
  end

  it 'adds jwt_cookie_authenticatable module' do
    expect(described_class::ALL).to include(:jwt_cookie_authenticatable)
  end

  it 'associates jwt_cookie_authenticatable module with jwt_cookie strategy' do
    expect(described_class::STRATEGIES[:jwt_cookie_authenticatable]).to eq(:jwt_cookie)
  end
end
