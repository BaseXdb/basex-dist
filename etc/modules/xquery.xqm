(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions to evaluate XQuery strings and modules at runtime.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace xquery = "http://basex.org/modules/xquery";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Evaluates <code>$query</code> as XQuery expression at runtime and returns the resulting items.
 : Variables and context items can be declared via <code>$bindings</code> . The specified keys must be QNames or strings, the values can be arbitrary item sequences: <ul> <li> variables specified as QNames will be directly interpreted as variable name. </li> <li> variables specified as xs:string may be prefixed with a dollar sign. Namespace can be specified using the <a href="http://www.jclark.com/xml/xmlns.htm">Clark Notation</a>. If the specified string is empty, the value will be bound to the context item. </li> </ul> 
 :
 : @error bxerr:BXXQ0001 the query contains
 :)
declare function xquery:eval($query as xs:string) as item()* external;

(:~
 : Evaluates <code>$query</code> as XQuery expression at runtime and returns the resulting items.
 : Variables and context items can be declared via <code>$bindings</code> . The specified keys must be QNames or strings, the values can be arbitrary item sequences: <ul> <li> variables specified as QNames will be directly interpreted as variable name. </li> <li> variables specified as xs:string may be prefixed with a dollar sign. Namespace can be specified using the <a href="http://www.jclark.com/xml/xmlns.htm">Clark Notation</a>. If the specified string is empty, the value will be bound to the context item. </li> </ul> 
 :
 : @error bxerr:BXXQ0001 the query contains
 :)
declare function xquery:eval($query as xs:string, $bindings as map(*)) as item()* external;

(:~
 : Opens <code>$uri</code> as file, evaluates it as XQuery expression at runtime, and returns the resulting items.
 : The semantics of the <code>$bindings</code> parameter is the same as for <a href="#xquery:eval">xquery:eval</a> .
 :
 : @error bxerr:BXXQ0001 the query contains
 :)
declare function xquery:invoke($uri as xs:string) as item()* external;

(:~
 : Opens <code>$uri</code> as file, evaluates it as XQuery expression at runtime, and returns the resulting items.
 : The semantics of the <code>$bindings</code> parameter is the same as for <a href="#xquery:eval">xquery:eval</a> .
 :
 : @error bxerr:BXXQ0001 the query contains
 :)
declare function xquery:invoke($expr as xs:string, $bindings as map(*)) as item()* external;

(:~
 : Similar to <code>fn:trace($expr, $msg)</code> , but instead of a user-defined message, it emits the compile-time type and estimated result size of its argument.
 :)
declare function xquery:type($expr as item()*) as item()* external;



