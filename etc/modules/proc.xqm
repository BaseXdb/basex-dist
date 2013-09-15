(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> provides functions for executing system commands from XQuery.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace proc = "http://basex.org/modules/proc";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Executes the specified command in a separate process and returns the result as string.
 : Additional command arguments may be specified via <code>$args</code> .
 : The result can be explicitly converted to a specified <code>$encoding</code> . If no encoding is specified, the system’s default encoding is used.
 :
 : @error bxerr:BXPRnnnn If the command results in an error, an XQuery error will be raised. Its code will consist of the letters
 : @error bxerr: and four digits with the command’s exit code.
 : @error bxerr:BXPR9999 the specified encoding does not exist or is not supported.
 :)
declare function proc:system($cmd as xs:string) as xs:string external;

(:~
 : Executes the specified command in a separate process and returns the result as string.
 : Additional command arguments may be specified via <code>$args</code> .
 : The result can be explicitly converted to a specified <code>$encoding</code> . If no encoding is specified, the system’s default encoding is used.
 :
 : @error bxerr:BXPRnnnn If the command results in an error, an XQuery error will be raised. Its code will consist of the letters
 : @error bxerr: and four digits with the command’s exit code.
 : @error bxerr:BXPR9999 the specified encoding does not exist or is not supported.
 :)
declare function proc:system($cmd as xs:string, $args as xs:string*) as xs:string external;

(:~
 : Executes the specified command in a separate process and returns the result as string.
 : Additional command arguments may be specified via <code>$args</code> .
 : The result can be explicitly converted to a specified <code>$encoding</code> . If no encoding is specified, the system’s default encoding is used.
 :
 : @error bxerr:BXPRnnnn If the command results in an error, an XQuery error will be raised. Its code will consist of the letters
 : @error bxerr: and four digits with the command’s exit code.
 : @error bxerr:BXPR9999 the specified encoding does not exist or is not supported.
 :)
declare function proc:system($cmd as xs:string, $args as xs:string*, $encoding as xs:string) as xs:string external;

(:~
 : Executes the specified command in a separate process and returns the result as element.
 : Additional command arguments may be specified via <code>$args</code> .
 : The result can be explicitly converted to a specified <code>$encoding</code> . If no encoding is specified, the system’s default encoding is used.
 : A result has the following structure:
 : <pre class="brush:xml"> &lt;result&gt; &lt;output&gt;...result...&lt;/output&gt; &lt;error&gt;0&lt;/error&gt; &lt;/result&gt; </pre> 
 :
 : @error bxerr:BXPR9999 the specified encoding does not exist or is not supported.
 :)
declare function proc:execute($cmd as xs:string) as element(result) external;

(:~
 : Executes the specified command in a separate process and returns the result as element.
 : Additional command arguments may be specified via <code>$args</code> .
 : The result can be explicitly converted to a specified <code>$encoding</code> . If no encoding is specified, the system’s default encoding is used.
 : A result has the following structure:
 : <pre class="brush:xml"> &lt;result&gt; &lt;output&gt;...result...&lt;/output&gt; &lt;error&gt;0&lt;/error&gt; &lt;/result&gt; </pre> 
 :
 : @error bxerr:BXPR9999 the specified encoding does not exist or is not supported.
 :)
declare function proc:execute($cmd as xs:string, $args as xs:string*) as element(result) external;

(:~
 : Executes the specified command in a separate process and returns the result as element.
 : Additional command arguments may be specified via <code>$args</code> .
 : The result can be explicitly converted to a specified <code>$encoding</code> . If no encoding is specified, the system’s default encoding is used.
 : A result has the following structure:
 : <pre class="brush:xml"> &lt;result&gt; &lt;output&gt;...result...&lt;/output&gt; &lt;error&gt;0&lt;/error&gt; &lt;/result&gt; </pre> 
 :
 : @error bxerr:BXPR9999 the specified encoding does not exist or is not supported.
 :)
declare function proc:execute($cmd as xs:string, $args as xs:string*, $encoding as xs:string) as element(result) external;



