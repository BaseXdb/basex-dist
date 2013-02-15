(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions and variables to perform XSLT transformations. By default, this module uses Java’s XSLT 1.0 Xalan implementation to transform documents. XSLT 2.0 is used instead if Version 9.x of the <a href="http://www.saxonica.com/">Saxon XSLT Processor</a> ( <code>saxon9he.jar</code> , <code>saxon9pe.jar</code> , <code>saxon9ee.jar</code> ) is found in the classpath. A custom transformer can be specified by overwriting the system property <code>javax.xml.transform.TransformerFactory</code> , as shown in the following Java example:
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace xslt = "http://basex.org/modules/xslt";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns the name of the applied XSLT processor, or the path to a custom implementation (currently: "Java", "Saxon EE", "Saxon PE", or "Saxon HE").
 :)
declare function xslt:processor() as xs:string external;

(:~
 : Returns the supported XSLT version (currently: "1.0" or "2.0"). "Unknown" is returned if a custom implementation was chosen.
 :)
declare function xslt:version() as xs:string external;

(:~
 : Transforms the document specified by <code>$input</code> , using the XSLT template specified by <code>$stylesheet</code> , and returns the result as node. <code>$input</code> and <code>$stylesheet</code> can be specified as
 : <ul> <li> <code>xs:string</code>, containing the path to the document, </li> <li> <code>xs:string</code>, containing the document in its string representation, or </li> <li> <code>node()</code>, containing the document itself. </li> </ul>  <p>The <code>$params</code> argument can be used to bind variables to a stylesheet, which can either be specified
 : </p>  <ul> <li> as children of an <code>&lt;xslt:parameters/&gt;</code> element; e.g.: </li> </ul>  <pre class="brush:xml"> &lt;xslt:parameters&gt; &lt;xslt:key1 value='value1'/&gt; ... &lt;/xslt:parameters&gt; </pre>  <ul> <li> or as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xquery"> map { "key1" := "value1", ... } </pre>  <p>Note that only strings are supported when using Saxon (XSLT 2.0). </p> 
 :)
declare function xslt:transform($input as item(), $stylesheet as item()) as node() external;

(:~
 : Transforms the document specified by <code>$input</code> , using the XSLT template specified by <code>$stylesheet</code> , and returns the result as node. <code>$input</code> and <code>$stylesheet</code> can be specified as
 : <ul> <li> <code>xs:string</code>, containing the path to the document, </li> <li> <code>xs:string</code>, containing the document in its string representation, or </li> <li> <code>node()</code>, containing the document itself. </li> </ul>  <p>The <code>$params</code> argument can be used to bind variables to a stylesheet, which can either be specified
 : </p>  <ul> <li> as children of an <code>&lt;xslt:parameters/&gt;</code> element; e.g.: </li> </ul>  <pre class="brush:xml"> &lt;xslt:parameters&gt; &lt;xslt:key1 value='value1'/&gt; ... &lt;/xslt:parameters&gt; </pre>  <ul> <li> or as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xquery"> map { "key1" := "value1", ... } </pre>  <p>Note that only strings are supported when using Saxon (XSLT 2.0). </p> 
 :)
declare function xslt:transform($input as item(), $stylesheet as item(), $params as item()) as node() external;

(:~
 : Transforms the document specified by <code>$input</code> , using the XSLT template specified by <code>$stylesheet</code> , and returns the result as string. The parameters are the same as described for <a href="#xslt:transform">xslt:transform</a> .
 :)
declare function xslt:transform-text($input as item(), $stylesheet as item()) as xs:string external;

(:~
 : Transforms the document specified by <code>$input</code> , using the XSLT template specified by <code>$stylesheet</code> , and returns the result as string. The parameters are the same as described for <a href="#xslt:transform">xslt:transform</a> .
 :)
declare function xslt:transform-text($input as item(), $stylesheet as item(), $params as item()) as xs:string external;



