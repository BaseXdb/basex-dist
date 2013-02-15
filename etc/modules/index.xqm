(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> provides functions for displaying information stored in the database index structures.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace index = "http://basex.org/modules/index";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns information about possible facets and facet values of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> in document structure format.
 : If <code>$type</code> is specified as <code>flat</code> , the function returns this information in a flat summarized version.
 :)
declare function index:facets($db as item()) as xs:string external;

(:~
 : Returns information about possible facets and facet values of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> in document structure format.
 : If <code>$type</code> is specified as <code>flat</code> , the function returns this information in a flat summarized version.
 :)
declare function index:facets($db as item(), $type as xs:string) as xs:string external;

(:~
 : Returns all strings stored in the text index of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0004 the text index is not available.
 :)
declare function index:texts($db as item()) as element(value)* external;

(:~
 : Returns all strings stored in the text index of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0004 the text index is not available.
 :)
declare function index:texts($db as item(), $prefix as xs:string) as element(value)* external;

(:~
 : Returns all strings stored in the text index of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0004 the text index is not available.
 :)
declare function index:texts($db as item(), $start as xs:string, $ascending as xs:boolean) as element(value)* external;

(:~
 : Returns all strings stored in the attribute index of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0004 the attribute index is not available.
 :)
declare function index:attributes($db as item()) as element(value)* external;

(:~
 : Returns all strings stored in the attribute index of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0004 the attribute index is not available.
 :)
declare function index:attributes($db as item(), $prefix as xs:string) as element(value)* external;

(:~
 : Returns all strings stored in the attribute index of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0004 the attribute index is not available.
 :)
declare function index:attributes($db as item(), $start as xs:string, $ascending as xs:boolean) as element(value)* external;

(:~
 : Returns all element names stored in the index of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> , along with their number of occurrences.
 :)
declare function index:element-names($db as item()) as element(value)* external;

(:~
 : Returns all attribute names stored in the index of the <a href="http://docs.basex.org/wiki/Database_Module#Database_Nodes">database node</a>  <code>$db</code> , along with their number of occurrences.
 :)
declare function index:attribute-names($db as item()) as element(value)* external;



