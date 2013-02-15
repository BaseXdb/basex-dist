(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> provides functions that perform different hash operations.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace hash = "http://basex.org/modules/hash";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Computes the MD5 hash of the given <code>$value</code> , which may be of type xs:string or xs:base64Binary.
 :
 : @error bxerr:FORG0006 the specified value is neither a string nor a binary item.
 :)
declare function hash:md5($value as xs:anyAtomicType) as xs:base64Binary external;

(:~
 : Computes the SHA-1 hash of the given <code>$value</code> , which may be of type xs:string or xs:base64Binary.
 :
 : @error bxerr:FORG0006 the specified value is neither a string nor a binary item.
 :)
declare function hash:sha1($value as xs:anyAtomicType) as xs:base64Binary external;

(:~
 : Computes the SHA-256 hash of the given <code>$value</code> , which may be of type xs:string or xs:base64Binary.
 :
 : @error bxerr:FORG0006 the specified value is neither a string nor a binary item.
 :)
declare function hash:sha256($value as xs:anyAtomicType) as xs:base64Binary external;

(:~
 : Computes the hash of the given <code>$value</code> , using the specified <code>$algorithm</code> . The specified values may be of type xs:string or xs:base64Binary.
 : The following three algorihms are supported: <code>MD5</code> , <code>SHA-1</code> , and <code>SHA-256</code> .
 :
 : @error bxerr:HASH0001 the specified hashing algorithm is unknown.
 : @error bxerr:FORG0006 the specified value is neither a string nor a binary item.
 :)
declare function hash:hash($value as xs:anyAtomicType, $algorithm as xs:string) as xs:base64Binary external;



