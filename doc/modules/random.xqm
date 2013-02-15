(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains non-deterministic functions for returning random values.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace random = "http://basex.org/modules/random";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns a double value between 0.0 (inclusive) and 1.0 (exclusive).
 :)
declare function random:double() as xs:double external;

(:~
 : Returns an integer value, either in the whole integer range or between 0 (inclusive) and the given maximum (exclusive)
 :)
declare function random:integer() as xs:integer external;

(:~
 : Returns an integer value, either in the whole integer range or between 0 (inclusive) and the given maximum (exclusive)
 :)
declare function random:integer($max as xs:integer) as xs:integer external;

(:~
 : Returns a sequence with <code>$num</code> double values between 0.0 (inclusive) and 1.0 (exclusive). The random values are created using the initial seed given in <code>$seed</code> .
 :)
declare function random:seeded-double($seed as xs:integer, $num as xs:integer) as xs:double* external;

(:~
 : Returns a sequence with <code>$num</code> integer values, either in the whole integer range or between 0 (inclusive) and the given maximum (exclusive). The random values are created using the initial seed given in <code>$seed</code> .
 :)
declare function random:seeded-integer($seed as xs:integer, $num as xs:integer) as xs:integer* external;

(:~
 : Returns a sequence with <code>$num</code> integer values, either in the whole integer range or between 0 (inclusive) and the given maximum (exclusive). The random values are created using the initial seed given in <code>$seed</code> .
 :)
declare function random:seeded-integer($seed as xs:integer, $num as xs:integer, $max as xs:integer) as xs:integer* external;

(:~
 : Returns a sequence with <code>$num</code> double values. The random values are Gaussian (i.e. normally) distributed with the mean 0.0. and the derivation 1.0.
 :)
declare function random:gaussian($num as xs:integer) as xs:double* external;

(:~
 : Creates a random universally unique identifier (UUID), represented as 128-bit value.
 :)
declare function random:uuid() as xs:string external;



