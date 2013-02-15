(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions to handle archives (including ePub, Open Office, JAR, and many other formats). New ZIP and GZIP archives can be created, existing archives can be updated, and the archive entries can be listed and extracted. This module may soon replace the existing <a href="http://docs.basex.org/wiki/ZIP_Module">ZIP Module</a> ( <a href="http://spex.basex.org/index.php?title=ZIP_Module">more information</a> ).
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace archive = "http://basex.org/modules/archive";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Creates a new archive from the specified entries and contents.
 : The <code>$entries</code> argument contains meta information required to create new entries. All items may either be of type <code>xs:string</code> , representing the entry name, or <code>element(archive:entry)</code> , containing the name as text node and additional, optional attributes: <ul> <li> <code>last-modified</code>: timestamp, specified as xs:dateTime (default: current time) </li> <li> <code>compression-level</code>: 0-9, 0 = uncompressed (default: 8) </li> <li> <code>encoding</code>: for textual entries (default: UTF-8) </li> </ul>  <p>An example: </p>  <pre class="brush:xml"> &lt;archive:entry last-modified='2011-11-11T11:11:11' compression-level='8' encoding='US-ASCII'&gt;hello.txt&lt;/archive:entry&gt; </pre>  <p>The actual <code>$contents</code> must be <code>xs:string</code> or <code>xs:base64Binary</code> items.
 : The <code>$options</code> parameter contains archiving options, which can either be specified </p>  <ul> <li> as children of an <code>&lt;archive:options/&gt;</code> element: </li> </ul>  <pre class="brush:xml"> &lt;archive:options&gt; &lt;archive:format value="zip"/&gt; &lt;archive:algorithm value="deflate"/&gt; &lt;/archive:options&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "format" := "zip", "algorithm" := "deflate" } </pre>  <p>Currently, the following combinations are supported (all others will be rejected): </p>  <ul> <li> <code>zip</code>: <code>algorithm</code> may be <code>stored</code> or <code>deflate</code> </li> <li> <code>gzip</code>: algorithm may be <code>deflate</code> </li> </ul> 
 :
 : @error bxerr:ARCH0001 the number of entries and contents differs.
 : @error bxerr:ARCH0002 the specified option or its value is invalid or not supported.
 : @error bxerr:ARCH0003 entry descriptors contain invalid entry names, timestamps or compression levels.
 : @error bxerr:ARCH0004 the specified encoding is invalid or not supported, or the string conversion failed.
 : @error bxerr:ARCH0005 the chosen archive format only allows single entries.
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 : @error bxerr:FORG0006 an argument has a wrong type.
 :)
declare function archive:create($entries as item(), $contents as item()*) as xs:base64Binary external;

(:~
 : Creates a new archive from the specified entries and contents.
 : The <code>$entries</code> argument contains meta information required to create new entries. All items may either be of type <code>xs:string</code> , representing the entry name, or <code>element(archive:entry)</code> , containing the name as text node and additional, optional attributes: <ul> <li> <code>last-modified</code>: timestamp, specified as xs:dateTime (default: current time) </li> <li> <code>compression-level</code>: 0-9, 0 = uncompressed (default: 8) </li> <li> <code>encoding</code>: for textual entries (default: UTF-8) </li> </ul>  <p>An example: </p>  <pre class="brush:xml"> &lt;archive:entry last-modified='2011-11-11T11:11:11' compression-level='8' encoding='US-ASCII'&gt;hello.txt&lt;/archive:entry&gt; </pre>  <p>The actual <code>$contents</code> must be <code>xs:string</code> or <code>xs:base64Binary</code> items.
 : The <code>$options</code> parameter contains archiving options, which can either be specified </p>  <ul> <li> as children of an <code>&lt;archive:options/&gt;</code> element: </li> </ul>  <pre class="brush:xml"> &lt;archive:options&gt; &lt;archive:format value="zip"/&gt; &lt;archive:algorithm value="deflate"/&gt; &lt;/archive:options&gt; </pre>  <ul> <li> as map, which contains all key/value pairs: </li> </ul>  <pre class="brush:xml"> map { "format" := "zip", "algorithm" := "deflate" } </pre>  <p>Currently, the following combinations are supported (all others will be rejected): </p>  <ul> <li> <code>zip</code>: <code>algorithm</code> may be <code>stored</code> or <code>deflate</code> </li> <li> <code>gzip</code>: algorithm may be <code>deflate</code> </li> </ul> 
 :
 : @error bxerr:ARCH0001 the number of entries and contents differs.
 : @error bxerr:ARCH0002 the specified option or its value is invalid or not supported.
 : @error bxerr:ARCH0003 entry descriptors contain invalid entry names, timestamps or compression levels.
 : @error bxerr:ARCH0004 the specified encoding is invalid or not supported, or the string conversion failed.
 : @error bxerr:ARCH0005 the chosen archive format only allows single entries.
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 : @error bxerr:FORG0006 an argument has a wrong type.
 :)
