# Devise::JWT::Cookie

`devise-jwt-cookie2` is a fork of [devise-jwt-cookie](https://github.com/scarhand/devise-jwt-cookie), a [devise](https://github.com/plataformatec/devise) extension based on [devise-jwt](https://github.com/waiting-for-dev/devise-jwt). It should be used alongside `devise-jwt`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise-jwt-cookie2', '~> 0.6.0'
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
