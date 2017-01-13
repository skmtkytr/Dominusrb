module Dominusrb

  module DiscordCommands
    module Autorole
      extend Discordrb::Commands::CommandContainer
      extend Dominusrb

      command [:addautorole,:addar] ,
              min_args: 1,
              usage: "
#{BOT.prefix}addautorole [role] ...
#{BOT.prefix}addar [role] ...",
              description: 'add autorole role' do |event , *roles|
        exist_role = []
        already_role = []
        roles.each do |role_data|
          role_data = get_role(role_data, event.server.id)
          exist_role << role_data if role_data
        end

        server = get_record(event.server.id)

        unless server
          Database::Server.create(server_id: event.server.id,
                                     server_name: BOT.server(event.server.id).name,
                                     author_id: event.user.id,
                                     author_name: event.user.name)
          server = get_record(event.server.id)
        end

        exist_role.each do |role|
          next if role.nil?
          if !server.roles.empty? || server.roles.find {|dbrole| dbrole.role_id == role.id}
            already_role << role
            next
          end
          server.add_role(role_id: role.id)
        end

        if exist_role.empty?
          event.respond "does not server role **#{roles.join(' ')}**"
          break
        end
        if already_role == exist_role
          event.respond "autorole settings already exist `#{already_role.map(&:name).join(',')}`"
          break
        end

        event.respond "added autorole role **#{exist_role.map(&:name).join(' ')}**"
        BOT.debug "success add role #{exist_role.map(&:name).join(' ')}"
      end

      command [:delautorole,:delar] ,
              min_args: 1,
              usages: "
#{BOT.prefix}delautorole [role] ...
#{BOT.prefix}delar [role] ...",
              description: 'delete autorole role' do |event , *roles|

        server = get_record(event.server.id)
        if server.nil? || server.roles.empty?
          event.respond "Setting is Empty"
          break
        end
        exist_role = []
        roles.each do |role_data|
          role_data = get_role(role_data, event.server.id)
          exist_role << role_data if role_data
        end

        server.roles.each do |role|
          role.delete if exist_role.map(&:id).find(role.role_id)
        end

        "delete autorole role **#{roles.join(' ')}**"
      end

      command [:autorole,:ar] , description: 'toggle autorole Enable/Disable' do |event|
        server = get_record(event.server.id)
        if server.nil?
          Database::Server.create(server_id: event.server.id,
                                     server_name: BOT.server(event.server.id).name,
                                     author_id: event.user.id,
                                     author_name: event.user.name,
                                     enable_autorole: true)
          event.respond "Set **Enable** Autorole"
        else
          # 0 => true / 1 => false
          toggle = if server.enable_autorole.zero?
                     1
                   else
                     0
                   end
          Database::Server.where(server_id: event.server.id).all { |record| record.update(enable_autorole: toggle)}
          event.respond "Set **#{toggle.zero? ? "Enable":"Disable"}** Autorole"
        end
      end

      command [:chkautorole,:chkar] , description: 'check autorole role' do |event|
        server = get_record(event.server.id)
        if server.nil? || server.roles.empty?
          "Autorole Setting is **#{server.enable_autorole.zero? ? "Enable":"Disable"}**
autorole roles are **Empty**"
        else
          setted_role = []
          server.roles.each {|role| setted_role << get_role_id(role.role_id ,event.server.id)}
          "Autorole Settings **#{server.enable_autorole.zero? ? "Enable":"Disable"}**
autorole roles: **#{setted_role.map(&:name).join(' ')}**"
        end
      end
    end
  end
end