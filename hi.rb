require 'sinatra'
require 'oauth2'
require 'json'
require 'uri'
require 'net/http'

get "/" do
erb :textvite
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
	Net::HTTP.post_form(URI.parse('https://graph.facebook.com/' + "#{params[:eventId]}" + "/feed"), args)
end


#Send a POST request to Facebook's REST API event creater.
get '/eventCreate/:accessToken/:userId/:name/:startTime/:endTime/:location/:description' do
	args = {
		'access_token' =>  params[:accessToken] ,
		'name' =>  params[:name] ,
		'start_time' =>  params[:startTime] ,
		'end_time' =>  params[:endTime] ,
		'location' =>  params[:location] ,
		'description' =>  params[:description] ,
		'privacy' => 'SECRET'
	}
	Net::HTTP.post_form(URI.parse('https://graph.facebook.com/' +  "#{params[:userId]}"  + "/events"), args)
end