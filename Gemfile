# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.5'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

# Support for additional languages
gem 'rails-i18n'

# Authorization
gem 'devise'
gem 'devise-i18n'

# Sass engine
gem 'sassc-rails'

# Bootstrap styles
gem 'bootstrap', '~> 5.3.2'
gem 'jquery-rails'

# Cloudinary for image storage
gem 'cloudinary'

# Ability
gem 'cancancan'

# Pagination
gem 'pagy', '~> 7.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  # Testing framework
  gem 'rspec-rails', '7.1.0'
  # Fixtures replacement with a straightforward definition syntax
  gem 'factory_bot_rails', '6.4.4'
  # Library for generating fake data
  gem 'faker', '3.5.1'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # RuboCop is a Ruby code style checking and code formatting tool.
  gem 'rubocop', '1.68.0', require: false
  # Automatic Rails code style checking tool.
  gem 'rubocop-rails', '2.27.0', require: false
  # A collection of RuboCop cops to check for performance optimizations in Ruby code.
  gem 'rubocop-performance', '1.22.1', require: false
  # Code style checking for RSpec files
  gem 'rubocop-rspec', '3.2.0', require: false
  gem 'rubocop-rspec_rails', '2.30.0', require: false
  # Code style checking for factory_bot files
  gem 'rubocop-factory_bot', '2.26.1', require: false
  # Code style checking for Capybara test files
  gem 'rubocop-capybara', '2.21.0', require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end
