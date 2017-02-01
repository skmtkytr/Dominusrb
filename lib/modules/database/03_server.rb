module Dominusrb
  module Database
    class Server < Sequel::Model
      one_to_many :roles , :class => Database::Role
      one_to_many :twittersearches , :class => Database::Twittersearch

      # Logging
      def after_create
        super
        Discordrb::LOGGER.info "created server entry #{inspect}"
      end

      def after_update
        super
        Discordrb::LOGGER.info "updated server entry #{inspect}"
      end
    end
  end
end
