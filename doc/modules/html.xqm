(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> provides functions for converting HTML to XML. Conversion will only take place if <a href="http://home.ccil.org/~cowan/XML/tagsoup/">TagSoup</a> is included in the classpath (see <a href="http://docs.basex.org/wiki/Parsers#HTML_Parser">HTML Parsing</a> for more details).
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace html = "http://basex.org/modules/html";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns the name of the applied HTML parser (currently: <code>TagSoup</code> ). If an <i>empty string</i> is returned, TagSoup was not found in the classpath, and the input will be treated as well-formed XML.
 :)
declare function html:parser() as xs:string external;

(:~
 : Converts the HTML document specified by <code>$input</code> to XML, and returns a document node:
 : <ul> <li> The input may either be a string or a binary item (xs:hexBinary, xs:base64Binary). </li> <li> If the input is passed on in its binary representation, the HTML parser will try to automatically choose the correct encoding. </li> </ul>  <p>The <code>$options</code> argument can be used to set <a href="http://docs.basex.org/wiki/Parsers#TagSoup_Options">TagSoup Options</a>, which can be specified…
 : </p>  <ul> <li> as children of an <code>&lt;html:options/&gt;</code> element; e.g.: </li> </ul>  <pre class="brush:xml"> &lt;html:options&gt; &lt;html:key1 value='value1'/&gt; ... &lt;/html:options&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "key1" := "value1", ... } </pre> 
 :
 : @error bxerr:BXHL0001 the input cannot be converted to XML.
 :)
declare function html:parse($input as xs:anyAtomicType) as document-node() external;

(:~
 : Converts the HTML document specified by <code>$input</code> to XML, and returns a document node:
 : <ul> <li> The input may either be a string or a binary item (xs:hexBinary, xs:base64Binary). </li> <li> If the input is passed on in its binary representation, the HTML parser will try to automatically choose the correct encoding. </li> </ul>  <p>The <code>$options</code> argument can be used to set <a href="http://docs.basex.org/wiki/Parsers#TagSoup_Options">TagSoup Options</a>, which can be specified…
 : </p>  <ul> <li> as children of an <code>&lt;html:options/&gt;</code> element; e.g.: </li> </ul>  <pre class="brush:xml"> &lt;html:options&gt; &lt;html:key1 value='value1'/&gt; ... &lt;/html:options&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "key1" := "value1", ... } </pre> 
 :
 : @error bxerr:BXHL0001 the input cannot be converted to XML.
 :)
declare function html:parse($input as xs:anyAtomicType, $options as item()) as document-node() external;



