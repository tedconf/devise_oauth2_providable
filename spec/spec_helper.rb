# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
require_relative 'dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [
  File.expand_path('dummy/db/migrate', __FILE__)
]

require 'rspec/rails'
require 'shoulda-matchers'
require 'factory_bot'
require 'factory_bot_rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__dir__), 'spec/support/**/*.rb')].each {|f| require f }

# FactoryBot.find_definitions

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec

    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.use_transactional_fixtures = true

  config.include FactoryBot::Syntax::Methods

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # enable rendering of views for controller tests
  # see http://stackoverflow.com/questions/4401539/rspec-2-how-to-render-views-by-default-for-all-controller-specs
  config.render_views
end

ActiveRecord::Migration.maintain_test_schema!
mig_file_path = File.expand_path('dummy/db/migrate/', __dir__)
if Rails.version <= '6.0'
  ActiveRecord::MigrationContext.new(mig_file_path).migrate
else
  ActiveRecord::MigrationContext.new(mig_file_path, ActiveRecord::SchemaMigration).migrate
end
