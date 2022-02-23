# frozen_string_literal: true

require "spec_helper"
require "magic_bus/worker"

RSpec.describe MagicBus::Worker do
  let(:sqs_msg) do
    instance_double("sqs_msg", { message_id: "fc754df7-9cc2-4c41-96ca-5996a44b771e",
                                 body: body, delete: nil,
                                 message_attributes: { "event" => { "string_value" => "MagicBus::TestingBus" } } })
  end

  let(:body) { { sent_at: Time.now.to_f }.to_json }

  before do
    allow(ENV).to receive(:[]).and_call_original
    [%w[MAGIC_BUS_BUS_NAME who],
     %w[MAGIC_BUS_APP_NAME rspec],
     %w[MAGIC_BUS_AWS_ACCOUNT_ID 12345],
     %w[MAGIC_BUS_AWS_ACCESS_KEY_ID 98765],
     %w[MAGIC_BUS_AWS_REGION unknown]].each do |key, value|
      allow(ENV).to receive(:[]).with(key)
                                .and_return(value)
    end
    MagicBus.configure!
  end

  describe "#perform" do
    subject(:magic_bus) { described_class.new }

    it "prints the body message" do
      expect { magic_bus.perform(sqs_msg, body) }.to output(/sent_at/).to_stdout
    end
  end
end
