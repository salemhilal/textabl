require 'sinatra'
require 'twilio-ruby'
require 'json'
require 'dm-core'
require 'dm-migrations'
require 'dm-aggregates'
require 'dm-constraints'

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

	# seed spent messages (hack due to twilio limitations)
	#TextMessages.create(:sms_id => 'SMa88581010cae4364902855a27f4e0e9d')
	#TextMessages.create(:sms_id => 'SM88865edda98e4f7fbf1c7bfbfd28b6c3')
	#TextMessages.create(:sms_id => 'SM030bdd38127b4f61af28c7a13f5fc070')
	#TextMessages.create(:sms_id => 'SM36525a7bd81b4ea48bcddeef11dc7a95')
	#TextMessages.create(:sms_id => 'SMf982eb02a7fb48559d2dda5435fa733f')
	#TextMessages.create(:sms_id => 'SM0daccfe316e4476ab1bb51ff30894a4f')
	#TextMessages.create(:sms_id => 'SM0c00cace97f04834bc18d613ef993cb5')
end

helpers do
	require settings.root + '/helper'
end

get '/' do
	erb :index
end
