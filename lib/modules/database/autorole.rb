module Dominusrb

  module Database
    class Role < Sequel::Model
      many_to_one :autoroles

      # Logging
      def after_create
        super
        Discordrb::LOGGER.info "created role entry #{inspect}"
      end

      def after_update
        super
        Discordrb::LOGGER.info "updated role entry #{inspect}"

      end
    end
    class Autorole < Sequel::Model
      one_to_many :roles , :class => Database::Role

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