require 'sinatra'
require 'oauth2'
require 'json'
#class App < Sinatra::Base

  get "/" do
    erb :index
  end

  get "/test" do
  	"SHIT WORKS, SON."
  end



  get '/auth/facebook' do
    redirect client.auth_code.authorize_url(
      :redirect_uri => redirect_uri,
      :scope => 'email'
    )
  end

  get '/auth/facebook/callback' do
    token = client.auth_code.get_token(@data[:code], {:redirect_uri => redirect_uri, :parsed => :facebook})
    user = token.get('/me').parsed
    create_user user unless user_exists user
  end


