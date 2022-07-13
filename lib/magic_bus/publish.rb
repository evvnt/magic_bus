# frozen_string_literal: true

require "json"

# The MagicBus allows events to be delivered between applications.
# To publish a message use the #publish method.
module MagicBus
  class << self
    # @param event    The event that is being published. This should be a descriptive event name in the past tense.
    #                 It will be used by the receiving application to load the appropriate handling code.
    #                 (Each event gets its own handler.)
    #                 Example: "EventUpdated"
    # @param message  The message that fully describes the changes. This is an array of change records
    #                 plus augmented data
    # @param group_id Optional. The message_group_id to use for the sns queue.
    #                 Events are delivered in fifo order within a given message_group_id.
    def publish(event:, message:, group_id: nil)
      attributes = build_message_attributes(app_name, event)
      sns.publish({
                    target_arn: sns_arn,
                    message: message.to_json,
                    message_attributes: attributes,
                    message_group_id: group_id || "root",
                    message_deduplication_id: deduplicate_sha(message, attributes)
                  })
    end

    private

    def deduplicate_sha(message, attributes)
      sha = Digest::SHA2.new(256)
      sha << message.to_s
      sha << attributes.to_s
      sha.hexdigest
    end

    def build_message_attributes(app_name, event)
      {
        "origin" => {
          data_type: "String", # required
          string_value: app_name
        },
        "event" => {
          data_type: "String", # required
          string_value: event
        }
      }
    end
  end
end
