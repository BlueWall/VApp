//
//
//  Copyright 2011 (C) BlueWall Information Technologies, LLC
//  All Rights Reserved
//
//  Apache License Version 2
//
//
list task;
integer cchan = -324516;
integer dchan = -334516;
integer nc_line;
string notecard;

// Set your uri here!
string vapp_svr = "http://my.app.server.net/vapp";
 
// Get task
integer get_task(key avatar) {
    
  integer x;  
    for ( x = llGetListLength(task); x >= 0 ; x--) { 
        string s = llList2String(task,x);
        if ( llSubStringIndex(s, avatar)) {
            return x;
        }
    }
    return -1;
}
// Process List
list make_dialog(key avatar, string direction) {

   list dialog;
   
   integer ndx = get_task(avatar);
   if ( ndx != -1) {
      string s = llList2String(task,ndx); 
      // Remove this task
      task = llDeleteSubList(task,ndx,ndx);
      // Make the string a list
      list dialogList = llCSV2List(s);

      // Get Length (number of buttons)
      integer nameCount = llGetListLength(dialogList);
      // Which set are we on now?
      integer set = llList2Integer(dialogList,1);
      // Separate out the names
      dialogList = llDeleteSubList(dialogList,0,1);
      // Index the set and extract 10
      /*
          Check all this math
             
          Need handling for first set (no Prev)
      */
      if ( direction == "Next" ) {
         integer current = (set + 1) * 10;
         integer max = nameCount / 10;
         integer left = nameCount - current;
               
         if (left <= 10) {
                   
             dialog = llList2List(dialogList, current, -1);
             dialog = llListInsertList(dialog,["Prev"],0);
             dialogList = llListInsertList(dialogList,[avatar],0);
                   
             if ( set < max ) {
                 set++;
             }
                   
             dialogList = llListInsertList(dialogList,[set],1);

             task += llList2CSV(dialogList);
                   
             } else if ( left > 10 ) {
                 set++;
                 dialog = llList2List(dialogList, current, current + 9);
                 dialog = llListInsertList(dialog,["Prev"],0);
                 dialog = llListInsertList(dialog,["Next"],2);
                 dialogList = llListInsertList(dialogList,[avatar],0);
                 dialogList = llListInsertList(dialogList,[set],1);
                 task += llList2CSV(dialogList);       
             }
               
      } else if ( direction == "Prev" ) {
                
      }
   }
    
   return dialog;
}

