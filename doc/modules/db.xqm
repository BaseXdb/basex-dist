(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions for processing databases from within XQuery. Existing databases can be opened and listed, its contents can be directly accessed, documents can be added to and removed, etc.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace db = "http://basex.org/modules/db";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns meta information on the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> .
 :)
declare function db:info($db as item()) as element(database) external;

(:~
 : Returns a string sequence with the names of all databases.
 : If a <a href="#Database_Nodes">database node</a>  <code>$db</code> is specified, all documents and raw files of the specified database are returned.
 : The list of resources can be further restricted by the <code>$path</code> argument.
 :)
declare function db:list() as xs:string* external;

(:~
 : Returns a string sequence with the names of all databases.
 : If a <a href="#Database_Nodes">database node</a>  <code>$db</code> is specified, all documents and raw files of the specified database are returned.
 : The list of resources can be further restricted by the <code>$path</code> argument.
 :)
declare function db:list($db as item()) as xs:string* external;

(:~
 : Returns a string sequence with the names of all databases.
 : If a <a href="#Database_Nodes">database node</a>  <code>$db</code> is specified, all documents and raw files of the specified database are returned.
 : The list of resources can be further restricted by the <code>$path</code> argument.
 :)
declare function db:list($db as item(), $path as xs:string) as xs:string* external;

(:~
 : Returns an element sequence with the names of all databases together with their database path, the number of stored resources and the date of modification.
 : If a <a href="#Database_Nodes">database node</a>  <code>$db</code> is specified, all documents and raw files of the specified database together with their content-type, the modification date and the resource type are returned.
 : The list of resources can be further restricted by the <code>$path</code> argument.
 :)
declare function db:list-details() as element(database)* external;

(:~
 : Returns an element sequence with the names of all databases together with their database path, the number of stored resources and the date of modification.
 : If a <a href="#Database_Nodes">database node</a>  <code>$db</code> is specified, all documents and raw files of the specified database together with their content-type, the modification date and the resource type are returned.
 : The list of resources can be further restricted by the <code>$path</code> argument.
 :)
declare function db:list-details($db as item()) as element(resource)* external;

(:~
 : Returns an element sequence with the names of all databases together with their database path, the number of stored resources and the date of modification.
 : If a <a href="#Database_Nodes">database node</a>  <code>$db</code> is specified, all documents and raw files of the specified database together with their content-type, the modification date and the resource type are returned.
 : The list of resources can be further restricted by the <code>$path</code> argument.
 :)
declare function db:list-details($db as item(), $path as xs:string) as element(resource)* external;

(:~
 : Returns a sequence with all document nodes contained in the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> .
 : The document nodes to be returned can be restricted by the <code>$path</code> argument.
 :)
declare function db:open($db as item()) as document-node()* external;

(:~
 : Returns a sequence with all document nodes contained in the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> .
 : The document nodes to be returned can be restricted by the <code>$path</code> argument.
 :)
declare function db:open($db as item(), $path as xs:string) as document-node()* external;

(:~
 : Opens the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and returns the node with the specified <code>$id</code> value.
 : Each database node has a persistent <i>id</i> , which remains valid after update operations. If no updates are performed, the <i>pre</i> value can be requested, which provides access to database nodes in constant time.
 :
 : @error bxerr:BXDB0009 the specified id value does not exist in the database.
 :)
declare function db:open-id($db as item(), $id as xs:integer) as node() external;

(:~
 : Opens the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and returns the node with the specified <code>$pre</code> value.
 : The <i>pre</i> value provides access to a database node in constant time, but it is <i>transient</i> , i.e., it may change when database updates are performed.
 :
 : @error bxerr:BXDB0009 the specified pre value does not exist in the database.
 :)
declare function db:open-pre($db as item(), $pre as xs:integer) as node() external;

(:~
 : Returns information on the database system, such as the database path and current database settings.
 :)
declare function db:system() as element(system) external;

(:~
 : Returns an element sequence containing all available database backups.
 : If a <a href="#Database_Nodes">database node</a>  <code>$db</code> is specified, the sequence will be restricted to the backups matching this database.
 :)
declare function db:backups() as element(backup)* external;

