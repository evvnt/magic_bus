# frozen_string_literal: true

require_relative "magic_bus/version"

# The MagicBus allows events to be delivered between applications.
# To publish an message use the #publish method.
module MagicBus
  class Error < StandardError; end
end
require_relative "magic_bus/configure"
require_relative "magic_bus/publish"
