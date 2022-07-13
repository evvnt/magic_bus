# frozen_string_literal: true

require "rails/railtie"
require_relative "active_record/rides"

module MagicBus
  # Railtie that initializes the magic bus
  class Railtie < Rails::Railtie
    initializer "new_initialization_behavior" do
      MagicBus.configure!
      ::ActiveRecord::Base.extend MagicBus::ActiveRecord::Rides
    end
  end
end
