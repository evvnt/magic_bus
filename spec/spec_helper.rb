# frozen_string_literal: true

ENV["RACK_ENV"] = "test" # order is important here
require "magic_bus"
require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3",
                                        database: "#{File.dirname(__FILE__)}/by_star.sqlite3")
load "#{File.dirname(__FILE__)}/support/schema.rb"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("MAGIC_BUS_BUS_NAME")
                              .and_return("who")
    allow(ENV).to receive(:[]).with("MAGIC_BUS_APP_NAME")
                              .and_return("rspec")
    allow(ENV).to receive(:[]).with("MAGIC_BUS_AWS_ACCOUNT_ID")
                              .and_return("12345")
    allow(ENV).to receive(:[]).with("MAGIC_BUS_AWS_ACCESS_KEY_ID")
                              .and_return("98765")
    allow(ENV).to receive(:[]).with("MAGIC_BUS_AWS_REGION")
                              .and_return("unknown")
    MagicBus.configure!(suppress_banner: true)
  end
end
