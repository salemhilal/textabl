require 'sinatra'
require 'twilio-ruby'
require 'json'
require 'pry'

# twilio vars
@@sent_msgs    = []
@@event_members = {
	'Chris Cacciatore' => {:phone => '+19165954787'},
	'Salem Lastname'   => {:phone => '+14125677589'}
}

helpers do
	require settings.root + '/helper'
	include TwilioHelpers
end

get '/' do
	erb :index
end

get '/twilio_create_group/:name/:owner_name' do |name,owner_name|
	twilio_create_group(name,owner_name,@@event_members)
end

