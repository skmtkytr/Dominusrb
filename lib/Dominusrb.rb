# Gems
require 'bundler/setup'
require 'discordrb'
require 'yaml'
require 'json'
require 'rufus-scheduler'
require 'dotenv'
require 'sequel'

# main bot module
module Dominusrb

  # load non-Discordrb modules
  Dir['lib/modules/*.rb'].each { |mod| load mod }

  # load .env
  Dotenv.load

  def get_role(role,server_id)
    server = BOT.server server_id
    server.roles.find {|server_role| server_role.name == role}
  end

  def get_role_id(role_id,server_id)
    server = BOT.server server_id
    server.roles.find {|server_role| server_role.id == role_id}
  end

  def get_record(server_id)
    Database::Server.where(server_id: server_id).first
  end

  # create the bot.
  BOT = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_BOT_TOKEN'], client_id: ENV['DISCORD_BOT_CLIENT_ID'], prefix: 'd!'

  RATE_LIMITTER = Discordrb::Commands::SimpleRateLimiter.new
  RATE_LIMITTER.bucket :example, delay: 5 # 5 seconds between each execution

  # Discord messages
  module DiscordMessages; end
  Dir['lib/modules/messages/*.rb'].each { |mod| load mod }
  DiscordMessages.constants.each do |mod|
    BOT.include! DiscordMessages.const_get mod
  end

  # Discord commands
  module DiscordCommands; end
  Dir['lib/modules/commands/*.rb'].each { |mod| load mod }
  DiscordCommands.constants.each do |mod|
    BOT.include! DiscordCommands.const_get mod
  end

  # Discord events
  module DiscordEvents; end
  Dir['lib/modules/events/*.rb'].each { |mod| load mod }
  DiscordEvents.constants.each do |mod|
    BOT.include! DiscordEvents.const_get mod
  end

  # run bot
  BOT.run

end

