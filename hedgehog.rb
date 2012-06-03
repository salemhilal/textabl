require 'sinatra'
require 'twilio-ruby'
require 'json'

# twilio vars
@@account_sid  = 'ACc1c98dc028b74b878a1e9a7d0d12c403'
@@auth_token   = 'b7017ad9152b15a4fbcf234aacfde882'
@@twilio_phone = '+1 415-599-2671'
@@sent_msgs    = []
@@event_members = {
	'Chris Cacciatore' => {:phone => '+19165954787'},
	'Salem Lastname'   => {:phone => '+14125677589'}
} 

helpers do
	def twilio_auth!
		Twilio::REST::Client.new(@@account_sid, @@auth_token)
	end
	def twilio_send_text_message!(client,phone_num,msg)
		begin
		client.account.sms.messages.create(
  			:from => @@twilio_phone,
  			:to => phone_num,
  			:body => msg)
		rescue Exception => e
			puts "Problems with twilio:\n#{e}"
		end
	end
	def twilio_broadcast_queue(client)
		client.account.sms.messages.list.each do |sms|
  			if not @@sent_msgs.include?(sms.sid)
				# spam it to others
				@@event_members.each do |name,info|
					if info[:phone] != sms.from
						twilio_send_text_message!(client,info[:phone],sms.body)
					end
				end
				@@sent_msgs << sms.sid
			end
		end
	end
end

get '/' do
	erb :index
end

get '/twilio_auth' do
	@@twilio_client = twilio_auth!
end

get '/twilio_send_text' do
	twilio_send_text_message!(@@twilio_client,'+19165954787',"Rainbows!")
end

get '/twilio_broadcast' do
	twilio_broadcast_queue(@@twilio_client)
end

