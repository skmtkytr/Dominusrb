module Dominusrb
  module DiscordCommands
    module Info
      extend Discordrb::Commands::CommandContainer

      command :info , description: 'info' do |_event|
        list = []
        BOT.users.each {|user| list << user[1].mention}
        "#users: #{list.join{'  '}}"
      end
    end
  end
end