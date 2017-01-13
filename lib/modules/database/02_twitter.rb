module Dominusrb
  module Database
    class Twittersearch < Sequel::Model
      many_to_one :servers

      def on_twittersearch
        self.update(enable_twittersearch: 0)
      end

      def off_twittersearch
        self.update(enable_twittersearch: 1)
      end

      # Logging
      def after_create
        super
        Discordrb::LOGGER.info "created twitter search entry #{inspect}"
      end

      def after_update
        super
        Discordrb::LOGGER.info "updated twitter search entry #{inspect}"
      end
    end
  end
end