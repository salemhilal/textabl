require 'date'
require_relative 'eventsys'

# New Host
# Name, Email, Date, Cell, FB ID
user = Host.new('John Smith', 'test@test.com', Date.new(2011, 6,3), '555-555-5555')
user.password = 'testing'
#user.name = 'Test 123'
#user.email = 'test@test.com'
#user.cell = '555-555-5555'
#user.date_registered = Date.new(2011, 6, 3)
#user.save

# New Attendee
# Name, Email, Date, Cell, FB ID
user = Attendee.new('John Smith', 'test@test.com', Date.new(2011, 6, 3),'555-555-5555')
user.password = 'testing'
#user.name = 'Test 123'
#user.email = 'test@test.com'
#user.cell = '555-555-5555'
#user.date_registered = Date.new(2011, 6, 3)
#user.save

#Existing Host
repo = HostRepository.new
#host = repo.getByID(19)
host = repo.getByEmail('test@test.com')
puts host.name

#Existing Host
repo = AttendeeRepository.new
#attendee = repo.getByID(19)
attendee = repo.getByEmail('test@test.com')
puts attendee.name