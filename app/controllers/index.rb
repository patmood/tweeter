get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id]) 
  end
  erb :index
end

post '/tweet' do
  @user = User.find(session[:user_id])
  @userclient = @user.twitter_client
  # @userclient.update(params[:tweet]) # Submit Directly to Twitter
  job_id = @user.tweet(params[:tweet])

  content_type :json
  { job_id: job_id }.to_json
end

post '/tweet_list' do
  @user = User.find(session[:user_id])
  @userclient = @user.twitter_client
  @timeline = @userclient.user_timeline()

  content_type :json
  { content: erb(:tweets, :layout => false) }.to_json
end

get '/signin' do
  session.clear
  rt = request_token
  session[:request_token] = rt
  p "====== REQUEST TOKEN (before twitter) =========="
  p rt  
  redirect rt.authorize_url
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/oauth/callback' do
  rt = session[:request_token]
  p "====== REQUEST TOKEN (after twitter) =========="
  p rt
  @access_token = rt.get_access_token(:oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
  handle = @access_token.params[:screen_name]

  p "========= HANDLE =============="
  p handle

  user = User.find_or_initialize_by(handle: handle)
  user.update_attributes(:token => @access_token.token, :secret => @access_token.secret)
  session[:request_token] = nil
  session[:user_id] = user.id
  redirect '/'
end

get '/status/:job_id' do
  p job_is_complete(params[:job_id])
  job_is_complete(params[:job_id])

  content_type :json
  { done: job_is_complete(params[:job_id]) }.to_json
  # if job_is_complete(params[:job_id])
  #   @message = "Complete"
  # else 
  #   @message = "Still Waiting"
  # end
  # p @message
  #   erb :status, :layout => false

end