(:~
 : Returns an element sequence containing all available database backups.
 : If a <a href="#Database_Nodes">database node</a>  <code>$db</code> is specified, the sequence will be restricted to the backups matching this database.
 :)
declare function db:backups($db as item()) as element(backup)* external;

(:~
 : Returns all attribute nodes of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> that have <code>$string</code> as string value. If available, the value index is used to speed up evaluation.
 : If <code>$attname</code> is specified, the resulting attribute nodes are filtered by their attribute name.
 :)
declare function db:attribute($db as item(), $string as item()) as attribute()* external;

(:~
 : Returns all attribute nodes of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> that have <code>$string</code> as string value. If available, the value index is used to speed up evaluation.
 : If <code>$attname</code> is specified, the resulting attribute nodes are filtered by their attribute name.
 :)
declare function db:attribute($db as item(), $string as item(), $attname as xs:string) as attribute()* external;

(:~
 : Returns all attributes of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> , the string values of which are larger than or equal to <code>$min</code> and smaller than or equal to <code>$max</code> . If available, the value index is used to speed up evaluation.
 :)
declare function db:attribute-range($db as item(), $min as xs:string, $max as xs:string) as attribute()* external;

(:~
 : Returns all attributes of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> , the string values of which are larger than or equal to <code>$min</code> and smaller than or equal to <code>$max</code> . If available, the value index is used to speed up evaluation.
 :)
declare function db:attribute-range($db as item(), $min as xs:string, $max as xs:string, $attname as xs:string) as attribute()* external;

(:~
 : Returns all text nodes from the full-text index of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> that contain the text specified as <code>$terms</code> .
 : The options used for building the full-text will also be applied to the search terms. As an example, if the index terms have been stemmed, the search string will be stemmed as well.
 :
 : @error bxerr:BXDB0004 the full-text index is not available.
 :)
declare function db:fulltext($db as item(), $terms as xs:string) as text()* external;

(:~
 : Returns the <i>id</i> values of the nodes supplied by <code>$nodes</code> , which must all be <a href="#Database_Nodes">database nodes</a> .
 : Each database node has a persistent <i>id</i> , which remains valid after update operations. If so far no updates have been performed, the <i>pre</i> value is equal to the <i>id</i> value and can be requested instead, which provides access to database nodes in constant time.
 :
 : @error bxerr:BXDB0001 :
 : @error bxerr: contains a node which is not a
 :)
declare function db:node-id($nodes as node()*) as xs:integer* external;

(:~
 : Returns the <i>pre</i> values of the nodes supplied by <code>$nodes</code> , which must all be <a href="#Database_Nodes">database nodes</a> .
 : The <i>pre</i> value provides access to a database node in constant time, but it is <i>transient</i> , i.e., it may change when database updates are performed.
 :
 : @error bxerr:BXDB0001 :
 : @error bxerr: contains a node which is not a
 :)
declare function db:node-pre($nodes as node()*) as xs:integer* external;

(:~
 : Returns a binary database resource addressed by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and <code>$path</code> as streamable <code>xs:base64Binary</code> .
 :
 : @error bxerr:BXDB0003 the database is not
 : @error bxerr:FODC0002 the addressed resource cannot be retrieved.
 : @error bxerr:FODC0007 the specified path is invalid.
 :)
declare function db:retrieve($db as item(), $path as xs:string) as xs:base64Binary external;

(:~
 : Returns all text nodes of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> that have <code>$string</code> as their string value. If available, the value index is used to speed up evaluation.
 :)
declare function db:text($db as item(), $string as item()) as text()* external;

(:~
 : Returns all text nodes of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> that are located in between the <code>$min</code> and <code>$max</code> strings. If available, the value index is used to speed up evaluation.
 :)
declare function db:text-range($db as item(), $min as xs:string, $max as xs:string) as text()* external;

(:~
 : Creates a new database with name <code>$db</code> and adds initial documents specified via <code>$inputs</code> to the specified <code>$paths</code> .
 : <code>$inputs</code> may be strings or nodes different than attributes. If the <code>$input</code> source is not a file or a folder, the <code>$paths</code> argument is mandatory.
 : Please note that <code>db:create</code> will be placed last on the <a href="http://docs.basex.org/wiki/XQuery_Update#Pending_Update_List">Pending Update List</a> . As a consequence, a newly created database cannot be addressed in the same query.
 :
 : @error bxerr:FODC0002 :
 : @error bxerr: points to an unknown resource.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither string nor a document node.
 : @error bxerr:BXDB0007 :
 : @error bxerr: is opened by another process.
 : @error bxerr:BXDB0011 :
 : @error bxerr: is not a
 : @error bxerr:BXDB0012 two
 : @error bxerr: statements with the same database name were specified.
 : @error bxerr:BXDB0013 the number of specified inputs and paths differs.
 :)
