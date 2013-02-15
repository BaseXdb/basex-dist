(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions to handle ZIP archives. The contents of ZIP files can be extracted and listed, and new archives can be created. The module is based on the <a href="http://expath.org/spec/zip">EXPath ZIP Module</a> . It may soon be replaced by the <a href="http://docs.basex.org/wiki/Archive_Module">Archive Module</a> .
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace zip = "http://expath.org/ns/zip";
declare namespace experr = "http://expath.org/ns/error";

(:~
 : Extracts the binary file at <code>$path</code> within the ZIP file located at <code>$uri</code> and returns it as an <code>xs:base64Binary</code> item.
 :
 : @error experr:ZIP0001 the specified path does not exist.
 : @error experr:ZIP0003 the operation fails for some other reason.
 :)
declare function zip:binary-entry($uri as xs:string, $path as xs:string) as xs:base64Binary external;

(:~
 : Extracts the text file at <code>$path</code> within the ZIP file located at <code>$uri</code> and returns it as an <code>xs:string</code> item.
 : An optional encoding can be specified via <code>$encoding</code> .
 :
 : @error experr:ZIP0001 the specified path does not exist.
 : @error experr:ZIP0003 the operation fails for some other reason.
 :)
declare function zip:text-entry($uri as xs:string, $path as xs:string) as xs:string external;

(:~
 : Extracts the text file at <code>$path</code> within the ZIP file located at <code>$uri</code> and returns it as an <code>xs:string</code> item.
 : An optional encoding can be specified via <code>$encoding</code> .
 :
 : @error experr:ZIP0001 the specified path does not exist.
 : @error experr:ZIP0003 the operation fails for some other reason.
 :)
declare function zip:text-entry($uri as xs:string, $path as xs:string, $encoding as xs:string) as xs:string external;

(:~
 : Extracts the XML file at <code>$path</code> within the ZIP file located at <code>$uri</code> and returns it as a document node.
 :
 : @error experr:FODC0006 the addressed file is not well-formed.
 : @error experr:ZIP0001 the specified path does not exist.
 : @error experr:ZIP0003 the operation fails for some other reason.
 :)
declare function zip:xml-entry($uri as xs:string, $path as xs:string) as document-node() external;

(:~
 : Extracts the HTML file at <code>$path</code> within the ZIP file located at <code>$uri</code> and returns it as a document node. The file is converted to XML first if <a href="http://home.ccil.org/~cowan/XML/tagsoup/">Tagsoup</a> is found in the classpath.
 :
 : @error experr:FODC0006 the addressed file is not well-formed, or cannot be converted to correct XML.
 : @error experr:ZIP0001 the specified path does not exist.
 : @error experr:ZIP0003 the operation fails for some other reason.
 :)
declare function zip:html-entry($uri as xs:string, $path as xs:string) as document-node() external;

(:~
 : Generates an <a href="http://expath.org/spec/zip#spec-file-handling-elements-sect">ZIP XML Representation</a> of the hierarchical structure of the ZIP file located at <code>$uri</code> and returns it as an element node. The file contents are not returned by this function.
 :
 : @error experr:ZIP0001 the specified path does not exist.
 : @error experr:ZIP0003 the operation fails for some other reason.
 :)
declare function zip:entries($uri as xs:string) as element(zip:file) external;

(:~
 : Creates a new ZIP archive with the characteristics described by <code>$zip</code> , the <a href="http://expath.org/spec/zip#spec-file-handling-elements-sect">ZIP XML Representation</a> .
 :
 : @error experr:ZIP0001 an addressed file does not exist.
 : @error experr:ZIP0002 entries in the ZIP archive description are unknown, missing, or invalid.
 : @error experr:ZIP0003 the operation fails for some other reason.
 : @error experr:Serialization Errors an inlined XML fragment cannot be successfully serialized.
 :)
declare function zip:zip-file($zip as element(zip:file)) as empty-sequence() external;

(:~
 : Updates an existing ZIP archive or creates a modifed copy, based on the characteristics described by <code>$zip</code> , the <a href="http://expath.org/spec/zip#spec-file-handling-elements-sect">ZIP XML Representation</a> . The <code>$output</code> argument is the URI where the modified ZIP file is copied to.
 :
 : @error experr:ZIP0001 an addressed file does not exist.
 : @error experr:ZIP0002 entries in the ZIP archive description are unknown, missing, or invalid.
 : @error experr:ZIP0003 the operation fails for some other reason.
 : @error experr:Serialization Errors an inlined XML fragment cannot be successfully serialized.
 :)
declare function zip:update-entries($zip as element(zip:file), $output as xs:string) as empty-sequence() external;



