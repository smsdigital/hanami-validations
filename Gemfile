# frozen_string_literal: true

source "http://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", require: false, platforms: :mri
  gem "yard",   require: false
end

gem 'dry-logic', git: 'https://github.com/smsdigital/dry-logic', branch: 'feature/dsa-1374-ruby-2.7-update'
gem 'dry-types', git: 'https://github.com/smsdigital/dry-types', branch: 'feature/dsa-1374-ruby-2.7-update'
gem 'dry-validation', git: 'https://github.com/smsdigital/dry-validation', branch: 'feature/dsa-1374-ruby-2.7-update'
gem "hanami-utils", "~> 1.3", require: false, git: "https://github.com/hanami/utils.git", branch: "master"

gem "hanami-devtools", require: false, git: "https://github.com/hanami/devtools.git"
gem "i18n", "~> 1.0",  require: false
