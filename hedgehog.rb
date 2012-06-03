require 'sinatra'
require 'httparty'
require 'twilio-ruby'
require 'json'

# groupme vars
@@access_token = ''
@@user_id      = ''

# twilio vars
@@account_sid  = 'ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
@@auth_token   = 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
@@twilio_phone = '1234567890'
@@sent_msgs    = []
@@event_members = {} 

helpers do
	def twilio_auth!
		Twilio::REST::Client.new account_sid, auth_token
	end
	def twilio_send_text_message!(client,phone_num,msg)
		client.account.sms.messages.create(
  			:from => @@twilio_phone,
  			:to => phone_num,
  			:body => msg)
	end
	def twilio_broadcast_queue(client)
		client.account.sms.messages.each do |sms|
  			if not @@sent_msgs.include?(sms.sid)
				# spam it to others
				@@event_members.reject{|name,info| info['phone_num'] == sms.from}.each do |name,info|
					client.account.sms.message.create(
						:from => @@twilio_phone,
						:to => info['phone_num'],
						:body => sms.body)
				end
			end
		end
	end

	class Member
		attr_accessor :name
		attr_accessor :phone_num
		def initialize(name,phone_num)
			@name = name
			@phone_num = phone_num
		end
	end
        class GroupRequest
		attr_accessor :topic
		attr_accessor :memberships
		def initialize(topic,a)
			@topic = topic
			@memberships = []
			a.each do |m|
				@memberships << Member.new(m[:name],m[:phone_num])
			end
		end
	end
	def groupme_auth!
		options = {:client_id     => 'idgoeshere',
			   :client_secret => 'secretgoeshere',
			   :device_id     => 'babygoeshere',
			   :phone_number  => 'callme',
			   :grant_type	  => 'client_credentials'}
		response = HTTParty.post("https://api.groupme.com/clients/tokens",options)
		puts response
		if response.code == 404
			return false
		else
			@@access_token = response['access_token']
			@@user_id      = response['user_id']
			return true	
		end
	end

	def groupme_create_group(name,members)
		options = {:client_id     => 'idgoeshere',
			   :client_secret => 'secretgoeshere',
			   :token         => @@access_token}
		group_request = GroupRequest.new(name,members)
		HTTParty.post("https://api.groupme.com/clients/groups",:options => options, :body => group_request.to_json)
	end
end

get '/' do
	erb :index
end

get '/landing' do
	"You've landed!"
end

get '/hi' do
	"Hello World!"
end

get '/groupme_auth' do
	groupme_auth!().to_s
end

get '/groupme_create_group' do
	groupme_create_group('test',[{:name => 'Chris', :phone_num => '(123) 456-7899'}]).to_s
end