declare function db:create($db as xs:string) as empty-sequence() external;

(:~
 : Creates a new database with name <code>$db</code> and adds initial documents specified via <code>$inputs</code> to the specified <code>$paths</code> .
 : <code>$inputs</code> may be strings or nodes different than attributes. If the <code>$input</code> source is not a file or a folder, the <code>$paths</code> argument is mandatory.
 : Please note that <code>db:create</code> will be placed last on the <a href="http://docs.basex.org/wiki/XQuery_Update#Pending_Update_List">Pending Update List</a> . As a consequence, a newly created database cannot be addressed in the same query.
 :
 : @error bxerr:FODC0002 :
 : @error bxerr: points to an unknown resource.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither string nor a document node.
 : @error bxerr:BXDB0007 :
 : @error bxerr: is opened by another process.
 : @error bxerr:BXDB0011 :
 : @error bxerr: is not a
 : @error bxerr:BXDB0012 two
 : @error bxerr: statements with the same database name were specified.
 : @error bxerr:BXDB0013 the number of specified inputs and paths differs.
 :)
declare function db:create($db as xs:string, $inputs as item()*) as empty-sequence() external;

(:~
 : Creates a new database with name <code>$db</code> and adds initial documents specified via <code>$inputs</code> to the specified <code>$paths</code> .
 : <code>$inputs</code> may be strings or nodes different than attributes. If the <code>$input</code> source is not a file or a folder, the <code>$paths</code> argument is mandatory.
 : Please note that <code>db:create</code> will be placed last on the <a href="http://docs.basex.org/wiki/XQuery_Update#Pending_Update_List">Pending Update List</a> . As a consequence, a newly created database cannot be addressed in the same query.
 :
 : @error bxerr:FODC0002 :
 : @error bxerr: points to an unknown resource.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither string nor a document node.
 : @error bxerr:BXDB0007 :
 : @error bxerr: is opened by another process.
 : @error bxerr:BXDB0011 :
 : @error bxerr: is not a
 : @error bxerr:BXDB0012 two
 : @error bxerr: statements with the same database name were specified.
 : @error bxerr:BXDB0013 the number of specified inputs and paths differs.
 :)
declare function db:create($db as xs:string, $inputs as item()*, $paths as xs:string*) as empty-sequence() external;

(:~
 : Drops the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and all connected resources.
 :
 : @error bxerr:BXDB0007 :
 : @error bxerr: is opened by another process.
 :)
declare function db:drop($db as item()) as empty-sequence() external;

(:~
 : Adds documents specified by <code>$input</code> to the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and the specified <code>$path</code> .
 : <code>$input</code> may be a string or a node different than attribute. If the <code>$input</code> source is not a file or a folder, <code>$path</code> must be specified.
 :
 : @error bxerr:FODC0002 :
 : @error bxerr: points to an unknown resource.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither string nor a document node.
 :)
declare function db:add($db as item(), $input as item()) as empty-sequence() external;

(:~
 : Adds documents specified by <code>$input</code> to the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and the specified <code>$path</code> .
 : <code>$input</code> may be a string or a node different than attribute. If the <code>$input</code> source is not a file or a folder, <code>$path</code> must be specified.
 :
 : @error bxerr:FODC0002 :
 : @error bxerr: points to an unknown resource.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither string nor a document node.
 :)
declare function db:add($db as item(), $input as item(), $path as xs:string) as empty-sequence() external;

(:~
 : Deletes document(s), specified by <code>$path</code> , from the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> .
 :)
declare function db:delete($db as item(), $path as xs:string) as empty-sequence() external;

(:~
 : Optimizes the meta data and indexes of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> .
 : If <code>$all</code> is set to <code>true()</code> , the complete database will be rebuilt.
 :
 : @error bxerr:FOUP0002 an error occurred while optimizing the database.
 :)
