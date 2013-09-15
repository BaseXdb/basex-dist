(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions for extracting internal information about modules and functions and generating documentation.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace inspect = "http://basex.org/modules/inspect";
declare namespace xqdoc = "http://www.xqdoc.org/1.0";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns function items for all user-defined functions that are known in the current query context.
 :)
declare function inspect:functions() as function(*)* external;

(:~
 : Inspects the specified <code>$function</code> and returns an element that describs its structure. The output of this function is similar to eXist-db’s <a href="http://exist-db.org/exist/apps/fundocs/view.html?uri=http://exist-db.org/xquery/inspection&amp;location=java:org.exist.xquery.functions.inspect.InspectionModule">inspect:inspect-function</a> function.
 :)
declare function inspect:function($function as function(*)) as element(function) external;

(:~
 : Generates an element that describes all variables and functions in the current query context.
 :)
declare function inspect:context() as element(context) external;

(:~
 : Retrieves the string from the specified <code>$input</code> , parses it as XQuery module, and generates an element that dscribes its structure.
 :
 : @error xqdoc:FODC0002 the addressed resource cannot be retrieved.
 :)
declare function inspect:module($uri as xs:string) as element(module) external;

(:~
 : Retrieves the string from the specified <code>$input</code> , parses it as XQuery module, and generates an xqDoc element.
 : <a href="http://xqdoc.org">xqDoc</a> ] provides a simple vendor neutral solution for generating a documentation from XQuery modules. The documentation conventions have been inspired by the JavaDoc standard. Documentation comments begin with <code>(:~</code> and end with <code>:)</code> , and tags start with <code>@</code> . xqDoc comments can be specified for main and library modules and variable and function declarations.
 : <p>We have slightly extended the xqDoc conventions to do justice to the current status of XQuery (Schema: <a href="http://files.basex.org/etc/xqdoc-1.1.30052013.xsd">xqdoc-1.1.30052013.xsd</a>):
 : </p>  <ul> <li> an <code>&lt;xqdoc:annotations/&gt;</code> node is added to each variable or function that uses annotations. The xqdoc:annotation child nodes may have additional <code>xqdoc:literal</code> elements with <code>type</code> attributes (xs:string, xs:integer, xs:decimal, xs:double) and values. </li> <li> a single <code>&lt;xqdoc:namespaces/&gt;</code> node is added to the root element, which summarizes all prefixes and namespace URIs used or declared in the module. </li> <li> name and type elements are added to variables </li> </ul> 
 :
 : @error xqdoc:FODC0002 the addressed resource cannot be retrieved.
 :)
declare function inspect:xqdoc($uri as xs:string) as element(xqdoc:xqdoc) external;



