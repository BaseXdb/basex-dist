declare variable $test := false();
declare variable $module := '';
declare option output:method "xhtml";

(: Converts the XML documentation to an HTML representation. :)
declare function local:convert($doc as document-node()) as node()* {
  local:header($doc),
  local:desc($doc),
  local:links($doc),
  local:list($doc),
  local:footer($doc)
};

(: Returns the PHP header. :)
declare function local:header($doc as document-node()) as node() {
  processing-instruction php { concat('
$top = "documentation";
$ntop = "xquery";
$ntitle = "', $doc/functions/@name, ' Functions";
include("inc/header.inc");
')
  }
};

(: Returns the description of the function. :)
declare function local:desc($doc as document-node()) as node() {
  <p>{ $doc/functions/text/node() }</p>
};

(: Lists all functions. :)
declare function local:links($doc as document-node()) as node()+ {
  (<h2>Overview</h2>,
  <p>{
    let $pref := $doc/functions/@pref
    let $names :=
      for $f in $doc//function
      let $name := data($f/@name)
      order by lower-case($name)
      return $name
    for $name at $pos in $names
    return (
      if($pos = 1) then '' else ' | ',
      <a href="{ concat('xq', $pref, '#', $name) }">{ $name }</a>
    )
  }</p>)
};

(: Lists all functions. :)
declare function local:list($doc as document-node()) as node()* {
  let $pref := $doc/functions/@pref
  for $f in $doc//function
  (: order by $f/@name :)
  return (
   <a name="{ $f/@name }"/>,
   <h2>{ concat($pref, ':', $f/@name) }</h2>,
   <table>{
     <tr>
       <td width='90'><b>Signatures</b></td>
       <td>{ local:signatures($f, $pref) }</td>
     </tr>,
     <tr>
       <td><b>Summary</b></td>
       <td>{ $f/summary/node() }</td>
     </tr>,
     local:check($f/rule,
       <tr>
         <td><b>Rules</b></td>
         <td>{ local:rules($f) }</td>
       </tr>),
     local:check($f/example,
       <tr>
         <td><b>Examples</b></td>
         <td>{ local:examples($f) }</td>
       </tr>),
     local:check($f/error,
       <tr>
         <td><b>Errors</b></td>
         <td>{ local:errors($f) }</td>
       </tr>)
    }
   </table>)
};

declare function local:check($iff as node()*, $result as node()) as node()* {
  if($iff) then $result else ()
};

(:
    <a name="{ $pref }"/>,
    local:sig($f, $pref),
    $f/text/node() :)

(: Returns the signatures of the specified function. :)
declare function local:signatures($function as element(), $pref as xs:string) as node()* {
  for $s in $function/signature
  return (<code><b>{ concat($pref, ':', $function/@name) }</b>({
    string-join(
      for $a in $s/arg return concat('$', $a/@name, ' as ', $a/@type),
      ', ')
   }) as { data($function/@type) }</code>,
  <br/>)
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

(: Returns the PHP footer. :)
declare function local:footer($doc as document-node()) as node() {
  processing-instruction php {
    'include("inc/footer.inc");'
  }
};

(: Parses all XML files and generates the PHP files. :)
for $file at $pos in file:files('.', false(), '*.xml')
let $doc := doc($file)
let $pref := $doc/functions/@pref
let $out := local:convert($doc)
let $file := concat('xq', $pref, '.', 'php')
where not($module) or contains($file, $module)
return
  if($test)
  then $out
  else (
    if(file:file-exists($file)) then 
    file:delete($file) else ()
   ,file:write($file, $out, <method>xhtml</method>),
    concat('Writing ', $file, '... 
  ')
)
