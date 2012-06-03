require 'mysql'

class Db
	def initialize
		@host = 'ec2-50-18-228-16.us-west-1.compute.amazonaws.com'
		@user = 'dbuser'
		@pass = 'h3dg3h0g'
		@dbname = 'socialtext'
	end
	def getData(sql)
		con = Mysql.new(@host, @user, @pass, @dbname)
		rs = con.query(sql)
		con.close
		@getData = rs		
	end

	def executeSQL(sql)
		con = Mysql.new(@host, @user, @pass, @dbname)
		rs = con.query(sql)
		con.close
	end

	def getInsertID
		con = Mysql.new(@host, @user, @pass, @dbname)		
		rs = con.query("SELECT last_insert_id()")
		h = rs.fetch_hash
		@getInsertID = ['last_insert_id()']
		con.close
	end
end

class HostRepository
	def getByID(id)
		db = Db.new
		rs = db.getData("SELECT * FROM users WHERE id = #{id}")
		h = rs.fetch_hash
		user = Host.new(h['name'], h['email'], h['date_registered'], h['cell'], h['facebook_id'])
		user.id = h['id']
		@getByID = user
	end

	def getByEmail(email)
		db = Db.new
		rs = db.getData("SELECT * FROM users WHERE email = '#{email}' LIMIT 1")
		h = rs.fetch_hash
		user = Host.new(h['name'], h['email'], h['date_registered'], h['cell'], h['facebook_id'])
		user.id = h['id']
		@getByEmail = user
	end
end

class AttendeeRepository
	def getByID(id)
		db = Db.new
		rs = db.getData("SELECT * FROM users WHERE id = #{id}")
		h = rs.fetch_hash
		user = Attendee.new(h['name'], h['email'], h['date_registered'], h['cell'], h['facebook_id'])
		user.id = h['id']
		@getByID = user
	end

	def getByFacebookID(id)
		db = Db.new
		rs = db.getData("SELECT * FROM users WHERE facebook_id = #{id}")
		h = rs.fetch_hash
		user = Attendee.new(h['name'], h['email'], h['date_registered'], h['cell'], h['facebook_id'])
		user.id = h['id']
		@getByID = user
	end

	def getByEmail(email)
		db = Db.new
		rs = db.getData("SELECT * FROM users WHERE email = '#{email}' LIMIT 1")
		h = rs.fetch_hash
		user = Host.new(h['name'], h['email'], h['date_registered'], h['cell'], h['facebook_id'])
		user.id = h['id']
		@getByEmail = user
		
	end
end

class User
	attr_accessor :id, :name, :email, :cell, :date_registered, :facebook_id
	def initialize(name, email, date_registered, cell = nil, facebook_id = nil)
		#Instance variables
		@name = name
		@email = email
		@cell = cell
		@date_registered = date_registered
		@facebook_id = facebook_id
	end

	def postMessage(event, message)
		p = Post.new(self, event, message)
		p.save

	end

	def save

		db = Db.new
		if @id.nil?
			db.executeSQL("INSERT INTO users (id, name, email, cell, date_registered, facebook_id) VALUES(null, '#{@name}', '#{@email}', '#{cell}', '#{date_registered}', '#{facebook_id}')")
		else
			db.executeSQL("UPDATE users SET name = '#{@name}', email = '#{@email}', cell = '#{@cell}', date_registered = '#{@date_registered}', facebook_id = '#{@facebook_id}' WHERE id = #{@id}")
		end
		@id = db.getInsertID
	end

	#def name
	#	@name ||= []
	#end

end

class Host < User
	def createEvent(name, description, date)

	end

	def inviteUsers(attendees)

	end

	def inviteUser(attendee)

	end
end

class Attendee < User
	def acceptInvite
	
	end

	def declineInvite
	
	end

	#def initialize(event)
	#	@event = event
	#end
end

class Event
	attr_accessor :id
	def initialize(host, title, description, date)
		#if defined? host.id == false
			#raise "Invalid host"
		#end
		@host = host
		@title = title
		@description = description
		@date = date
	end

	def save
		db = Db.new
		db.executeSQL("INSERT INTO events (id, title, description, create_date, user_id) VALUES(null, '#{@title}', '#{@description}', '#{DateTime.now}', '#{@host.id}')")
		@id = db.getInsertID		
	end
end

class Post
	attr_accessor :message

	def initialize(user, event, message)
		if defined? user.id
			raise "Invalid user"
		end
		@user = user
		@event = event
		@message = message
	end

	def save
		db = Db.new
		db.executeSQL("INSERT INTO posts (id, creator_id, message, event_id) VALUES(null, '#{@user.id}', '#{@message}', '#{@event.id}')")
		@id = db.getInsertID		
	end
end