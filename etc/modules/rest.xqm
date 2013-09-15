(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains helper functions for the <a href="http://docs.basex.org/wiki/RESTXQ">RESTXQ</a> API, some of which are defined in the <a href="http://exquery.github.io/exquery/exquery-restxq-specification/restxq-1.0-specification.html">RESTXQ Draft</a> .
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace rest = "http://exquery.org/ns/restxq";
declare namespace wadl = "http://wadl.dev.java.net/2009/02";

(:~
 : This function returns the implementation defined base URI of the resource function.
 :)
declare function rest:base-uri() as xs:anyURI external;

(:~
 : This function returns the complete URI that addresses the Resource Function. This is the result of <a href="#rest:base-uri">rest:base-uri</a> appended with the path from the path annotation of the resource function.
 :)
declare function rest:uri() as xs:anyURI external;

(:~
 : This (unofficial) function returns a <a href="http://www.w3.org/Submission/wadl">WADL description</a> of all available REST services.
 :)
declare function rest:wadl() as element(wadl:application) external;



