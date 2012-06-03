require 'sinatra'

get '/' do
	erb :index
end

get '/landing' do
	"You've landed!"
end

get '/hi' do
	"Hello World!"
end

