(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions for handling <i>streamable</i> items. In contrast to standard XQuery items, a streamable item contains only a reference to the actual data. The data itself will be retrieved if it is requested by an expression, or if the item is to be serialized. Hence, a streamable item only uses a few bytes, and no additional memory is occupied during serialization. The following BaseX functions return streamable items: Some functions are capable of consuming items in a <i>streamable</i> fashion: data will never be cached, but instead passed on to another target (file, the calling expression, etc.). The following streaming functions are currently available: The XQuery expression below serves as an example on how large files can be downloaded and written to a file with constant memory consumption:
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace stream = "http://basex.org/modules/stream";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Returns a materialized instance of the specified <code>$item</code> :
 : <ul> <li> if an item is streamable, its value will be retrieved, and a new item containing the value will be returned. </li> <li> other, non-streamable items will simply be passed through. </li> </ul>  <p>Materialization is advisable if a value is to be processed more than once, and is expensive to retrieve. It is get mandatory whenever a value is invalidated before it is requested (see the example below). </p> 
 :)
declare function stream:materialize($item as item()) as item() external;

(:~
 : Checks whether the specified <code>$item</code> is streamable.
 :)
declare function stream:is-streamable($item as item()) as item() external;



