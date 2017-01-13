module Dominusrb

  module Database
    class Role < Sequel::Model
      many_to_one :servers

      # Logging
      def after_create
        super
        Discordrb::LOGGER.info "created autorole entry #{inspect}"
      end

      def after_update
        super
        Discordrb::LOGGER.info "updated autorole entry #{inspect}"
      end
    end
  end
end