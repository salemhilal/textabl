require 'sinatra'
require 'oauth2'
require 'json'
require 'uri'
require 'net/http'

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
	params = {
		'access_token' => :accessToken,
		'message' => :message
	}
	Net::HTTP.post_form(URI.parse('http://graph.facebook.com/' + :eventId + "/feed"), params)
end

#Send a POST request to Facebook's REST API event creater.
get '/eventCreate/:accessToken/:userId/:name/:startTime/:endTime/:location/:description' do
	params = {
		'access_token' => :user,
		'name' => :name,
		'start_time' => :startTime,
		'end_time' => :endTime,
		'location' => :location,
		'description' => :description,
		'privacy' => 'SECRET'
	}
	Net::HTTP.post_form(URI.parse('http://graph.facebook.com/' + :userId + "/events"), params)
end