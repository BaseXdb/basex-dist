(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> adds some useful higher-order functions, additional to the <a href="http://docs.basex.org/wiki/Higher-Order_Functions">Higher-Order Functions</a> provided by the official specification.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace hof = "http://basex.org/modules/hof";

(:~
 : Returns its argument unchanged. This function isn't useful on its own, but can be used as argument to other higher-order functions.
 :)
declare function hof:id($expr as item()*) as item()* external;

(:~
 : Returns its first argument unchanged and ignores the second. This function isn't useful on its own, but can be used as argument to other higher-order functions, e.g. when a function combining two values is expected and one only wants to retain the left one.
 :)
declare function hof:const($expr as item()*, $ignored as item()*) as item()* external;

(:~
 : Works the same as <a href="http://docs.basex.org/wiki/Higher-Order_Functions#fn:fold-left.28.24f.2C_.24seed.2C_.24seq.29">fn:fold-left($seq, $seed, $f)</a> , but doesn't need a seed, because the sequence must be non-empty.
 :)
declare function hof:fold-left1($seq as item()+, $f as function(item()*, item()) as item()*) as item()* external;

(:~
 : Applies the function <code>$f</code> to the initial value <code>$start</code> until the predicate <code>$pred</code> applied to the result returns <code>true()</code> .
 :)
declare function hof:until($pred as function(item()*) as xs:boolean, $f as function(item()*) as item()*, $start as item()*) as item()* external;

(:~
 : Returns the <code>$k</code> items in <code>$seq</code> that are greatest when sorted by the result of <code>$f</code> applied to the item. The function is a much more efficient implementation of the following scheme: <pre class="brush:xquery"> ( for $x in $seq order by $sort-key($x) descending return $x )[position() &lt;= $k] </pre> 
 :)
declare function hof:top-k-by($seq as item()*, $sort-key as function(item()) as item(), $k as xs:integer) as item()* external;

(:~
 : Returns the <code>$k</code> items in <code>$seq</code> that are greatest when sorted in the order of the <i>less-than</i> predicate <code>$lt</code> . The function is a general version of <code>hof:top-k-by($seq, $sort-key, $k)</code> .
 :)
declare function hof:top-k-with($seq as item()*, $lt as function(item(), item()) as xs:boolean, $k as xs:integer) as item()* external;



