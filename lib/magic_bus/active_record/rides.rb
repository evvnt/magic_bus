# frozen_string_literal: true

# require 'active_support/concern'

module MagicBus
  module ActiveRecord
    # Implements class level method for tracking changes that can be broadcast on the magic bus
    module Rides
      # Includes Magic Bus Tracking module in specified model # This will cause change events for the given model
      # to be published on the MagicBus (SNS=>SQS)
      #
      # @params exclude_activity_attributes [:foo, :bar]
      # if given, excludes specified params from tracking

      def rides_magic_bus(args = {})
        require "magic_bus/active_record/tracking"
        include ::MagicBus::ActiveRecord::Tracking

        exclude_activity_attributes(*args[:exclude_activity_attributes]) if args[:exclude_activity_attributes]
      end
    end
  end
end
