# frozen_string_literal: true

require "magic_bus"
require_relative "testing_bus"
require "json"

module MagicBus
  # Default worker that processes messages arriving on the (magic) event bus
  # It reads the event name and then loads a class to match and calls perform on the class
  class Worker
    include Shoryuken::Worker

    shoryuken_options queue: MagicBus.sqs_queue, auto_delete: true
    def perform(sqs_msg, message)
      processor = class_from_string(sqs_msg.message_attributes["event"]["string_value"])
      processor.new.perform(JSON.parse(message))
    end

    private

    def class_from_string(str)
      str.split("::").inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end
  end
end
