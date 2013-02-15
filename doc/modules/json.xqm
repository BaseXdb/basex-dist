(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions to parse and serialize JSON documents. <a href="http://www.json.org/">JSON (JavaScript Object Notation)</a> is a popular data exchange format for applications written in JavaScript. As there are notable differences between JSON and XML, no mapping exists that guarantees a lossless, bidirectional conversion between JSON and XML. For this reason, we offer two sets of functions in this module:
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace json = "http://basex.org/modules/json";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Converts the JSON document specified by <code>$input</code> to XML, and returns the result as <code>element(json)</code> instance. The converted XML document is both well readable and lossless, i.e., the converted document can be serialized back to the original JSON representation.
 :
 : @error bxerr:BXJS0001 the specified input cannot be parsed as JSON document.
 :)
declare function json:parse($input as xs:string) as element(json) external;

(:~
 : Serializes the node specified by <code>$input</code> as JSON, and returns the result as <code>xs:string</code> instance. The serialized node must conform to the syntax specified by the <a href="#json:parse">json:parse()</a> function.
 : XML documents can also be serialized as JSON if the <a href="http://docs.basex.org/wiki/Serialization">Serialization Option</a>  <code>"method"</code> is set to <code>"json"</code> .
 :
 : @error bxerr:BXJS0002 the specified node cannot be serialized as JSON document.
 :)
declare function json:serialize($input as node()) as xs:string external;

(:~
 : Serializes the node specified by <code>$input</code> and returns the result as <code>xs:string</code> instance.
 : XML documents can also be output in the JsonML format by setting the <a href="http://docs.basex.org/wiki/Serialization">Serialization Option</a>  <code>"method"</code> to <code>"jsonml"</code> .
 :
 : @error bxerr:BXJS0002 the specified value cannot be serialized.
 :)
declare function json:serialize-ml($input as node()) as xs:string external;

(:~
 : Converts the <a href="http://jsonml.org">JsonML</a> document specified by <code>$input</code> to XML, and returns the result as <code>element()</code> instance. The JSON input must conform to the JsonML specification to be successfully converted.
 :
 : @error bxerr:BXJS0001 the specified input cannot be parsed as JsonML instance.
 :)
declare function json:parse-ml($input as xs:string) as element() external;



