(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions to access relational databases from XQuery using SQL. With this module, you can execute query, update and prepared statements, and the result sets are returned as sequences of XML elements representing tuples. Each element has children representing the columns returned by the SQL statement.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace sql = "http://basex.org/modules/sql";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : This function initializes a JDBC driver specified via <code>$class</code> . This step might be superfluous if the SQL database is not embedded.
 :
 : @error bxerr:BXSQ0007 the specified driver class is not found.
 :)
declare function sql:init($class as xs:string) as empty-sequence() external;

(:~
 : This function establishes a connection to a relational database. As a result a connection handle is returned. The parameter <code>$url</code> is the URL of the database and shall be of the form: <code>jdbc:&lt;driver name&gt;:[//&lt;server&gt;[/&lt;database&gt;]</code> . If the parameters <code>$user</code> and <code>$password</code> are specified, they are used as credentials for connecting to the database. The <code>$options</code> parameter can be used to set connection options, which can either be specified
 : <ul> <li> as children of an <code>&lt;sql:options/&gt;</code> element, e.g.: </li> </ul>  <pre class="brush:xml"> &lt;sql:options&gt; &lt;sql:autocommit value='true'/&gt; ... &lt;/sql:options&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "autocommit" := "true", ... } </pre> 
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs, e.g. missing JDBC driver or not existing relation.
 :)
declare function sql:connect($url as xs:string) as xs:integer external;

(:~
 : This function establishes a connection to a relational database. As a result a connection handle is returned. The parameter <code>$url</code> is the URL of the database and shall be of the form: <code>jdbc:&lt;driver name&gt;:[//&lt;server&gt;[/&lt;database&gt;]</code> . If the parameters <code>$user</code> and <code>$password</code> are specified, they are used as credentials for connecting to the database. The <code>$options</code> parameter can be used to set connection options, which can either be specified
 : <ul> <li> as children of an <code>&lt;sql:options/&gt;</code> element, e.g.: </li> </ul>  <pre class="brush:xml"> &lt;sql:options&gt; &lt;sql:autocommit value='true'/&gt; ... &lt;/sql:options&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "autocommit" := "true", ... } </pre> 
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs, e.g. missing JDBC driver or not existing relation.
 :)
declare function sql:connect($url as xs:string, $user as xs:string, $password as xs:string) as xs:integer external;

(:~
 : This function establishes a connection to a relational database. As a result a connection handle is returned. The parameter <code>$url</code> is the URL of the database and shall be of the form: <code>jdbc:&lt;driver name&gt;:[//&lt;server&gt;[/&lt;database&gt;]</code> . If the parameters <code>$user</code> and <code>$password</code> are specified, they are used as credentials for connecting to the database. The <code>$options</code> parameter can be used to set connection options, which can either be specified
 : <ul> <li> as children of an <code>&lt;sql:options/&gt;</code> element, e.g.: </li> </ul>  <pre class="brush:xml"> &lt;sql:options&gt; &lt;sql:autocommit value='true'/&gt; ... &lt;/sql:options&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "autocommit" := "true", ... } </pre> 
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs, e.g. missing JDBC driver or not existing relation.
 :)
declare function sql:connect($url as xs:string, $user as xs:string, $password as xs:string, $options as item()) as xs:integer external;

(:~
 : This function executes a query or update statement. The parameter <code>$connection</code> specifies a connection handle. The parameter <code>$query</code> is a string representing an SQL statement.
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs, e.g. not existing relation is retrieved.
 :)
declare function sql:execute($connection as xs:integer, $query as xs:string) as element()* external;

(:~
 : This function executes a prepared statement. The parameter <code>$id</code> specifies a prepared statement handle. The optional parameter <code>$params</code> is an element <code>&lt;sql:parameters/&gt;</code> representing the parameters for a prepared statement along with their types and values. The following schema shall be used:
 : <pre class="brush:xml"> element sql:parameters { element sql:parameter { attribute type { "int"|"string"|"boolean"|"date"|"double"|"float"|"short"|"time"|"timestamp" }, attribute null { "true"|"false" }?, text }+ }? </pre> 
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs, e.g. not existing relation is retrieved.
 :)
declare function sql:execute-prepared($id as xs:integer, $params as element(sql:parameters)) as element()* external;

(:~
 : This function prepares a statement and returns a handle to it. The parameter <code>$connection</code> indicates the connection handle to be used. The parameter <code>$statement</code> is a string representing an SQL statement with one or more '?' placeholders. If the value of a field has to be set to <code>NULL</code> , then the attribute <code>null</code> of the element <code>&lt;sql:parameter/&gt;</code> has to be <code>true</code> .
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs.
 :)
declare function sql:prepare($connection as xs:integer, $statement as xs:string) as xs:integer external;

(:~
 : This function commits the changes made to a relational database. <code>$connection</code> specifies the connection handle.
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs.
 :)
declare function sql:commit($connection as xs:integer) as empty-sequence() external;

(:~
 : This function rolls back the changes made to a relational database. <code>$connection</code> specifies the connection handle.
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs.
 :)
declare function sql:rollback($connection as xs:integer) as empty-sequence() external;

(:~
 : This function closes a connection to a relational database. <code>$connection</code> specifies the connection handle.
 :
 : @error bxerr:BXSQ0001 an SQL exception occurs.
 :)
declare function sql:close($connection as xs:integer) as empty-sequence() external;



