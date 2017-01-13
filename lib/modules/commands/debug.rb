module Dominusrb
  module DiscordCommands
    module Debug
      extend Discordrb::Commands::CommandContainer

      # default "false"
      debug = false

      command :debug , description: 'swap debug mode' do |event|
        unless event.user.id == BOT.bot_app.owner.id
          event.respond 'You are not Bot Owner'
          break
        end

        if debug
          BOT.debug '-------- debug mode OFF --------'
          BOT.mode=:normal
          debug = false
          event.respond "`debug mode` **OFF**"
        else
          BOT.mode=:debug
          BOT.debug '-------- debug mode ON --------'
          debug = true
          event.respond "`debug mode` **ON**"
        end
      end
    end
  end
end