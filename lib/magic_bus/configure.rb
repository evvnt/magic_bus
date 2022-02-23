# frozen_string_literal: true

require "aws-sdk-sns"
require "shoryuken"

# The MagicBus allows events to be delivered between applications.
# To publish an message use the #publish method.
module MagicBus
  class << self
    def configure!
      check_env
      set_instance_variables
      configure_sns
      configure_shoryuken
    end

    def check_env
      unless ENV["MAGIC_BUS_AWS_ACCOUNT_ID"] &&
             ENV["MAGIC_BUS_AWS_REGION"] &&
             ENV["MAGIC_BUS_AWS_ACCESS_KEY_ID"] &&
             ENV["MAGIC_BUS_AWS_SECRET_ACCESS_KEY"] &&
             ENV["MAGIC_BUS_BUS_NAME"] &&
             ENV["MAGIC_BUS_APP_NAME"]
        warn "Missing MAGIC_BUS Configuration Key(s). Ensure you have defined all required ENV variables. " \
             "See README.md for more details."
      end
    end

    def set_instance_variables
      MagicBus.aws_account_id = ENV["MAGIC_BUS_AWS_ACCOUNT_ID"]
      MagicBus.aws_region = ENV["MAGIC_BUS_AWS_REGION"]
      MagicBus.bus_name = ENV["MAGIC_BUS_BUS_NAME"]
      MagicBus.app_name = ENV["MAGIC_BUS_APP_NAME"]

      MagicBus.sns_arn = "arn:aws:sns:#{MagicBus.aws_region}:#{MagicBus.aws_account_id}:" \
                         "#{MagicBus.bus_name}-event-bus.fifo"

      MagicBus.sqs_queue = "#{MagicBus.bus_name}-event-bus-#{MagicBus.app_name}.fifo"
    end

    def configure_sns
      MagicBus.sns = Aws::SNS::Client.new(region: MagicBus.aws_region,
                                          access_key_id: ENV["MAGIC_BUS_AWS_ACCESS_KEY_ID"],
                                          secret_access_key: ENV["MAGIC_BUS_AWS_SECRET_ACCESS_KEY"])
    end

    def configure_shoryuken
      Shoryuken.sqs_client_receive_message_opts = {
        max_number_of_messages: 10
      }
      Shoryuken.sqs_client = Aws::SQS::Client.new(region: MagicBus.aws_region,
                                                  access_key_id: ENV["EVENT_BUS_AWS_ACCESS_KEY_ID"],
                                                  secret_access_key: ENV["EVENT_BUS_AWS_SECRET_ACCESS_KEY"])
    end
  end
end
MagicBus.configure! unless ENV["RACK_ENV"] == "test"
