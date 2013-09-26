source 'http://rubygems.org'

gem 'rails', '~> 3.0.3'

gem "rake", "0.8.7"
gem "will_paginate", "~> 3.0.pre2"
gem 'teambox-permalink_fu', :git => 'git://github.com/mconf/permalink_fu.git'
gem 'jquery-rails', '>= 0.2.6'
gem 'vpim'
gem 'ruby-openid'
gem 'atom-tools'
gem 'rcov'
gem 'chronic'
gem 'hpricot'
gem 'feed-normalizer'
gem 'hoe'
gem 'httparty'
#gem 'pdf-writer'
gem 'ci_reporter'
#gem 'nokogiri', '1.4.1'
gem 'nokogiri'
gem 'prism'
gem 'rubyzip' # TODO: see rubyzip2
gem 'garb'
gem 'rmagick', :git => 'git://github.com/rmagick/rmagick.git', :require => false
gem 'fckeditor'
gem 'dynamic_form'
gem 'bigbluebutton-api-ruby', :git => 'git://github.com/mconf/bigbluebutton-api-ruby.git'
gem 'bigbluebutton_rails', :git => 'git://github.com/mconf/bigbluebutton_rails.git'
gem 'rspec-rails', '~> 2.5'
gem 'action_mailer_tls'
gem 'attachment_fu', :git => 'git://github.com/mconf/attachment_fu.git'
gem 'yaml_db'
gem 'delayed_job'
gem 'whenever', :require => false
gem 'configatron'
gem "recaptcha", :require => "recaptcha/rails"

gem 'mysql2', '~> 0.2.0' # must use 0.2.x releases in Rails <= 3.0.x

# not the official repo, but has fixes to use it with rails 3
gem 'table_helper', :git => 'git://github.com/echen/table_helper.git'

group :development do
  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'translate-rails3', :require => 'translate', :git => 'git://github.com/mconf/translate.git'
  gem 'spork-rails'
  gem 'rails-footnotes'
end

group :development, :test do
  gem 'populator'
  gem 'ffaker'
  gem 'factory_girl'
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'webrat'
  gem 'rspec-instafail'
  gem 'fuubar'
  gem 'shoulda-matchers'
  gem 'htmlentities'
end

# for production
gem 'god', '0.12.1'
gem 'passenger', '3.0.11'
gem 'exception_notification'
