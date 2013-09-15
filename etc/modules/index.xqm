(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> provides functions for displaying information stored in the database index structures.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace index = "http://basex.org/modules/index";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns information about all facets and facet values of the database <code>$db</code> in document structure format.
 : If <code>$type</code> is specified as <code>flat</code> , the function returns this information in a flat summarized version. The returned data is derived from the <a href="http://docs.basex.org/wiki/Indexes#Path_Index">Path Index</a> .
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function index:facets($db as xs:string) as xs:string external;

(:~
 : Returns information about all facets and facet values of the database <code>$db</code> in document structure format.
 : If <code>$type</code> is specified as <code>flat</code> , the function returns this information in a flat summarized version. The returned data is derived from the <a href="http://docs.basex.org/wiki/Indexes#Path_Index">Path Index</a> .
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function index:facets($db as xs:string, $type as xs:string) as xs:string external;

(:~
 : Returns all strings stored in the <a href="http://docs.basex.org/wiki/Indexes#Text_Index">Text Index</a> of the database <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0004 the text index is not available.
 :)
declare function index:texts($db as xs:string) as element(value)* external;

(:~
 : Returns all strings stored in the <a href="http://docs.basex.org/wiki/Indexes#Text_Index">Text Index</a> of the database <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0004 the text index is not available.
 :)
declare function index:texts($db as xs:string, $prefix as xs:string) as element(value)* external;

(:~
 : Returns all strings stored in the <a href="http://docs.basex.org/wiki/Indexes#Text_Index">Text Index</a> of the database <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0004 the text index is not available.
 :)
declare function index:texts($db as xs:string, $start as xs:string, $ascending as xs:boolean) as element(value)* external;

(:~
 : Returns all strings stored in the <a href="http://docs.basex.org/wiki/Indexes#Attribute_Index">Attribute Index</a> of the database <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0004 the attribute index is not available.
 :)
declare function index:attributes($db as xs:string) as element(value)* external;

(:~
 : Returns all strings stored in the <a href="http://docs.basex.org/wiki/Indexes#Attribute_Index">Attribute Index</a> of the database <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0004 the attribute index is not available.
 :)
declare function index:attributes($db as xs:string, $prefix as xs:string) as element(value)* external;

(:~
 : Returns all strings stored in the <a href="http://docs.basex.org/wiki/Indexes#Attribute_Index">Attribute Index</a> of the database <code>$db</code> , along with their number of occurrences.
 : If <code>$prefix</code> is specified, the returned entries will be refined to the ones starting with that prefix.
 : If <code>$start</code> and <code>$ascending</code> are specified, all nodes will be returned after or before the specified start entry.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 : @error bxerr:BXDB0004 the attribute index is not available.
 :)
declare function index:attributes($db as xs:string, $start as xs:string, $ascending as xs:boolean) as element(value)* external;

(:~
 : Returns all element names stored in the <a href="http://docs.basex.org/wiki/Indexes#Name_Index">Name Index</a> of the database <code>$db</code> , along with their number of occurrences.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function index:element-names($db as xs:string) as element(value)* external;

(:~
 : Returns all attribute names stored in the <a href="http://docs.basex.org/wiki/Indexes#Name_Index">Name Index</a> of the database <code>$db</code> , along with their number of occurrences.
 :
 : @error bxerr:BXDB0002 The addressed database does not exist or could not be opened.
 :)
declare function index:attribute-names($db as xs:string) as element(value)* external;



