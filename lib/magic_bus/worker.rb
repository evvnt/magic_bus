# frozen_string_literal: true

require "magic_bus"
require_relative "testing_bus"
require_relative "tracking"
require "json"

module MagicBus
  # Default worker that processes messages arriving on the (magic) event bus
  # It reads the event name and then loads a class to match and calls perform on the class
  class Worker
    include Shoryuken::Worker

    shoryuken_options queue: MagicBus.sqs_queue, auto_delete: true

    def perform(sqs_msg, message)
      puts "perform: #{sqs_msg.inspect}, #{message.inspect}"
      processor = class_from_string(sqs_msg.message_attributes["event"]["string_value"])
      processor_instance = processor.new
      options = processor_instance.respond_to?(:object_class) ? { object_class: processor_instance.object_class } : {}
      entities = JSON.parse(message).map { |hash| JSON.parse(hash.to_json, options) }
      processor_instance.perform(sqs_msg, entities)
    end

    private

    def class_from_string(str)
      arr = str.split("::")
      class_name = arr.pop
      mod = arr.join('::').constantize || Object
      mod.const_get(class_name)
    end
  end
end
