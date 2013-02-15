(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions for simplifying formatted data output.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace out = "http://basex.org/modules/out";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns a single newline character ( <code>&amp;#10;</code> ).
 :)
declare function out:nl() as xs:string external;

(:~
 : Returns a single tabulator character ( <code>&amp;#9;</code> ).
 :)
declare function out:tab() as xs:string external;

(:~
 : Returns a formatted string. <code>$item1</code> and all following items are applied to the <code>$format</code> string, according to <a href="http://download.oracle.com/javase/1.5.0/docs/api/java/util/Formatter.html#syntax">Java’s printf syntax</a> .
 :)
declare function out:format($format as xs:string, $item1 as item()) as xs:string external;



