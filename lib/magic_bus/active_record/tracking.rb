# frozen_string_literal: true

require "active_support/concern"

module MagicBus
  module ActiveRecord
    # :nodoc:
    module Tracking
      extend ActiveSupport::Concern

      included do
        after_create :track_create_activity!
        after_update :track_update_activity!
        after_destroy :track_destroy_activity!
        cattr_accessor(:__excluded_attributes) { [] }
      end

      class_methods do
        def exclude_activity_attributes(*attributes)
          self.__excluded_attributes += attributes.map(&:to_s)
        end
      end

      def activity_attributes
        @activity_attributes ||= {}
      end

      private

      def tracking?
        MagicBus.tracking?
      end

      def track_activity!(type, changes = {})
        return true unless tracking?

        change_set = { model: self.class.model_name.name,
                       primary_key_name: self.class.primary_key,
                       primary_key: send(self.class.primary_key.to_sym),
                       activity_type: type,
                       attribute_changes: changes[:attribute_changes] }
        change_set.merge!(uuid: uuid) if respond_to?(:uuid)
        MagicBus << change_set
      end

      def track_create_activity!
        return true unless activity_changes.any?

        track_activity!(:created, activity_attributes.merge(attribute_changes: activity_changes))
        true
      end

      def track_update_activity!
        return true unless activity_changes.any?

        track_activity!(:updated, activity_attributes.merge(attribute_changes: activity_changes))
        true
      end

      def track_destroy_activity!
        track_activity!(:destroyed, activity_attributes)
        true
      end

      def activity_changes
        saved_changes.except!(*self.class.__excluded_attributes)
      end
    end
  end
end
