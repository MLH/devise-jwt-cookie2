# frozen_string_literal: true

require 'spec_helper'
require 'devise/jwt/cookie/cookie_helper'
require 'warden/jwt_auth/token_decoder'

RSpec.describe Devise::JWT::Cookie::CookieHelper do
  let(:token) { 'test_token' }
  let(:decoded_token) { { 'exp' => (Time.now + 3600).to_i } }
  let(:cookies) { {} }
  let(:helper) { described_class.new }

  before do
    allow(Warden::JWTAuth::TokenDecoder).to receive(:new).and_return(instance_double(Warden::JWTAuth::TokenDecoder,
                                                                                     call: decoded_token))
  end

  describe '#build' do
    context 'when token is nil' do
      it 'removes the cookie' do
        expect(helper.build(nil)).to eq(['access_token', {
          value: nil,
          path: '/',
          httponly: true,
          secure: Devise::JWT::Cookie.config.secure,
          same_site: :none,
          max_age: '0',
          expires: Time.at(0)
        }])
      end
    end

    context 'when token is present' do
      it 'creates the cookie' do
        expect(helper.build(token)).to eq(['access_token', {
          value: token,
          path: '/',
          httponly: true,
          secure: Devise::JWT::Cookie.config.secure,
          same_site: :none,
          expires: Time.at(decoded_token['exp'])
        }])
      end
    end
  end

  describe '#read_from' do
    it 'reads the cookie from cookies' do
      cookies['access_token'] = token
      expect(helper.read_from(cookies)).to eq(token)
    end
  end
end
