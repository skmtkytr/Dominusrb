require 'twitter'

module Dominusrb
  module TwitSearch
    class SearchScheduler
      attr_accessor :client , :twitsearch

      def initialize(rotation='10m')
        @rotation = rotation
        @scheduler = Rufus::Scheduler.new

        ## init twitter client
        Dotenv.load
        @client = Twitter::REST::Client.new(
            consumer_key: ENV['TWITTER_API_CONSUMER_KEY'],
            consumer_secret:   ENV['TWITTER_API_CONSUMER_SECRET'],
            access_token:        ENV['TWITTER_API_ACCESS_TOKEN'],
            access_token_secret: ENV['TWITTER_API_ACCESS_TOKEN_SECRET']
        )
      end

      def self.twitsearch(client)

        {} 
        -> do
          servers = Database::Server.all

          servers.each do |server|
            twittersearches = Database::Twittersearch.where(enable_twittersearch: 0,channel_id: BOT.server(server.server_id).channels.map(&:id)).all

            twittersearches.each do |twittersearch|
              channel = BOT.server(server.server_id).channels.find {|c| c.id == twittersearch.channel_id}

              break unless channel

              result_tweets = client.search(twittersearch.keyword, count: 5, result_type: "recent", exclude: "retweets", since_id: twittersearch.since_id)

              result_tweets.take(5).reverse!.each do |tw|

                # 厳密にはここまででbotのchannel発言権限の確認が必要だけどほっておく
                # ここで例外が上がってしまうとsince_idが更新されないけどその時直す
                channel&.send_message tw.uri

                sleep 5
              end
              
              ## update since_id
              if twittersearch.since_id.nil?
                twittersearch.update(since_id: result_tweets.to_a.first.id) 
              else
                twittersearch.update(since_id: result_tweets.to_a.first.id) if twittersearch.since_id < result_tweets.to_a.first.id unless result_tweets.to_a.first.nil?
                

              end

            end
          end
        end
      end

      def callback(&block)
        raise ArgumentError, "block not given" unless block_given? # 正しくblockが渡されない場合、エラーを投げる
        @callback = block
      end

      def start
        @scheduler.every @rotation do
          @callback.call
        end
      end

      def stop
        @scheduler.stop
      end
    end

    scheduler = SearchScheduler.new

    twitsearcher = SearchScheduler.twitsearch(scheduler.client)

    scheduler.callback do
      twitsearcher.call
    end
    scheduler.start
  end
end
