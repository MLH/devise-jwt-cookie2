# Devise::JWT::Cookie

`devise-jwt-cookie2` is a fork of [devise-jwt-cookie](https://github.com/scarhand/devise-jwt-cookie), a [devise](https://github.com/plataformatec/devise) extension based on [devise-jwt](https://github.com/waiting-for-dev/devise-jwt). It should be used alongside `devise-jwt`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise-jwt-cookie2', '~> 0.7.0'
```

And then execute:

    $ bundle

## Usage

First you need to setup up and configure devise and devise-jwt. This gem hooks into devise-jwt to add an httpOnly cookie with the JWT.

### Model configuration

You have to update the user model to be able to use the cookie method. For example:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_cookie_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: Blacklist
end
```

### Configuration reference

This library can be configured by calling `jwt_cookie` on the devise config object:

```ruby
Devise.setup do |config|
  config.jwt do |jwt|
    # config for devise-jwt goes here
  end
  config.jwt_cookie do |jwt_cookie|
    # ...
    jwt_cookie.secure = false if Rails.env.development?
  end
end
```

#### name ([MDN](https://developer.mozilla.org/en-US/docs/Web/Security/Practical_implementation_guides/Cookies#name))

The name of the cookie. Defaults to `access_token`.

#### secure ([MDN](https://developer.mozilla.org/en-US/docs/Web/Security/Practical_implementation_guides/Cookies#secure))

If a secure cookie should be set, this means the cookie must be sent over a secure connection. Defaults to `true`.

#### httponly ([MDN](https://developer.mozilla.org/en-US/docs/Web/Security/Practical_implementation_guides/Cookies#httponly))

HttpOnly option on the cookie, if set to true JavaScript running in the browser cannot access the cookie. 
Defaults to `true`

#### domain ([MDN](https://developer.mozilla.org/en-US/docs/Web/Security/Practical_implementation_guides/Cookies#domain))

The domain the cookie should be issued to. Will be omitted if not set.

#### same_site ([MDN](https://developer.mozilla.org/en-US/docs/Web/Security/Practical_implementation_guides/Cookies#samesite))

Set's the SameSite attribute on the cookie. Defaults to `none`.

#### refresher

An object that renews the JWT while the cookie strategy authenticates a request. Defaults to `nil`, which never renews a token.

Set it to `Devise::JWT::Cookie::Refresher.new` to re-issue a still-valid token once it is past half its lifetime, so an active user's cookie slides forward instead of expiring:

```ruby
config.jwt_cookie do |jwt_cookie|
  jwt_cookie.refresher = Devise::JWT::Cookie::Refresher.new
end
```

A refresher responds to `call(token, scope, env)`, where `token` is the cookie's JWT (`nil` when the request has none), and returns a new JWT or `nil` to keep the current one. The strategy authenticates the request with the returned token and the middleware writes it to the cookie, unless the request revokes the token. Subclass `Refresher` to supply your own rules, such as recovering a session from a separate refresh credential after the JWT has expired, or capping a session's total lifetime. The private `issue(user, scope, aud)` helper encodes a token and calls the model's `on_jwt_dispatch`, so revocation strategies such as `Allowlist` record it.
