ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "database_cleaner/active_record"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

<<<<<<< HEAD
    include Devise::Test::IntegrationHelpers

    # Add more helper methods to be used by all tests here...
=======
  # Configure DatabaseCleaner to use transaction strategy
  DatabaseCleaner.strategy = :transaction

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
>>>>>>> 12af641c8ec44d3968c9ae7c82c1eeffd146838a
  end
end
