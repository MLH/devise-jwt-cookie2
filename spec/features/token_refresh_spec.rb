# frozen_string_literal: true

require 'rails_helper'

describe 'Token refresh', type: :request do
  include ActiveSupport::Testing::TimeHelpers
  include_context 'feature'
  include_context 'fixtures'

  let(:user) { jwt_with_allowlist_user }
  let(:user_params) { { jwt_with_allowlist_user: { email: user.email, password: user.password } } }
  let(:auth_action) { '/jwt_with_allowlist_user_auth_action' }
  let(:refresher) { nil }

  around do |example|
    Devise::JWT::Cookie.config.refresher = refresher
    example.run
  ensure
    Devise::JWT::Cookie.config.refresher = nil
  end

  context 'without a refresher' do
    it 'keeps the token past half its lifetime' do
      auth = sign_in(jwt_with_allowlist_user_session_path, user_params)

      travel(31.minutes) { get_with_auth(auth_action, auth) }

      expect(response.status).to eq(200)
      expect(response.cookies[cookie_name]).to be_nil
    end
  end

  context 'with the default refresher' do
    let(:refresher) { Devise::JWT::Cookie::Refresher.new }

    it 'keeps a token younger than half its lifetime' do
      auth = sign_in(jwt_with_allowlist_user_session_path, user_params)

      travel(29.minutes) { get_with_auth(auth_action, auth) }

      expect(response.status).to eq(200)
      expect(response.cookies[cookie_name]).to be_nil
    end

    it 'replaces a token past half its lifetime with an allowlisted one' do
      auth = sign_in(jwt_with_allowlist_user_session_path, user_params)

      travel(31.minutes) { get_with_auth(auth_action, auth) }
      refreshed = response.cookies[cookie_name]

      expect(response.status).to eq(200)
      expect(refreshed).to be_present
      expect(refreshed).not_to eq(auth)
      travel(80.minutes) { get_with_auth(auth_action, refreshed) }
      expect(response.status).to eq(200)
    end

    it 'does not renew a revoked token' do
      auth = sign_in(jwt_with_allowlist_user_session_path, user_params)
      sign_out(destroy_jwt_with_allowlist_user_session_path, auth)

      travel(31.minutes) { get_with_auth(auth_action, auth) }

      expect(response.status).to eq(401)
      expect(response.cookies[cookie_name]).to be_nil
    end
  end

  context 'with a refresher that recovers a session without a token' do
    let(:refresher) do
      recovered_user = user
      Class.new(Devise::JWT::Cookie::Refresher) do
        define_method(:call) do |token, scope, env|
          token ? super(token, scope, env) : issue(recovered_user, scope, nil)
        end
      end.new
    end

    it 'authenticates the request and writes the recovered token' do
      get(auth_action, headers: { 'Accept' => 'application/json' })

      expect(response.status).to eq(200)
      expect(response.cookies[cookie_name]).to be_present
    end
  end
end
