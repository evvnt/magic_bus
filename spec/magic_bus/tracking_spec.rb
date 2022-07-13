# frozen_string_literal: true

require "spec_helper"

RSpec.describe MagicBus::Tracking do
  it "tracks changes" do
    tracking = MagicBus.tracking("Event Name") do |mb|
      mb << :changed
    end
    expect(tracking.changes).to eq([:changed])
  end

  describe "publishes" do
    before do
      MagicBus.sns = instance_double("sns", publish: nil)
    end

    it "doesn't publish empty changes" do
      expect(MagicBus.tracking("Event Name").publish).to be(nil)
      expect(MagicBus.sns).not_to have_received(:publish)
    end

    it "publishes changes" do
      tracking = MagicBus.tracking("Event Name") do |mb|
        mb << :changed
      end
      expect(tracking.publish.changes).to eq([:changed])
      expect(MagicBus.sns).to have_received(:publish)
    end

    it "publishes changes with true block" do
      tracking = MagicBus.tracking("Event Name") do |mb|
        mb << :changed
      end
      tracking.publish { true }
      expect(MagicBus.sns).to have_received(:publish)
    end

    it "does not publish changes with false block" do
      tracking = MagicBus.tracking("Event Name") do |mb|
        mb << :changed
      end
      tracking.publish { false }
      expect(MagicBus.sns).not_to have_received(:publish)
    end

    it "augments data" do
      tracking = MagicBus.tracking("Event Name") do |mb|
        mb << :changed
      end
      expect(tracking.augment { :augmented }.changes).to eq(%i[changed augmented])
    end
  end
end
