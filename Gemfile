source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'
# User haml
gem 'haml-rails'
gem 'erb2haml'
# Use bcrypt
gem 'bcrypt', '3.1.11'
# Use CarrierWave
gem 'carrierwave', '1.1.0'
gem 'mini_magick', '4.7.0'
gem 'fog', '1.40.0'
# Use Bootstrap
gem 'bootstrap-sass', '3.3.7'
# Use will_paginate
gem 'will_paginate', '3.1.6'
gem 'bootstrap-will_paginate', '1.0.0'
# Use Puma as the app server
gem 'puma', '3.9.1'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.2.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.2.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.7.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'sqlite3', '1.3.13'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '9.0.6', platform: :mri
  # For Debug in RubyMine
  gem 'ruby-debug-ide', '0.6.1.beta9'
  gem 'debase'
  # Hirb
  gem 'hirb'
  gem 'hirb-unicode'
  # rspec
  gem 'rspec-rails', '~>3.7.0'
  gem 'factory_bot_rails', '~>4.8.0'
  gem 'guard-rspec', '~>4.7.0'
  gem 'spring-commands-rspec', '~>1.0.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '3.5.1'
  gem 'listen', '3.0.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.18'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'

  gem 'faker', '~>1.8.0'
  gem 'capybara', '~>2.15.0'
  gem 'database_cleaner', '~>1.6.0'
  gem 'launchy', '~>2.4.0'
  gem 'selenium-webdriver', '~>3.7.0'
end

group :production do
  gem 'pg', '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
