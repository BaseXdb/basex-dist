(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions to access remote BaseX server instances from XQuery. With this module, you can on the one hand execute database commands and on the other hand evaluate queries, the results of which are returned as XDM sequences.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace client = "http://basex.org/modules/client";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : This function establishes a connection to a remote BaseX server, creates a new client session, and returns a session id. The parameter <code>$host</code> is the name of the database server, <code>$port</code> specifies the server port, and <code>$user</code> and <code>$password</code> represent the login data.
 :
 : @error bxerr:BXCL0001 an error occurs while creating the session (possible reasons: server not available, access denied).
 :)
declare function client:connect($host as xs:string, $port as xs:integer, $user as xs:string, $password as xs:string) as xs:anyURI external;

(:~
 : This function executes a <a href="http://docs.basex.org/wiki/Commands">command</a> and returns the result as string. The parameter <code>$id</code> contains the session id returned by <a href="http://docs.basex.org/wiki/Client_Module#client:connect">client:connect</a> . The <code>$command</code> argument represents a single command, which will be executed by the server.
 :
 : @error bxerr:BXCL0003 an I/O error occurs while transferring data from or to the server.
 : @error bxerr:BXCL0004 an error occurs while executing a command.
 :)
declare function client:execute($id as xs:anyURI, $command as xs:string) as xs:string external;

(:~
 : This function returns an information string, created by a previous call of <a href="#client:execute">client:execute</a> . <code>$id</code> specifies the session id.
 :)
declare function client:info($id as xs:anyURI) as xs:string external;

(:~
 : Evaluates a query and returns the result as sequence. The parameter <code>$id</code> contains the session id returned by <a href="http://docs.basex.org/wiki/Client_Module#client:connect">client:connect</a> , and <code>$query</code> represents the query string, which will be evaluated by the server.
 : Variables and the context item can be declared via <code>$bindings</code> . The specified keys must be QNames or strings, the values can be arbitrary items: <ul> <li> variables specified as QNames will be directly interpreted as variable name. </li> <li> variables specified as xs:string may be prefixed with a dollar sign. Namespace can be specified using the <a href="http://www.jclark.com/xml/xmlns.htm">Clark Notation</a>. If the specified string is empty, the value will be bound to the context item. </li> </ul> 
 :
 : @error bxerr:BXCL0003 an I/O error occurs while transferring data from or to the server.
 : @error bxerr:BXCL0005 an error occurs while evaluating a query, and if the original error cannot be extracted from the returned error string.
 :)
declare function client:query($id as xs:anyURI, $query as xs:string) as item()* external;

(:~
 : Evaluates a query and returns the result as sequence. The parameter <code>$id</code> contains the session id returned by <a href="http://docs.basex.org/wiki/Client_Module#client:connect">client:connect</a> , and <code>$query</code> represents the query string, which will be evaluated by the server.
 : Variables and the context item can be declared via <code>$bindings</code> . The specified keys must be QNames or strings, the values can be arbitrary items: <ul> <li> variables specified as QNames will be directly interpreted as variable name. </li> <li> variables specified as xs:string may be prefixed with a dollar sign. Namespace can be specified using the <a href="http://www.jclark.com/xml/xmlns.htm">Clark Notation</a>. If the specified string is empty, the value will be bound to the context item. </li> </ul> 
 :
 : @error bxerr:BXCL0003 an I/O error occurs while transferring data from or to the server.
 : @error bxerr:BXCL0005 an error occurs while evaluating a query, and if the original error cannot be extracted from the returned error string.
 :)
declare function client:query($id as xs:anyURI, $query as xs:string, $bindings as map(*)) as item()* external;

(:~
 : This function closes a client session. <code>$id</code> specifies the session id.
 : At the end of query execution, open sessions will be automatically closed.
 :
 : @error bxerr:BXCL0003 an I/O error occurs while transferring data from or to the server.
 :)
declare function client:close($id as xs:anyURI) as empty-sequence() external;



