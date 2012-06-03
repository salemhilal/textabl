require './helper'
include TwilioHelpers

desc "Poll twilio for dirty messages"
task :poll_twilio do 
	puts 'this is where the baby goes'
	# need to hit db to find out event members
	twilio_broadcast_queue!(twilio_auth!,event_members = {'Chris' => {:phone => '+19165954787'},'Salem' => {:phone => '+14125677589'},'John' => {:phone => '+19167088467'})
end

desc "Clean all sms messages on twilio"
task :clean_msgs do
	client = twilio_auth!
	client.account.sms.messages.list.each do |sms|
		# hit db and save the sms.sid so we don't broadcast it anymore
	end
end
