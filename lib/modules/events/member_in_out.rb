module Dominusrb
  module DiscordEvents
    # These events are called when a member leaves and joins a server.
    module MemberJoinLeave
      extend Discordrb::EventContainer

      member_join do |event|
        channel = event.server.channels.find { |c| c.name == ENV['EVENTS_CHANNEL'] }
        channel&.send_embed '', user_embed(event.user, true)

        # Autoroling
        autorole = Database::Role.where(server_id: event.server.id ,enable_autorole: 0 ).first
        if autorole || !autorole.roles.empty?
          server_autoroles = []
          autorole.roles.each {|role| server_autoroles << DiscordCommands::Autorole.get_role_id(role.role_id,event.server.id)}
          begin
            event.member.roles=server_autoroles
            raise Exception.new("NoPermission: The bot doesn't have the required permission to do this!")
          rescue => e
            BOT.debug e
            channel&.send_message "NoAutorolePermission: **#{e}**"
          end

          BOT.debug "Success autorole settings"
        end

        nil
      end

      member_leave do |event|
        channel = event.server.channels.find { |c| c.name == ENV['EVENTS_CHANNEL'] }
        channel&.send_embed '', user_embed(event.user, false)
        nil
      end

      module_function

      def user_embed(user, join)
        e = Discordrb::Webhooks::Embed.new
        e.author = {
            name: join ? 'Member Joined' : 'Member Left',
            icon_url: join ? 'http://emojipedia-us.s3.amazonaws.com/cache/72/7d/727d10a592ac37ab2844286e0cd70168.png' : 'http://emojipedia-us.s3.amazonaws.com/cache/32/9d/329df0e266f6e63ed5a4be23840b3513.png'
        }
        e.color = join ? 0xa8ff99 : 0xff7777
        e.thumbnail = { url: user.avatar_url }
        e.description = "**#{user.distinct}** (#{user.mention})"
        e.footer = { text: user.id.to_s }
        e.timestamp = Time.now
        e
      end
    end
  end
end