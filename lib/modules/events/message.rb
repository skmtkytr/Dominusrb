module Dominusrb
  module DiscordEvents
    module Message
      extend Discordrb::EventContainer

      # The `mention` event is called if the bot is *directly mentioned*, i.e. not using a role mention or @everyone/@here.
      # The `pm` method is used to send a private message (also called a DM or direct message) to the user who sent the
      # initial message.
      BOT.mention do |event|
        res = [
            "I offered you the gift of exile and you used it to reinvent yourself. I couldn't wish for a more potent instrument.",
            "I exiled an animal. Now you almost resemble a man, Karui.",
            "You'd bite the master that called you here, Witch?",
            "I've dealt with far darker shadows than you, exile.",
            "Welcome to the greatest of arenas, Duelist. God is watching.",
            "Exile has tested you, my brother. Now let's see what God has to say.",
            "It is woman's purpose to tempt and try the will of man.",
            "Shrink not from god!",
            "The touch of God!",
            "The light of divinity!",
            "Die!",
            "Die in awe!",
            "Nightmare prevails!",
            "This world is an illusion, exile."
        ]
        event.respond("#{event.author.mention} #{res.sample}")
      end

      BOT.message(from: ["kyotaro","test"], in: "#testing") do |event|

        event.respond "testing! @#{event.server.to}"
      end

    end
  end
end