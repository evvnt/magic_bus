# frozen_string_literal: true

require "spec_helper"
require "magic_bus/railtie"
require "active_record"

RSpec.describe MagicBus::ActiveRecord::Rides do
  before do
    MagicBus::Railtie.initializers.each(&:run)
    load "#{File.dirname(__FILE__)}/../../support/models.rb"
  end

  def without_updated_at(changes)
    changes.first[:attribute_changes]["updated_at"] = []
    changes
  end

  def without_created_at(changes)
    changes.first[:attribute_changes]["created_at"] = []
    changes
  end

  def without_timestamps(changes)
    without_created_at(without_updated_at(changes))
  end

  it "updates" do
    post = Post.create!(text: "created")
    tracking = MagicBus.tracking "event" do
      post.update!(text: "updated")
    end
    expect(without_updated_at(tracking.changes)).to eq([{ activity_type: :updated,
                                                          attribute_changes: { "text" => %w[created updated],
                                                                               "updated_at" => [] },
                                                          model: "Post",
                                                          primary_key: 1, primary_key_name: "id", uuid: nil }])
  end

  it "creates" do
    tracking = MagicBus.tracking "event" do
      Post.create!(text: "creates")
    end
    expect(without_timestamps(tracking.changes)).to eq([{ activity_type: :created,
                                                          attribute_changes: { "created_at" => [], "id" => [nil, 2],
                                                                               "text" => [nil, "creates"],
                                                                               "updated_at" => [] },
                                                          model: "Post",
                                                          primary_key: 2, primary_key_name: "id", uuid: nil }])
  end

  it "deletes" do
    post = Post.create!(text: "deletes")
    tracking = MagicBus.tracking "event" do
      post.destroy!
    end
    expect(tracking.changes).to eq([{ activity_type: :destroyed, attribute_changes: nil,
                                      model: "Post",
                                      primary_key: 3, primary_key_name: "id", uuid: nil }])
  end
end
