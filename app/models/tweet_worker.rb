class TweetWorker
include Sidekiq::Worker

  def perform(tweet_id)
    sleep 3
    tweet = Tweet.find(tweet_id)
    user  = tweet.user
    client = user.twitter_client # set up Twitter OAuth client here
    client.update(tweet.message) # actually make API call
  end
end
