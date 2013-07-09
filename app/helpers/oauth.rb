def request_token
  @callback_url = "http://127.0.0.1:9393/oauth/callback"
  @consumer = OAuth::Consumer.new(ENV['TWITTER_CONSUMER_KEY'],ENV['TWITTER_CONSUMER_SECRET'], :site => "https://api.twitter.com")
  @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
end

