require 'sinatra'
require 'twilio-ruby'
require 'json'
require 'dm-core'
require 'dm-migrations'
require 'dm-aggregates'
require 'dm-constraints'
require 'uri'
require 'net/http'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == ['fullhouse', 'tanners']
end

# twilio vars
@@sent_msgs    = []
@@event_members = {
	'Chris Cacciatore' => {:phone => '+19165954787'},
	'Salem Lastname'   => {:phone => '+14125677589'}
}

configure do
	DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/db/test.db")
	class TextMessages
		include DataMapper::Resource
	
		property :id, Serial
		property :sms_id, String, :required => true, :length => 256,:key => true
	end
  	DataMapper.auto_upgrade!
end

helpers do
	require settings.root + '/helper'
end

# routes
get "/" do	
	erb :index2
end

get "/landing" do
        erb :landing
end

get "/channel" do
        "<script src='//connect.facebook.net/en_US/all.js'></script>"
end

#Send a POST request to Facebook's REST API event message poster.
get '/eventMessagePost/:accessToken/:eventId/:message' do
        args = {
                'access_token' =>  params[:accessToken] ,
                'message' =>  params[:message]
        }
        puts URI.parse("https://graph.facebook.com/#{params[:eventId]}/feed")
        Net::HTTP.post_form(URI.parse("https://graph.facebook.com/#{params[:eventId]}/feed"), args)
end
