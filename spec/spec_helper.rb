ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'capybara/rspec'
require 'email_spec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Capybara.app_host = 'http://example.com'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  #config.include Devise::TestHelpers, type: :controller
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Apartment::Database.reset
    drop_schemas
    Capybara.app_host = 'http://example.com'
    reset_mailer
  end
end