declare namespace _ = '_';

declare option db:chop 'no';
declare option output:method 'text';

(:~ Target directory. :)
declare variable $TARGET-DIR := 'modules/';
(:~ Root URL. :)
declare variable $ROOT-URL := 'http://docs.basex.org';
(:~ Test script :)
declare variable $TEST-XQ := 'test.xq';
(:~ Prefix of the module to parse (if empty, all modules will be parsed) :)
declare variable $PREFIX := () (:'admin':);

declare %private function _:serialize(
  $node as node()*)
  as xs:string
{
  string-join(
    for $n in $node return
    copy $c := $n
    modify (
      delete node $c/descendant-or-self::a/@*[name() != 'href'],
      delete node $c/descendant-or-self::br/@*,
      for $h in $c//@href[starts-with(., '/')]
      return replace value of node $h with ($ROOT-URL || $h)
    )
    return normalize-space(serialize($c))
  , ' ')
};

declare %private function _:header(
  $xml as node(),
  $url as xs:string)
  as xs:string
{
  '(:~' || out:nl() ||
  ' : ' || _:serialize(
    $xml//div[@id = 'bodyContent']/p[not(preceding-sibling::h1)]/node()
  ) ||
  out:nl() ||
  ' : ' || out:nl() ||
  ' : @author BaseX Team' || out:nl() ||
  ' : @see ' || $url || out:nl() ||
  ' :)' || out:nl()
};

declare %private function _:namespaces(
  $uris as xs:string*,
  $prefix as xs:string*)
  as xs:string*
{
  'module namespace ' || $prefix[1] || ' = "' || $uris[1] || '";' || out:nl(),
  for $i in 2 to count($uris)
  return 'declare namespace ' || $prefix[$i] || ' = "' || $uris[$i] || '";' || out:nl()
};

declare %private function _:functions(
  $xml as node(),
  $prefixes as xs:string*)
  as xs:string*
{
  for $table in $xml//table[preceding::h2]
  let $summary := $table/tr[td[1]/b = ('Summary', 'Properties')]/td[2]
  let $errors := $table/tr[td[1]/b = 'Errors']/td[2]/code
  for $signature in $table/tr[td[1]/b = 'Signatures']/td[2]/code
  return (
    '(:~' || out:nl() || string-join(
      $summary !
      tokenize(
        _:serialize(node()), ' *<br/> *'
      )[.] ! (' : ' || . || out:nl())
    ) ||
    (if($errors) then ' :' || out:nl() else ()) ||
    string-join(
      for $e in $errors
      return ' : @error ' || $prefixes[2] || ':' ||
        $e/b || ' ' ||
        replace(_:serialize($e/following-sibling::node()[1]), '^: ', '') ||
        out:nl()
    ) ||
    ' :)' || out:nl() ||
    'declare function ' || replace($signature, ', \.\.\.', '') || ' external;' || out:nl()
  )
};

declare %private function _:create(
  $url as xs:string,
  $xml as node())
{
  let $uris := $xml//a[ancestor::node()/text()[starts-with(., ' namespace')]]/@href/data()
  let $prefixes := $xml//code[../text()[starts-with(., ' prefix.')]]/text()
  return (
    _:header($xml, $url) ||
    string-join(_:namespaces($uris, $prefixes)) || out:nl() ||
    string-join(_:functions($xml, $prefixes), out:nl()) ||
    out:nl() ||
    '' || out:nl() ||
    '' || out:nl()
  )
};

(: Delete old files and create test directory :)
prof:dump('Parsing modules...'),
try { file:delete($TEST-XQ) } catch * { () },
try { file:delete($TARGET-DIR, true()) } catch * { () },
file:create-dir($TARGET-DIR),

(: Loop over all modules :)
let $url := $ROOT-URL || '/wiki/Module_Library'
let $xml := html:parse(fetch:binary($url), map { 'nons' := true() })
let $table := $xml//table
let $trs := $table/tr
for $tr in $trs[td]
let $prefix := normalize-space($tr/td[3])
where empty($PREFIX) or $prefix = $PREFIX
return
  let $link := $ROOT-URL || $tr/td[1]/a/@href
  let $xml := html:parse(fetch:binary($link), map { 'nons' := true() })
  let $xqdoc := _:create($url, $xml)
  let $uri := normalize-space($tr/td[4])
  return (
    prof:dump('* ' || $prefix || ': ' || $uri),
    file:write-text($TARGET-DIR || $prefix || '.xqm', $xqdoc),
    let $import := 'import module namespace ' || $prefix || ' = "' || $uri ||
      '" at "' || $TARGET-DIR || $prefix || '.xqm";'
    return file:append-text-lines($TEST-XQ, $import)
  ),

file:append-text-lines($TEST-XQ, '()'),

(: Check if all signatures are correct :)
prof:dump('Running test script...'),
xquery:invoke($TEST-XQ),
file:delete($TEST-XQ),

prof:dump('Successful')
