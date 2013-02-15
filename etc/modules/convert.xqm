(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions to convert data between different formats.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace convert = "http://basex.org/modules/convert";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Converts the specifed binary data (xs:base64Binary, xs:hexBinary) to a string.
 : The UTF-8 default encoding can be overwritten with the optional <code>$encoding</code> argument.
 :
 : @error bxerr:BXCO0001 The input is an invalid XML string, or the wrong encoding has been specified.
 : @error bxerr:BXCO0002 The specified encoding is invalid or not supported.
 :)
declare function convert:binary-to-string($bytes as basex:binary) as xs:string external;

(:~
 : Converts the specifed binary data (xs:base64Binary, xs:hexBinary) to a string.
 : The UTF-8 default encoding can be overwritten with the optional <code>$encoding</code> argument.
 :
 : @error bxerr:BXCO0001 The input is an invalid XML string, or the wrong encoding has been specified.
 : @error bxerr:BXCO0002 The specified encoding is invalid or not supported.
 :)
declare function convert:binary-to-string($bytes as basex:binary, $encoding as xs:string) as xs:string external;

(:~
 : Converts the specified string to a <code>xs:base64Binary</code> item. If the default encoding is chosen, conversion will be cheap, as both <code>xs:string</code> and <code>xs:base64Binary</code> items are internally represented as byte arrays.
 : The UTF-8 default encoding can be overwritten with the optional <code>$encoding</code> argument.
 :
 : @error bxerr:BXCO0001 The input cannot be represented in the specified encoding.
 : @error bxerr:BXCO0002 The specified encoding is invalid or not supported.
 :)
declare function convert:string-to-base64($input as xs:string) as xs:base64Binary external;

(:~
 : Converts the specified string to a <code>xs:base64Binary</code> item. If the default encoding is chosen, conversion will be cheap, as both <code>xs:string</code> and <code>xs:base64Binary</code> items are internally represented as byte arrays.
 : The UTF-8 default encoding can be overwritten with the optional <code>$encoding</code> argument.
 :
 : @error bxerr:BXCO0001 The input cannot be represented in the specified encoding.
 : @error bxerr:BXCO0002 The specified encoding is invalid or not supported.
 :)
declare function convert:string-to-base64($input as xs:string, $encoding as xs:string) as xs:base64Binary external;

(:~
 : Converts the specified string to a <code>xs:hexBinary</code> item. If the default encoding is chosen, conversion will be cheap, as both <code>xs:string</code> and <code>xs:hexBinary</code> items are internally represented as byte arrays.
 : The UTF-8 default encoding can be overwritten with the optional <code>$encoding</code> argument.
 :
 : @error bxerr:BXCO0001 The input cannot be represented in the specified encoding.
 : @error bxerr:BXCO0002 The specified encoding is invalid or not supported.
 :)
declare function convert:string-to-hex($input as xs:string) as xs:hexBinary external;

(:~
 : Converts the specified string to a <code>xs:hexBinary</code> item. If the default encoding is chosen, conversion will be cheap, as both <code>xs:string</code> and <code>xs:hexBinary</code> items are internally represented as byte arrays.
 : The UTF-8 default encoding can be overwritten with the optional <code>$encoding</code> argument.
 :
 : @error bxerr:BXCO0001 The input cannot be represented in the specified encoding.
 : @error bxerr:BXCO0002 The specified encoding is invalid or not supported.
 :)
declare function convert:string-to-hex($input as xs:string, $encoding as xs:string) as xs:hexBinary external;

(:~
 : Converts the specified byte sequence to a <code>xs:base64Binary</code> item. Conversion is cheap, as <code>xs:base64Binary</code> items are internally represented as byte arrays.
 :
 : @error bxerr:BXCO0001 The input cannot be represented in the specified encoding.
 : @error bxerr:BXCO0002 The specified encoding is invalid or not supported.
 :)
declare function convert:bytes-to-base64($input as xs:byte*) as xs:base64Binary external;

(:~
 : Converts the specified byte sequence to a <code>xs:hexBinary</code> item. Conversion is cheap, as <code>xs:hexBinary</code> items are internally represented as byte arrays.
 :
 : @error bxerr:BXCO0001 The input cannot be represented in the specified encoding.
 : @error bxerr:BXCO0002 The specified encoding is invalid or not supported.
 :)
declare function convert:string-to-hex($input as xs:byte*) as xs:hexBinary external;

(:~
 : Returns the specified binary data (xs:base64Binary, xs:hexBinary) as a sequence of bytes.
 :)
declare function convert:binary-to-bytes($bin as basex:binary) as xs:byte* external;

(:~
 : Converts <code>$num</code> to base <code>$base</code> , interpreting it as a 64-bit unsigned integer.
 : The first <code>$base</code> elements of the sequence <code>'0',..,'9','a',..,'z'</code> are used as digits.
 : Valid bases are <code>2, .., 36</code> .
 :)
declare function convert:integer-to-base($num as xs:integer, $base as xs:integer) as xs:string external;

(:~
 : Decodes an <code>xs:integer</code> from <code>$str</code> , assuming that it's encoded in base <code>$base</code> .
 : The first <code>$base</code> elements of the sequence <code>'0',..,'9','a',..,'z'</code> are allowed as digits, case doesn't matter.
 : Valid bases are 2 - 36.
 : If <code>$str</code> contains more than 64 bits of information, the result is truncated arbitarily.
 :)
declare function convert:integer-from-base($str as xs:string, $base as xs:integer) as xs:integer external;

(:~
 : Converts the specified number of milliseconds since 1 Jan 1970 to an item of type xs:dateTime.
 :)
declare function convert:integer-to-dateTime($ms as xs:integer) as xs:dateTime external;

(:~
 : Converts the specified item of type xs:dateTime to the number of milliseconds since 1 Jan 1970.
 :)
declare function convert:dateTime-to-integer($dateTime as xs:dateTime) as xs:integer external;

(:~
 : Converts the specified number of milliseconds to an item of type xs:dayTimeDuration.
 :)
declare function convert:integer-to-dayTime($ms as xs:integer) as xs:dayTimeDuration external;

(:~
 : Converts the specified item of type xs:dayTimeDuration to milliseconds represented by an integer.
 :)
declare function convert:dayTime-to-integer($dayTime as xs:dayTimeDuration) as xs:integer external;



