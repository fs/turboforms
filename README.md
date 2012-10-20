# Turboforms

Turbolinks behaviour for forms.

## Installation

1. Add to your Gemfile:

  ```ruby
  gem 'turbolinks', git: 'git://github.com/fs/turbolinks.git'
  gem 'turboforms', git: 'git://github.com/fs/turboform.git'
  ```

2. Run `bundle install`.
3. Add to your Javascript manifest file (usually found at `app/assets/javascripts/application.js`).

  ```
  //= require turbolinks
  //= require jquery.turboforms
  ```

4. Add `remote: true` attribute to make your form turbo powered.
5. Restart your server and you're now using turboforms!
