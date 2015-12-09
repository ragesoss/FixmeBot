source 'https://rubygems.org'
ruby '2.2.3'

gem 'mediawiki_api'
gem 'twitter'
gem 'whenever'
gem 'figaro'
gem 'passenger'

# requires manual installation of phantomJS 1.9.*: https://gist.github.com/julionc/7476620
gem 'webshot', git: 'https://github.com/ragesoss/webshot.git'

gem 'activerecord-import'

gem 'rails', '4.2.5'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring'
  gem 'pry-rails'

  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-livereload', require: false
end
