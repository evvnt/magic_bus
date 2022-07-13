# frozen_string_literal: true

require "spec_helper"
require "magic_bus/worker"

RSpec.describe MagicBus::Worker, "#perform" do
  subject(:magic_bus) { described_class.new }

  let(:sqs_msg) do
    instance_double("sqs_msg", { message_id: "fc754df7-9cc2-4c41-96ca-5996a44b771e",
                                 body: body, delete: nil,
                                 message_attributes: { "event" => { "string_value" => "MagicBus::TestingBus" } } })
  end

  let(:body) { { sent_at: Time.now.to_f }.to_json }

  it "prints the body message" do
    expect { magic_bus.perform(sqs_msg, body) }.to output(/sent_at/).to_stdout
  end
end
