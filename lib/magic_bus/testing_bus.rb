# frozen_string_literal: true

module MagicBus
  # Testing class used in specs and used for interactive profile testing
  class TestingBus
    def perform(_sqs_msg, msg)
      puts msg
      # raise msg['boom'] if msg['boom']
      # arrived_at = Time.now
      # sent_at = Time.at(msg["sent_at"])
      # puts "took #{arrived_at.to_f - sent_at.to_f}s to arrive"
    end
  end
end
