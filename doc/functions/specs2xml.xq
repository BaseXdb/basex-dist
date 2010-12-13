declare default element namespace "http://www.w3.org/1999/xhtml";

let $functions :=
(for $f in doc('xq11')//div[@class = ('div2','div3')][.//text() = 'Summary'][matches(*[1]/text(), 'fn:|math:')]
let $name := replace($f/*[1]/text(), ".*(fn:|math:)", "", "s")
(: order by lower-case($name) :)

return
<function name="{ $name }"
          type="{ $f/descendant::code[@class='return-type'][1]/text() }">{
  for $s in $f//div[@class='proto']
  return <signature>{
    for $a in $s//code[@class='arg']
    return <arg name="{ replace($a/text(), '^\$', '') }"
                type="{
                let $t := $a/following-sibling::code[@class='type'][1]
                return if($t) then $t else $a/../..//code[@class='type']
                }"/>
  }</signature>,
  <summary>{ $f//dl/dt[. = 'Summary']/following-sibling::dd[1]/p/node() }</summary>,
  for $r in $f//dl/dt[. = 'Rules']/following-sibling::dd[1]/p
  return <rule>{ $r/node() }</rule>,
  for $r in $f//dl/dt[. = 'Examples']/following-sibling::dd[1]/p
  return <example>{ $r/node() }</example>

}</function>)

return <functions name="Functions" pref="fn">{
  $functions
}</functions>
