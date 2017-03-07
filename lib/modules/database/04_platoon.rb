module Dominusrb
  module Database
    class Platoonmember < Sequel::Model
      many_to_one :platoonrooms

    end

    class Platoonroom < Sequel::Model
      many_to_one :platoonlobbies
      one_to_many :platoonmembers , :class => Database::Platoonmember

      def after_create
        super
        Discordrb::LOGGER.info "created Platoonroom entry #{inspect}"
      end

      def after_update
        super
        Discordrb::LOGGER.info "updated Platoonroom entry #{inspect}"
      end
    end

    class Platoonlobby < Sequel::Model
      one_to_one :servers
      one_to_many :platoonrooms , :class => Database::Platoonroom

      def after_create
        super
        Discordrb::LOGGER.info "created Platoonlobby entry #{inspect}"
      end

      def after_update
        super
        Discordrb::LOGGER.info "updated Platoonlobby entry #{inspect}"
      end
    end
  end
end
