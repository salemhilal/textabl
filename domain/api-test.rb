require 'date'
require_relative 'eventsys'

# New Host
# Name, Email, Date, Cell, FB ID
user = Host.new('John Smith', 'test@test.com', Date.new(2011, 6,3), '555-555-5555')
#user.save


# New Attendee
# Name, Email, Date, Cell, FB ID
user = Attendee.new('John Smith', 'test2@test.com', Date.new(2011, 6, 3),'555-555-5555')
#user.save

#Existing Host
repo = HostRepository.new
#host = repo.getByID(19)
host = repo.getByEmail('test@test.com')


#Existing Host
repo = AttendeeRepository.new
#attendee = repo.getByID(19)
attendee = repo.getByEmail('test@test.com')


#Create event
host = repo.getByEmail('test@test.com')
event = Event.new(host, 'Event Title', 'Event Description', DateTime.now)
event.save


#Register Attendee for Event
event = Event.new(host, 'Event Title', 'Event Description', DateTime.now)
event.save

repo = AttendeeRepository.new
attendee = repo.getByEmail('test@test.com')
attendee.addEvent(event)


#Create a Post
repo = AttendeeRepository.new
attendee = repo.getByEmail('test@test.com')
host.postMessage(event, "Testing")