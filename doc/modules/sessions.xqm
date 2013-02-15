(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> can only be called from users with <i>Admin</i> permissions. It contains functions for accessing and modifying all registered server-side sessions. This module is mainly useful in the context of <a href="http://docs.basex.org/wiki/Web_Application">Web Applications</a> .
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace sessions = "http://basex.org/modules/sessions";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns the IDs of all registered sessions.
 :)
declare function sessions:ids() as xs:string external;

(:~
 : Returns the creation time of the session specified by <code>$id</code> .
 :)
declare function sessions:created($id as xs:string) as xs:dateTime external;

(:~
 : Returns the last access time of the session specified by <code>$id</code> .
 :)
declare function sessions:accessed($id as xs:string) as xs:dateTime external;

(:~
 : Returns the names of all variables bound to the session specified by <code>$id</code> .
 :)
declare function sessions:names($id as xs:string) as xs:string* external;

(:~
 : Returns the value of a variable bound to the session specified by <code>$id</code> . If the variable does not exist, an empty sequence or the optionally specified default value is returned instead.
 :
 : @error bxerr:BXSE0002 the value of a session variable could not be retrieved.
 :)
declare function sessions:get($id as xs:string, $key as xs:string) as xs:string? external;

(:~
 : Returns the value of a variable bound to the session specified by <code>$id</code> . If the variable does not exist, an empty sequence or the optionally specified default value is returned instead.
 :
 : @error bxerr:BXSE0002 the value of a session variable could not be retrieved.
 :)
declare function sessions:get($id as xs:string, $key as xs:string, $default as xs:string) as xs:string external;

(:~
 : Assigns a value to a variable bound to the session specified by <code>$id</code> .
 :
 : @error bxerr:BXSE0001 a function item was specified as value of a session variable.
 :)
declare function sessions:set($id as xs:string, $key as xs:string, $value as xs:string) as empty-sequence() external;

(:~
 : Deletes a variable bound to the session specified by <code>$id</code> .
 :)
declare function sessions:delete($id as xs:string, $key as xs:string) as empty-sequence() external;

(:~
 : Unregisters the session specified by <code>$id</code> .
 :)
declare function sessions:close($id as xs:string) as empty-sequence() external;



