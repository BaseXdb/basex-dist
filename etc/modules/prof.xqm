(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains various testing, profiling and helper functions.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace prof = "http://basex.org/modules/prof";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Measures the time needed to evaluate <code>$expr</code> and sends it to standard error or, if the GUI is used, to the Info View.
 : If <code>$cache</code> is set to <code>true()</code> , the result will be temporarily cached. This way, a potential iterative execution of the expression (which often yields different memory usage) is blocked.
 : A third, optional argument <code>$label</code> may be specified to tag the profiling result.
 : The function is <i>non-deterministic</i> : evaluation order will be preserved by the compiler.
 :)
declare function prof:time($expr as item()) as item()* external;

(:~
 : Measures the time needed to evaluate <code>$expr</code> and sends it to standard error or, if the GUI is used, to the Info View.
 : If <code>$cache</code> is set to <code>true()</code> , the result will be temporarily cached. This way, a potential iterative execution of the expression (which often yields different memory usage) is blocked.
 : A third, optional argument <code>$label</code> may be specified to tag the profiling result.
 : The function is <i>non-deterministic</i> : evaluation order will be preserved by the compiler.
 :)
declare function prof:time($expr as item(), $cache as xs:boolean) as item()* external;

(:~
 : Measures the time needed to evaluate <code>$expr</code> and sends it to standard error or, if the GUI is used, to the Info View.
 : If <code>$cache</code> is set to <code>true()</code> , the result will be temporarily cached. This way, a potential iterative execution of the expression (which often yields different memory usage) is blocked.
 : A third, optional argument <code>$label</code> may be specified to tag the profiling result.
 : The function is <i>non-deterministic</i> : evaluation order will be preserved by the compiler.
 :)
declare function prof:time($expr as item(), $cache as xs:boolean, $label as xs:string) as item()* external;

(:~
 : Measures the memory allocated by evaluating <code>$expr</code> and sends it to standard error or, if the GUI is used, to the Info View.
 : If <code>$cache</code> is set to <code>true()</code> , the result will be temporarily cached. This way, a potential iterative execution of the expression (which often yields different memory usage) is blocked.
 : A third, optional argument <code>$label</code> may be specified to tag the profiling result.
 : The function is <i>non-deterministic</i> : evaluation order will be preserved by the compiler.
 :)
declare function prof:mem($expr as item()) as item()* external;

(:~
 : Measures the memory allocated by evaluating <code>$expr</code> and sends it to standard error or, if the GUI is used, to the Info View.
 : If <code>$cache</code> is set to <code>true()</code> , the result will be temporarily cached. This way, a potential iterative execution of the expression (which often yields different memory usage) is blocked.
 : A third, optional argument <code>$label</code> may be specified to tag the profiling result.
 : The function is <i>non-deterministic</i> : evaluation order will be preserved by the compiler.
 :)
declare function prof:mem($expr as item(), $cache as xs:boolean) as item()* external;

(:~
 : Measures the memory allocated by evaluating <code>$expr</code> and sends it to standard error or, if the GUI is used, to the Info View.
 : If <code>$cache</code> is set to <code>true()</code> , the result will be temporarily cached. This way, a potential iterative execution of the expression (which often yields different memory usage) is blocked.
 : A third, optional argument <code>$label</code> may be specified to tag the profiling result.
 : The function is <i>non-deterministic</i> : evaluation order will be preserved by the compiler.
 :)
declare function prof:mem($expr as item(), $cache as xs:boolean, $label as xs:string) as item()* external;

(:~
 : Sleeps for the specified number of milliseconds.
 : The function is <i>non-deterministic</i> : evaluation order will be preserved by the compiler.
 :)
declare function prof:sleep($ms as xs:integer) as empty-sequence() external;

(:~
 : Returns a human-readable representation of the specified <code>$number</code> .
 :)
declare function prof:human($number as xs:integer) as xs:string external;

(:~
 : Dumps a serialized representation of <code>$expr</code> to <code>STDERR</code> , optionally prefixed with <code>$label</code> , and returns an empty sequence. If the GUI is used, the dumped result is shown in the <a href="http://docs.basex.org/wiki/Graphical_User_Interface#Visualizations">Info View</a> .
 : In contrast to <code>fn:trace()</code> , the consumed expression will not be passed on.
 :)
declare function prof:dump($expr as item()) as empty-sequence() external;

(:~
 : Dumps a serialized representation of <code>$expr</code> to <code>STDERR</code> , optionally prefixed with <code>$label</code> , and returns an empty sequence. If the GUI is used, the dumped result is shown in the <a href="http://docs.basex.org/wiki/Graphical_User_Interface#Visualizations">Info View</a> .
 : In contrast to <code>fn:trace()</code> , the consumed expression will not be passed on.
 :)
declare function prof:dump($expr as item(), $label as xs:string) as empty-sequence() external;

(:~
 : Returns the number of milliseconds passed since 1970/01/01 UTC. The granularity of the value depends on the underlying operating system and may be larger. For example, many operating systems measure time in units of tens of milliseconds.
 : In contrast to <code>fn:current-time()</code> , the function is <i>non-deterministic</i> , as it returns different values every time it is called. Its evaluation order will be preserved by the compiler.
 :)
declare function prof:current-ms() as xs:integer external;

(:~
 : Returns the current value of the most precise available system timer in nanoseconds.
 : In contrast to <code>fn:current-time()</code> , the function is <i>non-deterministic</i> , as it returns different values every time it is called. Its evaluation order will be preserved by the compiler.
 :)
declare function prof:current-ns() as xs:integer external;

(:~
 : Swallows all items of the specified <code>$value</code> and returns an empty sequence. This function is helpful if some code needs to be evaluated and if the actual result is irrelevant.
 : The function is <i>non-deterministic</i> : evaluation order will be preserved by the compiler.
 :)
declare function prof:void($value as item()*) as empty-sequence() external;



