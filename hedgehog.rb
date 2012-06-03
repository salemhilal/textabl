require 'sinatra'
require 'twilio-ruby'
require 'json'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == ['fullhouse', 'tanners']
end

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
