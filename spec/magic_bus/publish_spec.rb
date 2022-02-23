# frozen_string_literal: true

require "spec_helper"
require "magic_bus/worker"

RSpec.describe MagicBus, "#publish" do
  let(:sqs_msg) do
    { message_id: "fc754df7-9cc2-4c41-96ca-5996a44b771e",
      body: body, delete: nil, message_attributes: { "event" => { "string_value" => "MagicBus::TestingBus" } } }
  end
  let(:body) { { sent_at: Time.now.to_f }.to_json }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("MAGIC_BUS_BUS_NAME")
                              .and_return("who")
    allow(ENV).to receive(:[]).with("MAGIC_BUS_APP_NAME")
                              .and_return("rspec")
    allow(ENV).to receive(:[]).with("MAGIC_BUS_AWS_ACCOUNT_ID")
                              .and_return("12345")
    allow(ENV).to receive(:[]).with("MAGIC_BUS_AWS_ACCESS_KEY_ID")
                              .and_return("98765")
    allow(ENV).to receive(:[]).with("MAGIC_BUS_AWS_REGION")
                              .and_return("unknown")
    described_class.configure!
  end

  describe "#publish" do
    it "calls sns.publish" do
      allow(described_class.sns).to receive(:publish)
      expect(described_class.publish(event: "Blah", message: { anything: :is_good })).to be(nil)
    end
  end
end
