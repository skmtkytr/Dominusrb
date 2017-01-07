module Dominusrb

  module DiscordCommands
    module Fun
      extend Discordrb::Commands::CommandContainer

      command :owner , description: 'who is owner' do |event|
        ":wrench: #{event.server.owner.mention}"
      end

      command :dice ,description: 'Generates a random number between 0 to 100' do |_event|
        # responce < 100 integer
        rand(-100)
      end

      command :bold do |_event, *args|
        # Again, the return value of the block is sent to the channel
        "**#{args.join(' ')}**"
      end

      command :italic do |_event, *args|
        "*#{args.join(' ')}*"
      end

      command(:random, min_args: 0, max_args: 2, description: 'Generates a random number between 0 and 1, 0 and max or min and max.', usage: 'random [min/max] [max]') do |_event, min, max|
        # The `if` statement returns one of multiple different things based on the condition. Its return value
        # is then returned from the block and sent to the channel
        if max
          rand(min.to_i..max.to_i)
        elsif min
          rand(0..min.to_i)
        else
          rand
        end
      end
    end
  end
end