declare variable $test := false();
declare variable $module := 'db';
declare option output:method "xhtml";
declare option output:indent "no";

(: Converts the XML documentation to an HTML representation. :)
declare function local:convert($doc as document-node()) as node()* {
  local:links(<p>{ (
    local:desc($doc), local:list($doc), local:footer($doc)) }</p>
  )/node()
};

(: Converts links in the specified result. :)
declare function local:links($nodes as node()*) as node()* {
  for $node in $nodes
  return
    copy $desc := $node
    modify for $a in $desc//a
           return replace node $a with
             text { concat('[', $a/@href, ' ', $a, ']') }
    return $desc
};

(: Returns the description of the function. :)
declare function local:desc($doc as document-node()) as node()* {
 ($doc/functions/text/node(), text { "

" })
};

(: Lists all functions. :)
declare function local:list($doc as document-node()) as node()* {
  let $pref := $doc/functions/@pref
  for $f in $doc//function
  (: order by $f/@name :)
  return (
    text { concat('==', $pref, ':', $f/@name, '==') },
    text { "
{|
|-
| valign='top' width='90' | '''Signatures'''
|"}, local:signatures($f, $pref), text { "
|-
| valign='top' | '''Summary'''
|"}, $f/summary/node(), text { "
"}, local:check($f/rule, (text { "|-
| valign='top' | '''Rules'''
|" }, local:rules($f), text { "
"})), local:check($f/example, (text { "|-
| valign='top' | '''Examples'''
|" }, local:examples($f), text { "
"})), local:check($f/error, (text { "|-
| valign='top' | '''Errors'''
|" }, local:errors($f), text { "
"})), text { "|}

"
})
};

declare function local:check($iff as node()*, $result as node()*) as node()* {
  if($iff) then $result else ()
};

(: Returns the signatures of the specified function. :)
declare function local:signatures($function as element(), $pref as xs:string) as node()* {
  for $s in $function/signature
  return (<code><b>{ concat($pref, ':', $function/@name) }</b>({
    string-join(
      for $a in $s/arg return concat('$', $a/@name, ' as ', $a/@type),
      ', ')
   }) as { data($function/@type) }</code>,<br />)
};

(: Returns the rules of the specified function. :)
declare function local:rules($function as element()) as node()* {
  for $r in $function/rule
  return ($r/node(), <br/>)
};

(: Returns the examples of the specified function. :)
declare function local:examples($function as element()) as node()* {
  for $e in $function/example
  return ($e/node(), <br/>)
};

(: Returns the errors of the specified function. :)
declare function local:errors($function as element()) as node()* {
  for $e in $function/error
  return (<b>[{ data($e/@code) }]</b>, text { ' ' }, $e/node(), <br/>)
};

(: Returns the footer. :)
declare function local:footer($doc as document-node()) as node() {
  text { '[[Category:XQuery]]' }
};

(: Parses all input files and generates the result files. :)
for $file at $pos in file:list('.', false(), '*.xml')
let $doc := doc($file)
let $pref := $doc/functions/@pref
let $name := $doc/functions/@name
let $out := local:convert($doc)
let $result := concat($name, ' Functions.', 'wiki')
where not($module) or $pref eq $module
return
  if($test)
  then $out
  else (
    file:write($result, $out, <method>xhtml</method>),
    text { concat('- ', $result, '
')}
)
