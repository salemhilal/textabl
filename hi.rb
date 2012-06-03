require 'sinatra'
require 'oauth2'
require 'json'
#class App < Sinatra::Base
  helpers do
  	  def redirect_uri
	    uri = URI.parse(request.url)
	    uri.path = '/auth/facebook/callback'
	    uri.query = nil
	    uri.to_s
	  end
	  def client
	    if !@client
	      OAuth2::Response.register_parser(:facebook, 'text/plain') do |body|
	        token_key, token_value, expiration_key, expiration_value = body.split(/[=&]/)
	        {token_key => token_value, expiration_key => expiration_value, :mode => :query, :param_name => 'access_token'}
	      end
	      @client = OAuth2::Client.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], {:site => 'https://graph.facebook.com', :token_url => '/oauth/access_token'})
	    end
	    @client
	  end
  end


  before do
    @data = JSON.parse(request.env["rack.input"].read) if request.request_method =~ /POST|PUT|DELETE/i
    @data = params if request.request_method == 'GET'
  end

  before do
    pass if (request.path_info == '/auth/facebook' || request.path_info == '/auth/facebook/callback')
    redirect to('/auth/facebook') unless self.logged_in
  end

  get "/" do
    request.request_method
  end

  get "test" do
  	"inside the class"
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


