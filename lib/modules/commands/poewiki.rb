module Dominusrb
  module DiscordCommands
    module PoeWiki
      extend Discordrb::Commands::CommandContainer
      extend Dominusrb

      WIKIURI = 'http://pathofexile.gamepedia.com/'.freeze

      command [:poewiki, :pwiki],
              min_args:1,
          description: "generate Unique Item Wiki Link" do |event, *text|

        arg = event.message.content.split("\n")

        url = WIKIURI+arg[1].split(" ").join("_")

        event.message.delete

        event.respond url.encode
      end

    end
  end
end