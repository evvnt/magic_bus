# frozen_string_literal: true

# :nodoc:
module MagicBus
  # Class that tracks changes on a model
  class Tracking
    attr_accessor :changes
    attr_reader :event

    def initialize(event)
      @event = event
      @changes = []
      @augmented_data = {}
      @sns_response = nil
    end

    def <<(changes)
      @changes << changes
      self
    end

    def changes?
      @changes.any?
    end

    # Used to add additional data to the message.
    # block should return a hash
    def augment(&block)
      self << block.call if block_given?
      self
    end

    def publish(group_id: nil, &block)
      return unless changes?

      publish = true
      publish = block.call(@changes) if block_given?
      if publish
        if @sns_response
          raise MagicBus::Error, "Message already published! " \
                                 "You can not call publish more than once per tracking block."
        end
        @sns_response = MagicBus.publish(event: @event,
                                         message: @changes,
                                         group_id: group_id)
      end
      self
    end
  end
  class << self
    def tracking(event, &block)
      tracker = Tracking.new(event)
      Thread.current[:mb_tracking] = tracker
      begin
        block.call(self) if block_given?
      ensure
        Thread.current[:mb_tracking] = nil
      end
      tracker
    end

    def <<(changes)
      return nil unless tracking?

      Thread.current[:mb_tracking] << changes
    end

    def tracking?
      !Thread.current[:mb_tracking].nil?
    end
  end
end
