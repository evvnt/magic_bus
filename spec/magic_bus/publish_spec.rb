# frozen_string_literal: true

require "spec_helper"
require "magic_bus/worker"

RSpec.describe MagicBus, "#publish" do
  it "calls sns.publish" do
    allow(described_class.sns).to receive(:publish)
    expect(described_class.publish(event: "Blah", message: { anything: :is_good })).to be(nil)
  end
end
