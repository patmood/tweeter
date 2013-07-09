get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/tweet' do
  @timeline = Twitter.user_timeline(params[:tweet])
  erb :tweets, :layout => false
end
