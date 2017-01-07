# Gems
require 'sequel'

module Dominusrb
  # Dominusrb's database
  module Database
    # Connect to database
    DB = Sequel.connect('sqlite://data/dominusrb.sqlite3')

    # Load migrations
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'lib/modules/database/migrations')

    # Timestamp all model instances using +created_at+ and +updated_at+
    Sequel::Model.plugin :timestamps

    # Load models
    Dir['lib/modules/database/*.rb'].each { |mod| load mod }

    # Initialize database (maybe)
    def self.init!
      # sync with data/dah-cards
    end

  end
end