declare function archive:create($entries as item(), $contents as item()*, $options as item()) as xs:base64Binary external;

(:~
 : Returns the entry descriptors of the given archive. A descriptor contains the following attributes, provided that they are available in the archive format: <ul> <li> <code>size</code>: original file size </li> <li> <code>last-modified</code>: timestamp, formatted as xs:dateTime </li> <li> <code>compressed-size</code>: compressed file size </li> </ul>  <p>An example: </p>  <pre class="brush:xml"> &lt;archive:entry size="1840" last-modified="2009-03-20T03:30:32" compressed-size="672"&gt; doc/index.html &lt;/archive:entry&gt; </pre> 
 :
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 :)
declare function archive:entries($archive as xs:base64Binary) as element(archive:entry)* external;

(:~
 : Returns the options of the given archive in the format specified by <a href="#archive:create">archive:create</a> .
 :
 : @error bxerr:ARCH0002 The packing format is not supported.
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 :)
declare function archive:options($archive as xs:base64Binary) as element(archive:options) external;

(:~
 : Extracts archive entries and returns them as texts.
 : The returned entries can be limited via <code>$entries</code> . The format of the argument is the same as for <a href="#archive:create">archive:create</a> (attributes will be ignored).
 : The encoding of the input files can be specified via <code>$encoding</code> .
 :
 : @error bxerr:ARCH0004 the specified encoding is invalid or not supported, or the string conversion failed.
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 :)
declare function archive:extract-text($archive as xs:base64Binary) as xs:string* external;

(:~
 : Extracts archive entries and returns them as texts.
 : The returned entries can be limited via <code>$entries</code> . The format of the argument is the same as for <a href="#archive:create">archive:create</a> (attributes will be ignored).
 : The encoding of the input files can be specified via <code>$encoding</code> .
 :
 : @error bxerr:ARCH0004 the specified encoding is invalid or not supported, or the string conversion failed.
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 :)
declare function archive:extract-text($archive as xs:base64Binary, $entries as item()*) as xs:string* external;

(:~
 : Extracts archive entries and returns them as texts.
 : The returned entries can be limited via <code>$entries</code> . The format of the argument is the same as for <a href="#archive:create">archive:create</a> (attributes will be ignored).
 : The encoding of the input files can be specified via <code>$encoding</code> .
 :
 : @error bxerr:ARCH0004 the specified encoding is invalid or not supported, or the string conversion failed.
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 :)
declare function archive:extract-text($archive as xs:base64Binary, $entries as item()*, $encoding as xs:string) as xs:string* external;

(:~
 : Extracts archive entries and returns them as binaries.
 : The returned entries can be limited via <code>$entries</code> . The format of the argument is the same as for <a href="#archive:create">archive:create</a> (attributes will be ignored).
 :
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 :)
declare function archive:extract-binary($archive as xs:base64Binary) as xs:string* external;

(:~
 : Extracts archive entries and returns them as binaries.
 : The returned entries can be limited via <code>$entries</code> . The format of the argument is the same as for <a href="#archive:create">archive:create</a> (attributes will be ignored).
 :
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 :)
declare function archive:extract-binary($archive as xs:base64Binary, $entries as item()*) as xs:base64Binary* external;

(:~
 : Adds new entries and replaces existing entries in an archive.
 : The format of <code>$entries</code> and <code>$contents</code> is the same as for <a href="#archive:create">archive:create</a> .
 :
 : @error bxerr:ARCH0001 the number of entries and contents differs.
 : @error bxerr:ARCH0003 entry descriptors contain invalid entry names, timestamps, compression levels or encodings.
 : @error bxerr:ARCH0004 the specified encoding is invalid or not supported, or the string conversion failed.
 : @error bxerr:ARCH0005 the entries of the given archive cannot be modified.
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 : @error bxerr:FORG0006 (some of) the contents are not of type
 : @error bxerr: or
 : @error bxerr: .
 :)
declare function archive:update($archive as xs:base64Binary, $entries as item()*, $contents as item()*) as xs:base64Binary external;

(:~
 : Deletes entries from an archive.
 : The format of <code>$entries</code> is the same as for <a href="#archive:create">archive:create</a> .
 :
 : @error bxerr:ARCH0005 the entries of the given archive cannot be modified.
 : @error bxerr:ARCH9999 archive creation failed for some other reason.
 :)
declare function archive:delete($archive as xs:base64Binary, $entries as item()*) as xs:base64Binary external;



