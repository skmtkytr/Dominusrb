module Dominusrb

  module DiscordCommands
    module Ping
      extend Discordrb::Commands::CommandContainer

      command :ping , description: 'checks if bot is alive',
          usage: "#{BOT.prefix}ping",
          help_available: false do |event|
        m = event.respond "`pong!`"
        m.edit "Pong! `Time taken:` **#{Time.now - event.timestamp}** `seconds.`"
      end
    end
  end
end