default
{
    state_entry()
    {
        llSay(0, "Script running");
        task = [];
        llListen(cchan,"","","");
        llListen(dchan,"","","");
    }
    
    touch_start(integer _det) {
        llSay(0,(string) _det);
        integer x;
        for (x = 0; x < _det; x++) {
            key user = llDetectedKey(x);
            llHTTPRequest(vapp_svr,
                [HTTP_METHOD,"POST",HTTP_MIMETYPE,
                "application/x-www-form-urlencoded"],
                "&application=teleport" +
                "&module=menu" +
                "&command=categories" +
                "&#user_id=" + (string) user);
        }
    }
    
    listen(integer _ch, string _name, key _id, string _msg) {
        
        if (_ch == cchan ) {
            
            llHTTPRequest(vapp_svr,
                [HTTP_METHOD,"POST",HTTP_MIMETYPE,
                "application/x-www-form-urlencoded"],
                "&application=teleport" +
                "&module=menu" +
                "&command=destinations" +
                "&category=" + _msg +
                "&#user_id=" + (string) _id);
               
        } else if (_ch == dchan) {
            // Handling for large lists here
            if (_msg == "Next") {
                
            } else if (_msg == "Prev" ) {
                
            } else {
                // This is the name of the destination
                // Send an http request to get the particulars
                // Use a tag of "teleport"
                llHTTPRequest(vapp_svr,
                    [HTTP_METHOD,"POST",HTTP_MIMETYPE,
                    "application/x-www-form-urlencoded"],
                    "&application=teleport" +
                    "&module=menu" +
                    "&command=teleport" +
                    "&destination=" + _msg +
                    "&#user_id=" + (string) _id);
            }
        }   
    }
    
    http_response(key _rkey, integer _stat, list _mdat, string _body) {
        if(llSubStringIndex(_body,"ERROR") == -1) {

            list response = llParseString2List(_body,[":"],[]);
            
            if ( llList2String(response, 0) == "category") {
                list params = llDeleteSubList(response, 2, -1);
                response = llDeleteSubList(response, 0,1);
                llDialog(llList2Key(params,1),"Select Category",response,cchan);
            } else if ( llList2String(response, 0) == "destination") {
                list params = llDeleteSubList(response, 2, -1);
                response = llDeleteSubList(response, 0,1);
                
                if ( llGetListLength(response) > 12 ) {
                    // Handling for large lists here
                    string dlist = llList2String(params,1) + "," +
                        "0," + 
                        llGetUnixTime() + "," +
                        llList2CSV(response);

                    task += dlist;      
                    
                } else {
                    llDialog(llList2Key(params,1),"Select Destination",response,dchan);
                }
                    
            } else if ( llList2String(response, 0) == "teleport" ) {
                //Wheeeeeeee! Format the response and call the TP
                /*
                    need to look for task here and remove
                */
                //llSay(0,_body);
                //llSay(0,(string) response);
                
                osTeleportAgent(llList2Key(response,1),llList2String(response,3),llList2Vector(response,4),llList2Vector(response,5));
                    
            } else if ( llList2String(response, 0) == "dbreset" ) {                        
                    nc_line = 0;
                    llGetNotecardLine(notecard,nc_line);
                   
            } else if ( llList2String(response, 0) == "program" ) {
                llSay(0,"Programming Response: " + _body);
                nc_line ++;
                llGetNotecardLine(notecard,nc_line);
            }
        }
    }
    
    changed(integer _ch) {
        
        if (( _ch & CHANGED_INVENTORY) == CHANGED_INVENTORY) {
            integer number;
            number = llGetInventoryNumber(INVENTORY_NOTECARD);
            if ( number > 0) {
                integer x;
                for (x = number -1; x  >= 0; x--) {
                    string inventory = llGetInventoryName(INVENTORY_NOTECARD,x);
                    llSay(0,"Getting NC " + inventory + (string) x);
                    if ( inventory == "Teleport Program" ) {
                        notecard = inventory;
                        llHTTPRequest(vapp_svr,
                            [HTTP_METHOD,"POST",HTTP_MIMETYPE,
                            "application/x-www-form-urlencoded"],
                            "&application=teleport" +
                            "&module=menu" +
                            "&command=clear");
                    }
                }
            }
        }
    }
        
    dataserver(key qid, string data) {

        if ( data != EOF ) {
            if(llGetSubString(data,0,0) != ";") {
                llSay(0,"Programming: " + data);
                list loc = llParseString2List(data,["|"],[]);
                string category = llList2String(loc,0);
                string name = llList2String(loc,1);
                string region = llList2String(loc,2);
                string target = llList2String(loc,3);
                string lookat = llList2String(loc,4);
                
                llHTTPRequest(vapp_svr,
                    [HTTP_METHOD,"POST",HTTP_MIMETYPE,
                    "application/x-www-form-urlencoded"],
                    "&application=teleport" +
                    "&module=menu" +
                    "&command=program" +
                    "&#category=" + category +
                    "&#name=" + name +
                    "&#region=" + region +
                    "&#target=" + target +
                    "&#lookat=" + lookat);
            } else {
                llSay(0,"Comment: " + data);
                nc_line++;
                llGetNotecardLine(notecard,nc_line);
            }

        } else {
            llRemoveInventory(notecard);
        }
    }
    
    timer() {
     
        integer now = llGetUnixTime();
        // Get expired tasks from the queue
          integer x;  
        for ( x = llGetListLength(task); x >= 0 ; x--) { 
            string s = llList2String(task,x);
            llCSV2List(s);
        }
    }
}
