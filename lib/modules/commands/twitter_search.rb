require 'twitter'

module Dominusrb
  module DiscordCommands
    module TwitterSearch
      extend Discordrb::Commands::CommandContainer
      extend Dominusrb

      command [:twitter,:tw],
              required_permissions: [:manage_server],
              description: "Toggle Twitter Searching Enable/Disable this channel" do |event|

        # toggle code
        server = get_record(event.server.id)
        unless server
          Database::Server.create(server_id: event.server.id,
                                  server_name: BOT.server(event.server.id).name,
                                  author_id: event.user.id,
                                  author_name: event.user.name)
        end

        twittersearch = Database::Twittersearch.where(channel_id: event.channel.id).first
        if twittersearch.nil?
          event.respond "Twitter Search Setting is Empty"
          break
        end

        if twittersearch.enable_twittersearch.zero?
          twittersearch.off_twittersearch
          "**Disable** Twitter Search this channel **keyword** `#{twittersearch.keyword}`"
        else
          twittersearch.on_twittersearch
          "**Enable** Twitter Search this channel **keyword** `#{twittersearch.keyword}`"
        end
      end

      command [:chktw],
              required_permissions: [:manage_server],
              description: "Check TwitterSearch Status this channel" do |event|
        server = get_record(event.server.id)
        unless server
          Database::Server.create(server_id: event.server.id,
                                  server_name: BOT.server(event.server.id).name,
                                  author_id: event.user.id,
                                  author_name: event.user.name)
          server = get_record(event.server.id)
        end

        twittersearch = Database::Twittersearch.where(server_id: server.id, channel_id: event.channel.id).first
        if twittersearch.nil?
          event.respond "Twitter Search Setting is Empty"
          break
        end

        if twittersearch.enable_twittersearch.zero?
          "TwitterSearch **Enable** this channel **keyword** `#{twittersearch.keyword}`"
        else
          "TwitterSearch **Disable** this channel **keyword** `#{twittersearch.keyword}`"
        end
      end

      command [:updttw],
              required_permissions: [:manage_server],
              min_args:1,
              max_args:1,
              usage: "#{BOT.prefix}updttw hogehoge",
              description: "update Twitter Search keyword this channel" do |event, *keyword|

        server = get_record(event.server.id)
        unless server
          Database::Server.create(server_id: event.server.id,
                                  server_name: BOT.server(event.server.id).name,
                                  author_id: event.user.id,
                                  author_name: event.user.name)
        end

        twittersearch = Database::Twittersearch.where(channel_id: event.channel.id)
        event.respond "Setting is Empty this channel" unless twittersearch

        twittersearch.update(keyword: keyword.join)
        "success update search keyword"
      end

      command [:addtw],
              required_permissions: [:manage_server],
              min_args:1,
              max_args:1,
              usage: "#{BOT.prefix}addtw hogehoge",
              description: "add Twitter Search keyword this channel" do |event, *keyword|

        # add keyword
        server = get_record(event.server.id)
        unless server
          Database::Server.create(server_id: event.server.id,
                                  server_name: BOT.server(event.server.id).name,
                                  author_id: event.user.id,
                                  author_name: event.user.name)
          server = get_record(event.server.id)
        end

        begin

          server.add_twittersearch(keyword: keyword.join,
                                  channel_id: event.channel.id)
        rescue
          event.respond "already setting keyword this channel"
          break
        end
        "success add search keyword"
      end
    end
  end
end