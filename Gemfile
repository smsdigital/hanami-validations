# frozen_string_literal: true

source "http://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", require: false, platforms: :mri
  gem "yard",   require: false
end

gem 'dry-logic', '~> 0.4.2', git: 'https://github.com/smsdigital/dry-logic', tag: 'v0.4.2.1'
gem 'dry-types', '~> 0.12.3', git: 'https://github.com/smsdigital/dry-types', tag: 'v0.12.3.1'
gem 'dry-validation', '~> 0.11.2', git: 'https://github.com/smsdigital/dry-validation', tag: 'v0.11.2.1'
gem "hanami-utils", "~> 1.3", require: false, git: "https://github.com/hanami/utils.git", branch: "master"

gem "hanami-devtools", require: false, git: "https://github.com/hanami/devtools.git"
gem "i18n", "~> 1.0",  require: false
