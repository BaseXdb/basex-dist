(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions for performing operations that are restricted to users with <a href="http://docs.basex.org/wiki/User_Management">Admin Permissions</a> . Existing users can be listed, and soon more.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace admin = "http://basex.org/modules/admin";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns an element sequence, containing all registered users along with their access permissions.
 : If a database <code>$db</code> is specified, users registered for a particular database will be returned.
 : The output of this function is similar to the <a href="http://docs.basex.org/wiki/Commands#SHOW_USERS">SHOW USERS</a> command.
 :)
declare function admin:users() as element(user)* external;

(:~
 : Returns an element sequence, containing all registered users along with their access permissions.
 : If a database <code>$db</code> is specified, users registered for a particular database will be returned.
 : The output of this function is similar to the <a href="http://docs.basex.org/wiki/Commands#SHOW_USERS">SHOW USERS</a> command.
 :)
declare function admin:users($db as xs:string) as element(user)* external;

(:~
 : Returns an element sequence with all currently opened sessions, including the user name, address (IP:port) and an optionally opened database.
 : The output of this function is similar to the <a href="http://docs.basex.org/wiki/Commands#SHOW_SESSIONS">SHOW SESSIONS</a> command.
 :)
declare function admin:sessions() as element(session)* external;

(:~
 : Returns <a href="http://docs.basex.org/wiki/Logging">Logging</a> data compiled by the database or HTTP server.
 : If no argument is specified, a list of all log files will be returned, including the file size and date.
 : If a <code>$date</code> is specified, the contents of a single log file will be returned. An empty sequence will be returned if no logging data exists for the specified date.
 :)
declare function admin:logs() as element(file)* external;

(:~
 : Returns <a href="http://docs.basex.org/wiki/Logging">Logging</a> data compiled by the database or HTTP server.
 : If no argument is specified, a list of all log files will be returned, including the file size and date.
 : If a <code>$date</code> is specified, the contents of a single log file will be returned. An empty sequence will be returned if no logging data exists for the specified date.
 :)
declare function admin:logs($date as xs:string) as element(entry)* external;



