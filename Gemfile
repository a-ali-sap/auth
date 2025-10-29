source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.3'

gem 'rails', '~> 8.1.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.6.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'image_processing', '~> 1.2'

# Authentication & Authorization
gem 'devise'
gem 'pundit'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'

# UI & Styling
gem 'bootstrap', '~> 5.2'
gem 'jquery-rails'

# Utilities
gem 'kaminari'
gem 'ransack'
gem 'chronic'
gem 'validates_timeliness'

# File uploads
gem 'carrierwave'
gem 'mini_magick'

# Background jobs
gem 'sidekiq'
gem 'redis'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end
