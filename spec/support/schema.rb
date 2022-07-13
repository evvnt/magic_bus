# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, force: true do |t|
    t.string :text
    t.string :uuid
    t.timestamps
  end
end
