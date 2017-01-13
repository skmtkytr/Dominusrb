module Dominusrb
  module DiscordEvents
    module Message
      extend Discordrb::EventContainer

      # The `mention` event is called if the bot is *directly mentioned*, i.e. not using a role mention or @everyone/@here.
      # The `pm` method is used to send a private message (also called a DM or direct message) to the user who sent the
      # initial message.
      BOT.mention do |event|
        event.respond("#{event.author.mention} You have mentioned me!")
      end

      BOT.message(containing: ["touch of god","touch" ,"god"]) do |event|
        # break unless event.messages.mention_everyone?
        event.respond "touch of god!"
      end

      BOT.message(from: ["kyotaro","test"], in: "#testing") do |event|

        event.respond "testing! @#{event.server.to}"
      end

    end
  end
end