require 'twilio-ruby'
require './hedgehog'

module TwilioHelpers
	ACCOUNT_SID  = 'ACc1c98dc028b74b878a1e9a7d0d12c403'
	AUTH_TOKEN   = 'b7017ad9152b15a4fbcf234aacfde882'
	
	# sand box number
	TWILIO_PHONE = '+1 415-599-2671'

	# auth's w/ twilio and then sends a welcome message to all members
	def twilio_create_group(name,owner_name,members)
                client = twilio_auth!
                twilio_broadcast!(client,members,"Welcome to #{name} an event created by #{owner_name}")
        end

	# what do you think?	
        def twilio_auth!
                Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
        end

        # sends a single text message to the phone_num from sandbox twilio phone num
	def twilio_send_text_message!(client,phone_num,msg)
                begin
                sms = client.account.sms.messages.create(
                        :from => TWILIO_PHONE,
                        :to => phone_num,
                        :body => msg)
                rescue Exception => e
                        puts "Problems with twilio:\n#{e}"
                end
        end
	
	# broadcasts the msg to all tos
        def twilio_broadcast!(client,tos,msg)
                # spam it to others
                tos.each do |name,info|
                        twilio_send_text_message!(client,info[:phone],msg)
                end
        end

	# broadcasts all msgs associated w/ my twilio account unless the reciever has already got it
	# replace sent_msgs w/ db call to find what msgs are dirty
        def twilio_broadcast_queue!(client,members)
                client.account.sms.messages.list.each do |sms|
			# only look at messages that twilio has recieved
			if sms.direction == 'inbound'
                        	if TextMessages.count(:sms_id => sms.sid) == 0
                                	# spam it to others
                                	members.each do |name,info|
                                        	if info[:phone] != sms.from
                                                	twilio_send_text_message!(client,info[:phone],sms.body)
                                        	end
                                	end
                              		TextMessages.create(:sms_id => sms.sid)
                       		end
			end
                end
        end
end
