(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions for manipulating maps. The following documentation is derived from an <a href="http://www.w3.org/TR/xpath-functions-30/">XQuery 3.0 Functions and Operators</a> working draft proposal written by <a href="http://en.wikipedia.org/wiki/Michael_Kay_(software_engineer)">Michael H. Kay</a> , and is not part of the official recommendation yet.
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace map = "http://www.w3.org/2005/xpath-functsions/map";

(:~
 : Returns the collation URI of the <i>map</i> supplied as <code>$map</code> .
 :)
declare function map:collation($map as map(*)) as xs:string external;

(:~
 : Returns true if the <i>map</i> supplied as <code>$map</code> contains an entry with a key equal to the supplied value of <code>$key</code> ; otherwise it returns false. The equality comparison uses the map's collation; no error occurs if the map contains keys that are not comparable with the supplied <code>$key</code> . <p>If the supplied key is <code>xs:untypedAtomic</code>, it is converted to <code>xs:string</code>. If the supplied key is the <code>xs:float</code> or <code>xs:double</code> value <code>NaN</code>, the function returns false. </p> 
 :)
declare function map:contains($map as map(*), $key as item()) as xs:boolean external;

(:~
 : Creates a new <i>map</i> containing a single entry. The collation of the new map is the default collation from the static context. The key of the entry in the new map is <code>$key</code> , and its associated value is <code>$value</code> . If the supplied key is <code>xs:untypedAtomic</code> , it is converted to <code>xs:string</code> . If the supplied key is the <code>xs:float</code> or <code>xs:double</code> value <code>NaN</code> , the supplied <code>$map</code> is returned unchanged. <p>The function <code>map:entry</code> is intended primarily for use in conjunction with the function <code> <a href="#map:new">map:new</a> </code>. For example, a map containing seven entries may be constructed like this: </p>  <pre class="brush:xquery"> map:new(( map:entry("Su", "Sunday"), map:entry("Mo", "Monday"), map:entry("Tu", "Tuesday"), map:entry("We", "Wednesday"), map:entry("Th", "Thursday"), map:entry("Fr", "Friday"), map:entry("Sa", "Saturday") )) </pre>  <p>Unlike the <code>map{ ... }</code> expression, this technique can be used to construct a map with a variable number of entries, for example: </p>  <pre class="brush:xquery">map:new(for $b in //book return map:entry($b/isbn, $b))</pre> 
 :)
declare function map:entry($key as item(), $value as item()*) as map(*) external;

(:~
 : Returns the value associated with a supplied key in a given map. This function attempts to find an entry within the <i>map</i> supplied as <code>$map</code> that has a key equal to the supplied value of <code>$key</code> . If there is such an entry, it returns the associated value; otherwise it returns an empty sequence. The equality comparison uses the map's collation; no error occurs if the map contains keys that are not comparable with the supplied <code>$key</code> . If the supplied key is <code>xs:untypedAtomic</code> , it is converted to <code>xs:string</code> . If the supplied key is the <code>xs:float</code> or <code>xs:double</code> value <code>NaN</code> , the function returns an empty sequence. <p>A return value of <code>()</code> from <code>map:get</code> could indicate that the key is present in the map with an associated value of <code>()</code>, or it could indicate that the key is not present in the map. The two cases can be distinguished by calling <code>map:contains</code>. Invoking the <i>map</i> as a function item has the same effect as calling <code>get</code>: that is, when <code>$map</code> is a map, the expression <code>$map($K)</code> is equivalent to <code>get($map, $K)</code>. Similarly, the expression <code>get(get(get($map, 'employee'), 'name'), 'first')</code> can be written as <code>$map('employee')('name')('first')</code>. </p> 
 :)
declare function map:get($map as map(*), $key as item()) as item()* external;

(:~
 : Returns a sequence containing all the key values present in a map. The function takes any <i>map</i> as its <code>$map</code> argument and returns the keys that are present in the map as a sequence of atomic values, in implementation-dependent order.
 :)
declare function map:keys($map as map(*)) as xs:anyAtomicType* external;

(:~
 : Constructs and returns a new map. The zero-argument form of the function returns an empty <i>map</i> whose collation is the default collation in the static context. It is equivalent to calling the one-argument form of the function with an empty sequence as the value of the first argument. <p>The one-argument form of the function returns a <i>map</i> that is formed by combining the contents of the maps supplied in the <code>$maps</code> argument. It is equivalent to calling the two-argument form of the function with the default collation from the static context as the second argument. The two-argument form of the function returns a <i>map</i> that is formed by combining the contents of the maps supplied in the <code>$maps</code> argument. The collation of the new map is the value of the <code>$coll</code> argument. The supplied maps are combined as follows: </p>  <ol> <li> There is one entry in the new map for each distinct key value present in the union of the input maps, where keys are considered distinct according to the rules of the <code>distinct-values</code> function with <code>$coll</code> as the collation. </li> <li> The associated value for each such key is taken from the last map in the input sequence <code>$maps</code> that contains an entry with this key. If this map contains more than one entry with this key (which can happen if its collation is different from that of the new map) then it is <i>implementation-dependent</i> which of them is selected. </li> </ol>  <p>There is no requirement that the supplied input maps should have the same or compatible types. The type of a map (for example <code>map(xs:integer, xs:string)</code>) is descriptive of the entries it currently contains, but is not a constraint on how the map may be combined with other maps. </p> 
 :)
declare function map:new() as map(*) external;

(:~
 : Constructs and returns a new map. The zero-argument form of the function returns an empty <i>map</i> whose collation is the default collation in the static context. It is equivalent to calling the one-argument form of the function with an empty sequence as the value of the first argument. <p>The one-argument form of the function returns a <i>map</i> that is formed by combining the contents of the maps supplied in the <code>$maps</code> argument. It is equivalent to calling the two-argument form of the function with the default collation from the static context as the second argument. The two-argument form of the function returns a <i>map</i> that is formed by combining the contents of the maps supplied in the <code>$maps</code> argument. The collation of the new map is the value of the <code>$coll</code> argument. The supplied maps are combined as follows: </p>  <ol> <li> There is one entry in the new map for each distinct key value present in the union of the input maps, where keys are considered distinct according to the rules of the <code>distinct-values</code> function with <code>$coll</code> as the collation. </li> <li> The associated value for each such key is taken from the last map in the input sequence <code>$maps</code> that contains an entry with this key. If this map contains more than one entry with this key (which can happen if its collation is different from that of the new map) then it is <i>implementation-dependent</i> which of them is selected. </li> </ol>  <p>There is no requirement that the supplied input maps should have the same or compatible types. The type of a map (for example <code>map(xs:integer, xs:string)</code>) is descriptive of the entries it currently contains, but is not a constraint on how the map may be combined with other maps. </p> 
 :)
declare function map:new($maps as map(*)*) as map(*) external;

(:~
 : Constructs and returns a new map. The zero-argument form of the function returns an empty <i>map</i> whose collation is the default collation in the static context. It is equivalent to calling the one-argument form of the function with an empty sequence as the value of the first argument. <p>The one-argument form of the function returns a <i>map</i> that is formed by combining the contents of the maps supplied in the <code>$maps</code> argument. It is equivalent to calling the two-argument form of the function with the default collation from the static context as the second argument. The two-argument form of the function returns a <i>map</i> that is formed by combining the contents of the maps supplied in the <code>$maps</code> argument. The collation of the new map is the value of the <code>$coll</code> argument. The supplied maps are combined as follows: </p>  <ol> <li> There is one entry in the new map for each distinct key value present in the union of the input maps, where keys are considered distinct according to the rules of the <code>distinct-values</code> function with <code>$coll</code> as the collation. </li> <li> The associated value for each such key is taken from the last map in the input sequence <code>$maps</code> that contains an entry with this key. If this map contains more than one entry with this key (which can happen if its collation is different from that of the new map) then it is <i>implementation-dependent</i> which of them is selected. </li> </ol>  <p>There is no requirement that the supplied input maps should have the same or compatible types. The type of a map (for example <code>map(xs:integer, xs:string)</code>) is descriptive of the entries it currently contains, but is not a constraint on how the map may be combined with other maps. </p> 
 :)
declare function map:new($maps as map(*)*, $coll as xs:string) as map(*) external;

(:~
 : Constructs a new map by removing an entry from an existing map. The collation of the new map is the same as the collation of the map supplied as <code>$map</code> . The entries in the new map correspond to the entries of <code>$map</code> , excluding any entry whose key is equal to <code>$key</code> . <p>No failure occurs if the input map contains no entry with the supplied key; the input map is returned unchanged </p> 
 :)
declare function map:remove($map as map(*), $key as item()) as map(*) external;

(:~
 : Returns a the number of entries in the supplied map. The function takes any <i>map</i> as its <code>$map</code> argument and returns the number of entries that are present in the map.
 :)
declare function map:size($map as map(*)) as xs:integer external;