declare function db:optimize($db as item()) as empty-sequence() external;

(:~
 : Optimizes the meta data and indexes of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> .
 : If <code>$all</code> is set to <code>true()</code> , the complete database will be rebuilt.
 :
 : @error bxerr:FOUP0002 an error occurred while optimizing the database.
 :)
declare function db:optimize($db as item(), $all as xs:boolean) as empty-sequence() external;

(:~
 : Renames document(s), specified by <code>$path</code> to <code>$newpath</code> in the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> .
 :
 : @error bxerr:BXDB0008 new document names would be empty.
 :)
declare function db:rename($db as item(), $path as xs:string, $newpath as xs:string) as empty-sequence() external;

(:~
 : Replaces a document, specified by <code>$path</code> , in the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> with the content of <code>$input</code> , or adds it as a new document.
 :
 : @error bxerr:BXDB0006 :
 : @error bxerr: is not a single document path.
 : @error bxerr:FODC0002 :
 : @error bxerr: is a string representing a path, which cannot be read.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither a string nor a document node.
 :)
declare function db:replace($db as item(), $path as xs:string, $input as item()) as empty-sequence() external;

(:~
 : Stores a binary resource specified by <code>$input</code> in the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and the location specified by <code>$path</code> .
 :
 : @error bxerr:BXDB0003 the database is not
 : @error bxerr:FODC0007 the specified path is invalid.
 : @error bxerr:FOUP0002 the resource cannot be stored at the specified location.
 :)
declare function db:store($db as item(), $path as xs:string, $input as item()) as empty-sequence() external;

(:~
 : This function can be used to both perform updates and return results in a single query. The argument of the function will be evaluated, and the resulting items will be cached and returned after the updates on the <i>pending update list</i> have been processed. As nodes may be updated, they will be copied before being cached.
 : The function can only be used together with <a href="http://docs.basex.org/wiki/XQuery_Update#Updating_Expressions">updating expressions</a> ; if the function is called within a transform expression, its results will be discarded.
 :)
declare function db:output($result as item()*) as empty-sequence() external;

(:~
 : Explicitly flushes the buffers of the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> . This command is only useful if <a href="http://docs.basex.org/wiki/Options#AUTOFLUSH">AUTOFLUSH</a> has been set to <code>false</code> .
 :)
declare function db:flush($db as item()) as empty-sequence() external;

(:~
 : Checks if the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> or the resource specified by <code>$path</code> exists. <code>false</code> is returned if a database directory has been addressed.
 :)
declare function db:exists($db as item()) as xs:boolean external;

(:~
 : Checks if the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> or the resource specified by <code>$path</code> exists. <code>false</code> is returned if a database directory has been addressed.
 :)
declare function db:exists($db as item(), $path as xs:string) as xs:boolean external;

(:~
 : Checks if the specified resource in the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and the path <code>$path</code> exists, and if it is a raw file.
 :)
declare function db:is-raw($db as item(), $path as xs:string) as xs:boolean external;

(:~
 : Checks if the specified resource in the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and the path <code>$path</code> exists, and if it is an XML document.
 :)
declare function db:is-xml($db as item(), $path as xs:string) as xs:boolean external;

(:~
 : Retrieves the content type of a resource in the database specified by the <a href="#Database_Nodes">database node</a>  <code>$db</code> and the path <code>$path</code> .
 : The file extension is used to recognize the content-type of a resource stored in the database. Content-type <code>application/xml</code> will be returned for any XML document stored in the database, regardless of its file name extension.
 :
 : @error bxerr:FODC0002 the addressed resource is not found or cannot be retrieved.
 :)
declare function db:content-type($db as item(), $path as xs:string) as xs:string external;

(:~
 : Executes a <code>$query</code> and sends the resulting value to all clients watching the <a href="http://docs.basex.org/wiki/Events">Event</a> with the specified <code>$name</code> . The query may also perform updates; no event will be sent to the client that fired the event.
 :
 : @error bxerr:BXDB0010 the specified event is unknown.
 : @error bxerr:SEPM0016 serialization errors occurred while sending the value.
 :)
declare function db:event($name as xs:string, $query as item()) as empty-sequence() external;



