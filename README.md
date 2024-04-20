# ActiveAuthentication

A pure Rails authentication solution.

## Main features

* Pure Rails implementation, uses [has_secure_password](https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password), [generates_token_for](https://api.rubyonrails.org/classes/ActiveRecord/TokenFor/ClassMethods.html#method-i-generates_token_for), [find_by_token_for](https://api.rubyonrails.org/classes/ActiveRecord/TokenFor/ClassMethods.html#method-i-find_by_token_for) and [authenticate_by](https://api.rubyonrails.org/classes/ActiveRecord/SecurePassword/ClassMethods.html#method-i-authenticate_by).
* ActiveAuthentication authenticates users and only users. If you need to authenticate other models you should be asking yourself if you shouldn't handle authorization differently.
* Turn on/off the features you need by using concerns.

### Concerns

* Authenticatable: provides the standard email/password authentication. It's the only concern that can't be turned off.
* Confirmable: allows users to confirm their email addresses.
* Lockable: locks users after a number of failed sign in attempts.
* Omniauthable: allows users to sign up and sign in using a third party service through Omniauth. Turned off by default.
* Recoverable: allows users to reset their password.
* Registerable: allows users to sign up and edit their profile.
* Timeoutable: expires sessions after a period of inactivity. Turned off by default.
* Trackable: tracks users sign in count, timestamps and ip addresses.

Planned concerns:

* MagicLinkable: to allow users to sign in with a magic link.
* Invitable: to allow users to invite other users.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "active_authentication"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install active_authentication
```

## Usage

After installing the gem, you need to generate the `User` model. To generate it, run:

```bash
$ rails generate active_authentication:install
```

This command will generate the `User` model, add the `active_authentication` route, and generate an initializer (`config/initializers/active_authentication.rb`) where you can configure the concerns. By default, this command enables all concerns. If you want to use a subset of the concerns, you can specify them:

```bash
$ rails generate active_authentication:install confirmable
```

In this example, only the confirmable concern will be enabled (along with authenticatable, which can't be turned off).

You will need to set up the default url options in your `config/environments/development.rb`:

```ruby
config.action_mailer.default_url_options = {host: "localhost", port: 3000}
```

And the `root` path in `config/routes.rb`.

Finally, run `rails db:migrate`.

### Concerns

If you look at the `User` model (in `app/models/user.rb`), you will notice there's only a sentence:

```ruby
class User < ApplicationRecord
  authenticates_with :confirmable, :lockable, :recoverable, :registerable, :timeoutable, :trackable
end
```

Notice that `:authenticatable` is not in the list. This is because you cannot turn it off.

By default, all concerns are turned on except omniauthable. But you can turn it on by adding it to the list, and similarly, you can turn any concern off by just removing them from the list. If you plan to not use any concerns, you can replace `authenticates_with` with `authenticates`.

### Filters and helpers

ActiveAuthentication comes with filters and helpers you can use in your controllers and views.

To protect actions from being accessed by unauthenticated users, use the `authenticate_user!` filter:

```ruby
before_action :authenticate_user!
```

Then, to verify if there's an authenticated user, you can use the `user_signed_in?` helper.

Similarly, you can use `current_user` to access the current authenticated user.

### Omniauthable

ActiveAuthentication's implementation of OmniAuth allows you to sign in and/or sign up with your third party accounts or sign up with ActiveAuthentication and later connect your third party accounts to ActiveAuthentication's User. To accomplish this, ActiveAuthentication relies on an `Authentication` model which can be created with the `active_authentication:omniauthable` generator.

To set up the omniauthable concern you must configure your OmniAuth providers as you would do with plain OmniAuth. There's no OmniAuth config in ActiveAuthentication. For example, in `config/initializers/omniauth.rb` you would set the middleware:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"]
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
  # ... and any other omniauth strategies
end
```

And then you need to run the omniauthable generator to generate the `Authentication` model:

```bash
$ rails g active_authentication:omniauthable
```

The User model has many Authentication models associated, to allow you to connect your user with multiple third party services if required.

By adding the `:omniauthable` concern to your `User` model, the following routes will be added to your app:

* `/auth/:provider` to redirect your users to the provider consent screen
* `/auth/:provider/callback` to actually sign in/sign up with the given providers

The sign in and sign up views will show a link to sign in or sign up with each provider you configured if and only if you set the `ActiveAuthentication.omniauth_providers` setting in your ActiveAuthentication initializer.

## Customization

### Concerns configuration

When you run the `active_authentication:install` generator, an initializer will be copied to your app at `config/initializers/active_authentication.rb`. There's a section per concern where you can configure certain aspects of their behavior.

### Views

The default views are good enough to get you started, but you'll want to customize them sooner than later. To copy the default views into your app, run the following command:

```bash
$ rails generate active_authentication:views
```

If you're not using all the concerns, you might want to copy only the views you need. To do that, you can use the `--views` (`-v`) option:

```bash
$ rails generate active_authentication:views -v sessions
```

### Omniauthable

By default, ActiveAuthentication stores the `provider`, `uid` and `auth_data` in the `Authentication` model. There are some cases where you want to store, for example, the first name and last name in the `User` model to avoid digging into the `auth_data` hash each time. Or if you have multiple authentications, you might want to pull first and last name on registration and later allow the user to change them. To pull that data from an Authentication object at sign up, you don't really need to change the controller, instead you can add a callback to your Authentication model, like this:

```ruby
class Authentication < ApplicationRecord
  before_validation :update_user_attributes, if: ->(auth) { auth.auth_data.present? && auth.user.present? }

  private

  def update_user_attributes
    first_name, last_name = auth_data.dig("info", "first_name"), auth_data.dig("info", "last_name")

    user.update first_name: first_name, last_name: last_name
  end
end
```

Note: this example assumes `first_name:string` and `last_name:string` have been added to the User model and are required. Optional first_name and last_name can be handled similarly.

## Contributing

You can open an issue or a PR in GitHub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
