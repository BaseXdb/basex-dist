(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions for processing databases from within XQuery. Existing databases can be opened and listed, its contents can be directly accessed, documents can be added to and removed, etc.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace db = "http://basex.org/modules/db";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns information on the database system, such as the database path and current database settings. The output is similar to the <a href="http://docs.basex.org/wiki/Commands#INFO">INFO</a> command.
 :)
declare function db:system() as element(system) external;

(:~
 : Returns meta information on the database <code>$db</code> . The output is similar to the <a href="http://docs.basex.org/wiki/Commands#INFO_DB">INFO DB</a> command.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:info($db as xs:string) as element(database) external;

(:~
 : Returns a string sequence with the names of all databases: <ul> <li> If a database <code>$db</code> is specified, all documents and raw files of the specified database are returned. </li> <li> The list of resources can be further restricted by the <code>$path</code> argument. </li> </ul> 
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:list() as xs:string* external;

(:~
 : Returns a string sequence with the names of all databases: <ul> <li> If a database <code>$db</code> is specified, all documents and raw files of the specified database are returned. </li> <li> The list of resources can be further restricted by the <code>$path</code> argument. </li> </ul> 
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:list($db as xs:string) as xs:string* external;

(:~
 : Returns a string sequence with the names of all databases: <ul> <li> If a database <code>$db</code> is specified, all documents and raw files of the specified database are returned. </li> <li> The list of resources can be further restricted by the <code>$path</code> argument. </li> </ul> 
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:list($db as xs:string, $path as xs:string) as xs:string* external;

(:~
 : Returns an element sequence with the names of all databases together with their database path, the number of stored resources and the date of modification: <ul> <li> If a database <code>$db</code> is specified, all documents and raw files of the specified database together with their content-type, the modification date and the resource type are returned. </li> <li> The list of resources can be further restricted by the <code>$path</code> argument. </li> </ul> 
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:list-details() as element(database)* external;

(:~
 : Returns an element sequence with the names of all databases together with their database path, the number of stored resources and the date of modification: <ul> <li> If a database <code>$db</code> is specified, all documents and raw files of the specified database together with their content-type, the modification date and the resource type are returned. </li> <li> The list of resources can be further restricted by the <code>$path</code> argument. </li> </ul> 
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:list-details($db as xs:string) as element(resource)* external;

(:~
 : Returns an element sequence with the names of all databases together with their database path, the number of stored resources and the date of modification: <ul> <li> If a database <code>$db</code> is specified, all documents and raw files of the specified database together with their content-type, the modification date and the resource type are returned. </li> <li> The list of resources can be further restricted by the <code>$path</code> argument. </li> </ul> 
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:list-details($db as xs:string, $path as xs:string) as element(resource)* external;

(:~
 : Returns an element sequence containing all available database backups.
 : If a database <code>$db</code> is specified, the sequence will be restricted to the backups matching this database.
 :)
declare function db:backups() as element(backup)* external;

(:~
 : Returns an element sequence containing all available database backups.
 : If a database <code>$db</code> is specified, the sequence will be restricted to the backups matching this database.
 :)
declare function db:backups($db as xs:string) as element(backup)* external;

(:~
 : Executes a <code>$query</code> and sends the resulting value to all clients watching the <a href="http://docs.basex.org/wiki/Events">Event</a> with the specified <code>$name</code> . The query may also perform updates; no event will be sent to the client that fired the event.
 :
 : @error bxerr:BXDB0010 the specified event is unknown.
 : @error bxerr:SEPM0016 serialization errors occurred while sending the value.
 :)
declare function db:event($name as xs:string, $query as item()) as empty-sequence() external;

(:~
 : Returns a sequence with all document nodes contained in the database <code>$db</code> .
 : The document nodes to be returned can be restricted by the <code>$path</code> argument.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:open($db as xs:string) as document-node()* external;

(:~
 : Returns a sequence with all document nodes contained in the database <code>$db</code> .
 : The document nodes to be returned can be restricted by the <code>$path</code> argument.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:open($db as xs:string, $path as xs:string) as document-node()* external;

(:~
 : Opens the database <code>$db</code> and returns the node with the specified <code>$pre</code> value.
 : The <a href="http://docs.basex.org/wiki/Node_Storage#PRE_Value">PRE value</a> provides very fast access to an existing database node, but it will change whenever a node with a smaller <i>pre</i> values is added to or deleted from a database.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0009 the specified pre value does not exist in the database.
 :)
declare function db:open-pre($db as xs:string, $pre as xs:integer) as node() external;

(:~
 : Opens the database <code>$db</code> and returns the node with the specified <code>$id</code> value.
 : Each database node has a <i>persistent</i>  <a href="http://docs.basex.org/wiki/Node_Storage#ID_Value">ID value</a> . Access to the node id can be sped up by turning on the <a href="http://docs.basex.org/wiki/Options#UPDINDEX">UPDINDEX</a> option.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0009 the specified id value does not exist in the database.
 :)
declare function db:open-id($db as xs:string, $id as xs:integer) as node() external;

(:~
 : Returns the <i>pre</i> values of the nodes supplied by <code>$nodes</code> , which must all be <a href="#Database_Nodes">database nodes</a> .
 : The <a href="http://docs.basex.org/wiki/Node_Storage#PRE_Value">PRE value</a> provides very fast access to an existing database node, but it will change whenever a node with a smaller <i>pre</i> values is added to or deleted from a database.
 :
 : @error bxerr:BXDB0001 :
 : @error bxerr: contains a node which is not stored in a database.
 :)
declare function db:node-pre($nodes as node()*) as xs:integer* external;

(:~
 : Returns the <i>id</i> values of the nodes supplied by <code>$nodes</code> , which must all be <a href="#Database_Nodes">database nodes</a> .
 : Each database node has a <i>persistent</i>  <a href="http://docs.basex.org/wiki/Node_Storage#ID_Value">ID value</a> . Access to the node id can be sped up by turning on the <a href="http://docs.basex.org/wiki/Options#UPDINDEX">UPDINDEX</a> option.
 :
 : @error bxerr:BXDB0001 :
 : @error bxerr: contains a node which is not stored in a database.
 :)
declare function db:node-id($nodes as node()*) as xs:integer* external;

(:~
 : Returns a <a href="http://docs.basex.org/wiki/Binary_Data">binary resource</a> addressed by the database <code>$db</code> and <code>$path</code> as <a href="http://docs.basex.org/wiki/Streaming_Module">streamable</a>  <code>xs:base64Binary</code> .
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0003 the database is not
 : @error bxerr:FODC0002 the addressed resource cannot be retrieved.
 : @error bxerr:FODC0007 the specified path is invalid.
 :)
declare function db:retrieve($db as xs:string, $path as xs:string) as xs:base64Binary external;

(:~
 : Exports the specified database <code>$db</code> to the specified file <code>$path</code> . Existing files will be overwritten. The <code>$params</code> argument contains serialization parameters (see <a href="http://docs.basex.org/wiki/Serialization">Serialization</a> for more details), which can either be specified
 : <ul> <li> as children of an <code>&lt;output:serialization-parameters/&gt;</code> element, as defined for the <a href="http://www.w3.org/TR/xpath-functions-30/#func-serialize">fn:serialize()</a> function; e.g.: </li> </ul>  <pre class="brush:xml"> &lt;output:serialization-parameters&gt; &lt;output:method value='xml'/&gt; &lt;output:cdata-section-elements value="div"/&gt; ... &lt;/output:serialization-parameters&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "method" := "xml", "cdata-section-elements" := "div", ... } </pre> 
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:export($db as xs:string, $path as xs:string) as empty-sequence() external;

(:~
 : Exports the specified database <code>$db</code> to the specified file <code>$path</code> . Existing files will be overwritten. The <code>$params</code> argument contains serialization parameters (see <a href="http://docs.basex.org/wiki/Serialization">Serialization</a> for more details), which can either be specified
 : <ul> <li> as children of an <code>&lt;output:serialization-parameters/&gt;</code> element, as defined for the <a href="http://www.w3.org/TR/xpath-functions-30/#func-serialize">fn:serialize()</a> function; e.g.: </li> </ul>  <pre class="brush:xml"> &lt;output:serialization-parameters&gt; &lt;output:method value='xml'/&gt; &lt;output:cdata-section-elements value="div"/&gt; ... &lt;/output:serialization-parameters&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "method" := "xml", "cdata-section-elements" := "div", ... } </pre> 
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:export($db as xs:string, $path as xs:string, $params as item()) as empty-sequence() external;

(:~
 : Returns all text nodes of the database <code>$db</code> that have <code>$string</code> as their string value. If available, the value index is used to speed up evaluation.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:text($db as xs:string, $string as item()) as text()* external;

(:~
 : Returns all text nodes of the database <code>$db</code> that are located in between the <code>$min</code> and <code>$max</code> strings. If available, the value index is used to speed up evaluation.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:text-range($db as xs:string, $min as xs:string, $max as xs:string) as text()* external;

(:~
 : Returns all attribute nodes of the database <code>$db</code> that have <code>$string</code> as string value. If available, the value index is used to speed up evaluation.
 : If <code>$attname</code> is specified, the resulting attribute nodes are filtered by their attribute name.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:attribute($db as xs:string, $string as item()) as attribute()* external;

(:~
 : Returns all attribute nodes of the database <code>$db</code> that have <code>$string</code> as string value. If available, the value index is used to speed up evaluation.
 : If <code>$attname</code> is specified, the resulting attribute nodes are filtered by their attribute name.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:attribute($db as xs:string, $string as item(), $attname as xs:string) as attribute()* external;

(:~
 : Returns all attributes of the database <code>$db</code> , the string values of which are larger than or equal to <code>$min</code> and smaller than or equal to <code>$max</code> . If available, the value index is used to speed up evaluation.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:attribute-range($db as xs:string, $min as xs:string, $max as xs:string) as attribute()* external;

(:~
 : Returns all attributes of the database <code>$db</code> , the string values of which are larger than or equal to <code>$min</code> and smaller than or equal to <code>$max</code> . If available, the value index is used to speed up evaluation.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:attribute-range($db as xs:string, $min as xs:string, $max as xs:string, $attname as xs:string) as attribute()* external;

(:~
 : Returns all text nodes from the full-text index of the database <code>$db</code> that contain the text specified as <code>$terms</code> .
 : The options used for building the full-text will also be applied to the search terms. As an example, if the index terms have been stemmed, the search string will be stemmed as well.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0004 the full-text index is not available.
 :)
declare function db:fulltext($db as xs:string, $terms as xs:string) as text()* external;

(:~
 : Creates a new database with name <code>$db</code> and adds initial documents specified via <code>$inputs</code> to the specified <code>$paths</code> .
 : <code>$inputs</code> may be strings or nodes different than attributes. If the <code>$input</code> source is not a file or a folder, the <code>$paths</code> argument is mandatory.
 : Please note that <code>db:create</code> will be placed last on the <a href="http://docs.basex.org/wiki/XQuery_Update#Pending_Update_List">Pending Update List</a> . As a consequence, a newly created database cannot be addressed in the same query.
 : <p>The <code>$options</code> argument can be used to change the indexing behavior. Allowed options are all <a href="http://docs.basex.org/wiki/Options#Indexing">Indexing Options</a> and <a href="http://docs.basex.org/wiki/Options#Full-Text">Full-Text Options</a> in lower case. Options can be specified either...
 : </p>  <ul> <li> as children of an <code>&lt;options/&gt;</code> element, e.g. </li> </ul>  <pre class="brush:xml"> &lt;options&gt; &lt;textindex value='true'/&gt; &lt;maxcats value='128'/&gt; &lt;/options&gt; </pre>  <ul> <li> or as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xquery"> map { "textindex" := true(), "maxcats" = 128 } </pre> 
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
 : <p>The <code>$options</code> argument can be used to change the indexing behavior. Allowed options are all <a href="http://docs.basex.org/wiki/Options#Indexing">Indexing Options</a> and <a href="http://docs.basex.org/wiki/Options#Full-Text">Full-Text Options</a> in lower case. Options can be specified either...
 : </p>  <ul> <li> as children of an <code>&lt;options/&gt;</code> element, e.g. </li> </ul>  <pre class="brush:xml"> &lt;options&gt; &lt;textindex value='true'/&gt; &lt;maxcats value='128'/&gt; &lt;/options&gt; </pre>  <ul> <li> or as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xquery"> map { "textindex" := true(), "maxcats" = 128 } </pre> 
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
 : <p>The <code>$options</code> argument can be used to change the indexing behavior. Allowed options are all <a href="http://docs.basex.org/wiki/Options#Indexing">Indexing Options</a> and <a href="http://docs.basex.org/wiki/Options#Full-Text">Full-Text Options</a> in lower case. Options can be specified either...
 : </p>  <ul> <li> as children of an <code>&lt;options/&gt;</code> element, e.g. </li> </ul>  <pre class="brush:xml"> &lt;options&gt; &lt;textindex value='true'/&gt; &lt;maxcats value='128'/&gt; &lt;/options&gt; </pre>  <ul> <li> or as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xquery"> map { "textindex" := true(), "maxcats" = 128 } </pre> 
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
 : Creates a new database with name <code>$db</code> and adds initial documents specified via <code>$inputs</code> to the specified <code>$paths</code> .
 : <code>$inputs</code> may be strings or nodes different than attributes. If the <code>$input</code> source is not a file or a folder, the <code>$paths</code> argument is mandatory.
 : Please note that <code>db:create</code> will be placed last on the <a href="http://docs.basex.org/wiki/XQuery_Update#Pending_Update_List">Pending Update List</a> . As a consequence, a newly created database cannot be addressed in the same query.
 : <p>The <code>$options</code> argument can be used to change the indexing behavior. Allowed options are all <a href="http://docs.basex.org/wiki/Options#Indexing">Indexing Options</a> and <a href="http://docs.basex.org/wiki/Options#Full-Text">Full-Text Options</a> in lower case. Options can be specified either...
 : </p>  <ul> <li> as children of an <code>&lt;options/&gt;</code> element, e.g. </li> </ul>  <pre class="brush:xml"> &lt;options&gt; &lt;textindex value='true'/&gt; &lt;maxcats value='128'/&gt; &lt;/options&gt; </pre>  <ul> <li> or as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xquery"> map { "textindex" := true(), "maxcats" = 128 } </pre> 
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
declare function db:create($db as xs:string, $inputs as item()*, $paths as xs:string*, $options as item()) as empty-sequence() external;

(:~
 : Drops the database <code>$db</code> and all connected resources.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0007 :
 : @error bxerr: is opened by another process.
 :)
declare function db:drop($db as xs:string) as empty-sequence() external;

(:~
 : Adds documents specified by <code>$input</code> to the database <code>$db</code> and the specified <code>$path</code> .
 : <code>$input</code> may be a string or a node different than attribute. If the <code>$input</code> source is not a file or a folder, <code>$path</code> must be specified.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:FODC0002 :
 : @error bxerr: points to an unknown resource.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither string nor a document node.
 :)
declare function db:add($db as xs:string, $input as item()) as empty-sequence() external;

(:~
 : Adds documents specified by <code>$input</code> to the database <code>$db</code> and the specified <code>$path</code> .
 : <code>$input</code> may be a string or a node different than attribute. If the <code>$input</code> source is not a file or a folder, <code>$path</code> must be specified.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:FODC0002 :
 : @error bxerr: points to an unknown resource.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither string nor a document node.
 :)
declare function db:add($db as xs:string, $input as item(), $path as xs:string) as empty-sequence() external;

(:~
 : Deletes document(s), specified by <code>$path</code> , from the database <code>$db</code> .
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:delete($db as xs:string, $path as xs:string) as empty-sequence() external;

(:~
 : Optimizes the meta data and indexes of the database <code>$db</code> .
 : If <code>$all</code> is set to <code>true()</code> , the complete database will be rebuilt.
 : The usage of the <code>$options</code> argument is identical to the <a href="#db:create">db:create</a> function, except that the <a href="http://docs.basex.org/wiki/Options#UPDINDEX">UPDINDEX</a> option is not supported.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:FOUP0002 an error occurred while optimizing the database.
 :)
declare function db:optimize($db as xs:string) as empty-sequence() external;

(:~
 : Optimizes the meta data and indexes of the database <code>$db</code> .
 : If <code>$all</code> is set to <code>true()</code> , the complete database will be rebuilt.
 : The usage of the <code>$options</code> argument is identical to the <a href="#db:create">db:create</a> function, except that the <a href="http://docs.basex.org/wiki/Options#UPDINDEX">UPDINDEX</a> option is not supported.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:FOUP0002 an error occurred while optimizing the database.
 :)
declare function db:optimize($db as xs:string, $all as xs:boolean) as empty-sequence() external;

(:~
 : Optimizes the meta data and indexes of the database <code>$db</code> .
 : If <code>$all</code> is set to <code>true()</code> , the complete database will be rebuilt.
 : The usage of the <code>$options</code> argument is identical to the <a href="#db:create">db:create</a> function, except that the <a href="http://docs.basex.org/wiki/Options#UPDINDEX">UPDINDEX</a> option is not supported.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:FOUP0002 an error occurred while optimizing the database.
 :)
declare function db:optimize($db as xs:string, $all as xs:boolean, $options as item()) as empty-sequence() external;

(:~
 : Renames document(s), specified by <code>$path</code> to <code>$newpath</code> in the database <code>$db</code> .
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0008 new document names would be empty.
 :)
declare function db:rename($db as xs:string, $path as xs:string, $newpath as xs:string) as empty-sequence() external;

(:~
 : Replaces a document, specified by <code>$path</code> , in the database <code>$db</code> with the content of <code>$input</code> , or adds it as a new document.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0014 :
 : @error bxerr: points to a directory.
 : @error bxerr:FODC0002 :
 : @error bxerr: is a string representing a path, which cannot be read.
 : @error bxerr:FOUP0001 :
 : @error bxerr: is neither a string nor a document node.
 :)
declare function db:replace($db as xs:string, $path as xs:string, $input as item()) as empty-sequence() external;

(:~
 : Stores a binary resource specified by <code>$input</code> in the database <code>$db</code> and the location specified by <code>$path</code> .
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0003 the database is not
 : @error bxerr:FODC0007 the specified path is invalid.
 : @error bxerr:FOUP0002 the resource cannot be stored at the specified location.
 :)
declare function db:store($db as xs:string, $path as xs:string, $input as item()) as empty-sequence() external;

(:~
 : This function can be used to both perform updates and return results in a single query. The argument of the function will be evaluated, and the resulting items will be cached and returned after the updates on the <i>pending update list</i> have been processed. As nodes may be updated, they will be copied before being cached.
 : The function can only be used together with <a href="http://docs.basex.org/wiki/XQuery_Update#Updating_Expressions">updating expressions</a> ; if the function is called within a transform expression, its results will be discarded.
 :)
declare function db:output($result as item()*) as empty-sequence() external;

(:~
 : Explicitly flushes the buffers of the database <code>$db</code> . This command is only useful if <a href="http://docs.basex.org/wiki/Options#AUTOFLUSH">AUTOFLUSH</a> has been set to <code>false</code> .
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:flush($db as xs:string) as empty-sequence() external;

(:~
 : Returns the name of the database in which the specified <a href="#Database_Nodes">database node</a>  <code>$node</code> is stored.
 :
 : @error bxerr:BXDB0001 :
 : @error bxerr: contains a node which is not stored in a database.
 :)
declare function db:name($node as node()) as xs:string external;

(:~
 : Returns the path of the database document in which the specified <a href="#Database_Nodes">database node</a>  <code>$node</code> is stored.
 :
 : @error bxerr:BXDB0001 :
 : @error bxerr: contains a node which is not stored in a database.
 :)
declare function db:path($node as node()) as xs:string external;

(:~
 : Checks if the database <code>$db</code> or the resource specified by <code>$path</code> exists. <code>false</code> is returned if a database directory has been addressed.
 :)
declare function db:exists($db as xs:string) as xs:boolean external;

(:~
 : Checks if the database <code>$db</code> or the resource specified by <code>$path</code> exists. <code>false</code> is returned if a database directory has been addressed.
 :)
declare function db:exists($db as xs:string, $path as xs:string) as xs:boolean external;

(:~
 : Checks if the specified resource in the database <code>$db</code> and the path <code>$path</code> exists, and if it is a <a href="http://docs.basex.org/wiki/Binary_Data">binary resource</a> .
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:is-raw($db as xs:string, $path as xs:string) as xs:boolean external;

(:~
 : Checks if the specified resource in the database <code>$db</code> and the path <code>$path</code> exists, and if it is an XML document.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function db:is-xml($db as xs:string, $path as xs:string) as xs:boolean external;

(:~
 : Retrieves the content type of a resource in the database <code>$db</code> and the path <code>$path</code> .
 : The file extension is used to recognize the content-type of a resource stored in the database. Content-type <code>application/xml</code> will be returned for any XML document stored in the database, regardless of its file name extension.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:FODC0002 the addressed resource is not found or cannot be retrieved.
 :)
declare function db:content-type($db as xs:string, $path as xs:string) as xs:string external;



