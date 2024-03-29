source 'https://rubygems.org'

# Padrino supports Ruby version 1.9 and later
# ruby '2.3.0'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'activesupport', '>= 3.1'
gem 'bcrypt'
gem 'sass'
gem 'erubis', '~> 2.7.0'
gem 'pg'
gem 'sequel'

# Test requirements
gem 'rspec', :group => 'test'
gem 'rack-test', :require => 'rack/test', :group => 'test'

# Padrino Stable Gem
gem 'padrino', '0.15.0'

gem 'dotenv'

# Required APIs
gem 'gmail'
gem 'active_shipping', git: 'https://github.com/billiam/active_shipping', branch: 'develop'
gem 'mail', '~> 2.6.5'

gem 'webpush'
gem 'rack-parser'
gem 'oj', require: false
gem 'mechanize', require: false
gem 'carrierwave'
gem 'carrierwave-sequel', :require => 'carrierwave/sequel'

group :development do
  gem 'sequel-annotate'
  gem 'pry'
  gem 'pry-byebug', '~> 3.0.0'
end

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core support gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.13.3.3'
# end
