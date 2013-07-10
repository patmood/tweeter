class User < ActiveRecord::Base
  has_many :tweets

  def tweet(message)
    tweet = tweets.create!(:message => message)
    job_id = TweetWorker.perform_async(tweet.id)
    job_id
  end

  def twitter_client
    @twitter_client ||= Twitter::Client.new(:oauth_token => self.token, 
                                            :oauth_token_secret => self.secret)
  end

end
