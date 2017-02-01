# Gems
require 'sequel'

module Dominusrb
  # Dominusrb's database
  module Database
    # Connect to database
    DB = Sequel.connect(ENV['DATABASE_URL'])
    DB.loggers << Discordrb::LOGGER
    DB.sql_log_level = :debug

    # Load migrations
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'lib/modules/database/migrations')

    # Timestamp all model instances using +created_at+ and +updated_at+
    Sequel::Model.plugin :timestamps

    # Load models
    Dir['lib/modules/database/*.rb'].each { |mod| load mod }

    def self.init!
    end

  end
end