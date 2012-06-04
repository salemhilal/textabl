/***********************************
 *   Project Hedgehog JS library
 *         version 0.0.1
 *          Salem Hilal
 ***********************************/

//Attempts to post a passed message to the current user's status.
function postMessage(body){
  FB.api('/me/feed', 'post', { message: body }, function(response) {
    if (!response) {
      console.error('No response received. Check the browser connection.');
    } 
    else if(response.error){
      console.error('Error occured:');
      console.error(response.error);
    }
    else {
      console.log('Post ID: ' + response.id);
    }
  });
}

//Attempts to create an event with a given name and start/end time.
function createEvent(ename, estart, eend, resp){
  console.log("Spinning up a new Facebook event...")
  FB.api('/me/events', 'post', { name : ename, start_time : estart, end_time : eend }, function(response) {
    if (!response) {
      console.error('No response received. Check the browser connection.');
    } 
    else if(response.error){
      console.error('Error occured:');
      console.error(response.error);
    }
    else {
      console.log('Post ID: ' + response.id);
      inviteUsers(response.id, resp);
    }
  });
}

//Invites the given list of users to the given event.
function inviteUsers(eventId, invites){
  getCellNumbers(invites);
  console.log("Inviting selected users to the new event.");
  FB.api('/'+eventId+'/invited/', 'post', {users : invites}, function(response){
    console.log("I think I just invited some people. Here, look: ");
    console.log(response);
  });
  generateCellNumbers(invites);
}

//Inserts a row in #friends-list-table for each uid needing a phone number.
function generateCellNumbers(invites){
  for(uid in invites){
    FB.api('/'+uid, function(response) {
      $('#friends-list-table').append(""+response.name + "<input type='text' class='." +uid+"'><br />");
    });  
  }
}

//Query the user for cell phone numbers for each invited facebook friend.
function getCellNumbers(invites, name, eventid, hostid, desc){
  var result = new Array();
  var count = 0;
  for(user in invites){
    var value $(user).val();
    result[count] = {name : user , cell : value};
    count++;
  }
  sendPOST(result, name, eventid, hostid, desc);
}

//Sends a POST request, along with the event's info, off to our database.t
function sendPOST(cells, name, eventid, hostid, desc){
  $.post('/create_event', 
    {   event_id : eventid, 
        title : name, 
        description : desc, 
        host_id : hostid, 
        attendees : cells
    });
}

//Returns a list of friends. 
function getFriendsList(){
  FB.api('/me/friends', function(response){
    console.log(response);
  });
}

//Prompt the user to select a list of friends to invite.
function sendRequestViaMultiFriendSelector() {
  FB.ui({method: 'apprequests',
    message: 'Hey you guys, check out this event.'
  }, requestCallback);
}

//Callback function for the sendRequest dialog.
function requestCallback(response) {
  console.log(response.to);
  var name = "Sicknasty Test Event Revival";
  var start = new Date();
  var end = new Date(); end.setDate(end.getDate() + 1); 
  var groupID = createEvent(name, start, end, response.to);
}