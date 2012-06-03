require 'sinatra'
require_relative 'eventsys'

set :port, 8080

get '/user' do
	if params[:action] = 'create'
		puts 'creating user'
	end
end
