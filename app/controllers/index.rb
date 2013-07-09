get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id]) 
  end
  erb :index
end

post '/tweet' do
  @timeline = Twitter.user_timeline(params[:tweet])
  erb :tweets, :layout => false
end

get '/signin' do
  rt = request_token
  session[:request_token] = rt
  redirect rt.authorize_url
end

get '/logout' do
  session[:user_id] = nil
  session[:request_token] = nil
  redirect '/'
end

get '/oauth/callback' do
  rt = session[:request_token]
  @access_token = rt.get_access_token(:oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
  handle = @access_token.params[:screen_name]

  user = User.find_or_initialize_by(handle: handle)
  user.update_attributes(:token => @access_token.token, :secret => @access_token.secret)
  session[:request_token] = nil
  session[:user_id] = user.id
  redirect '/'
end
