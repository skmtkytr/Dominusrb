module Dominusrb

  module DiscordCommands
    module Autorole
      extend Discordrb::Commands::CommandContainer

      def self.get_role(role,server_id)
        server = BOT.server server_id
        server.roles.find {|server_role| server_role.name == role}
      end

      def self.get_role_id(role_id,server_id)
        server = BOT.server server_id
        server.roles.find {|server_role| server_role.id == role_id}
      end

      def self.get_record(server_id)
        Database::Autorole.where(server_id: server_id).first
      end

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

        autorole = get_record(event.server.id)

        unless autorole
          Database::Autorole.create(server_id: event.server.id,
                                     server_name: BOT.server(event.server.id).name,
                                     author_id: event.user.id,
                                     author_name: event.user.name)
          autorole = get_record(event.server.id)
        end

        exist_role.each do |role|
          next if role.nil?
          if !autorole.roles.empty? || autorole.roles.find {|dbrole| dbrole.role_id == role.id}
            already_role << role
            next
          end
          autorole.add_role(role_id: role.id)
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

        autorole = get_record(event.server.id)
        if autorole.nil? || autorole.roles.empty?
          event.respond "Setting is Empty"
          break
        end
        exist_role = []
        roles.each do |role_data|
          role_data = get_role(role_data, event.server.id)
          exist_role << role_data if role_data
        end

        autorole.roles.each do |role|
          role.delete if exist_role.map(&:id).find(role.role_id)
        end

        "delete autorole role **#{roles.join(' ')}**"
      end

      command [:autorole,:ar] , description: 'toggle autorole Enable/Disable' do |event|
        first = get_record(event.server.id)
        if first.nil?
          Database::Autorole.create(server_id: event.server.id,
                                     server_name: BOT.server(event.server.id).name,
                                     author_id: event.user.id,
                                     author_name: event.user.name,
                                     enable_autorole: true)
          event.respond "Set **Enable** Autorole"
        else
          # 0 => true / 1 => false
          toggle = if first.enable_autorole.zero?
                     1
                   else
                     0
                   end
          Database::Autorole.where(server_id: event.server.id).all { |record| record.update(enable_autorole: toggle)}
          event.respond "Set **#{toggle.zero? ? "Enable":"Disable"}** Autorole"
        end
      end

      command [:chkautorole,:chkar] , description: 'check autorole role' do |event|
        autorole = get_record(event.server.id)
        if autorole.nil? || autorole.roles.empty?
          "Setting is Empty"
        else
          setted_role = []
          autorole.roles.each {|role| setted_role << get_role_id(role.role_id ,event.server.id)}
          "Setting Autorole `#{setted_role.map(&:name).join(' ')}`"
        end
      end
    end
  end
end