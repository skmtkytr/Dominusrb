module Dominusrb
  module DiscordCommands
    module Info
      extend Discordrb::Commands::CommandContainer

      command :info , description: 'bot info' do |event|

        e = Discordrb::Webhooks::Embed.new
        owner = BOT.bot_app.owner
        e.color = 0xa8ff99
        e.thumbnail = { url: owner.avatar_url }
        e.description = "This bot Owner ->**#{owner.name}** (#{owner.mention})"

        event.channel.send_embed '',e
      end
    end
  end
end