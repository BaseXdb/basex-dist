(:~
 : This script creates xqdoc files from the module documentation of the BaseX Wiki.
 : @author Christian Gruen, BaseX Team
 :)
declare variable $BASE := 'http://docs.basex.org';
declare variable $ROOT-DIR := file:base-dir() || 'xqdoc/';

(:~
 : Serializes the specified nodes. Normalizes links and newlines.
 : @param  $nodes  nodes to be serialized
 : @param  $url    page url
 : @return string
 :)
declare %private function local:serialize(
  $nodes  as node()*,
  $url   as xs:string
) as xs:string {
  normalize-space(serialize(
    $nodes update {
      descendant-or-self::a/@href ! (
        if(starts-with(., '/')) then replace value of node . with $BASE || . else
        if(starts-with(., '#')) then replace value of node . with $url || .
      ),
      delete node descendant-or-self::a/@*[name() != 'href'],
      delete node descendant-or-self::br/@*
    }
  ))
};

(:~
 : Creates the xqdoc header.
 : @param  $xml  page contents
 : @param  $url  page url
 : @return string
 :)
declare %private function local:header(
  $xml  as node(),
  $url  as xs:string
) as xs:string {
  '(:~ ' || out:nl() ||
  ' : ' || local:serialize(
    $xml//div[@id = 'bodyContent']/p[not(preceding-sibling::h1)]/node(), $url
  ) || out:nl() ||
  ' :' || out:nl() ||
  ' : @author BaseX Team' || out:nl() ||
  ' : @see ' || $url || out:nl() ||
  ' :)'
};

(:~
 : Creates namespace declarations.
 : @param  $uris      namespace URIs
 : @param  $prefixes  namespace prefixed
 : @return string
 :)
declare %private function local:namespaces(
  $uris      as xs:string*,
  $prefixes  as xs:string*
) as xs:string* {
  'module namespace ' || $prefixes[1] || ' = "' || $uris[1] || '";',
  for $i in 2 to count($uris)
  return 'declare namespace ' || $prefixes[$i] || ' = "' || $uris[$i] || '";',
  ''
};

(:~
 : Creates an xqdoc section for a function.
 : @param  $xml     page contents
 : @param  $prefix  prefix of error namespace
 : @param  $url     page url
 : @return string
 :)
declare %private function local:functions(
  $xml     as node(),
  $prefix  as xs:string?,
  $url     as xs:string
) as xs:string* {
  for $table in $xml//table[preceding::h2]
  let $summary := $table/tr[td[1]/b = 'Summary']/td[2]/node()
  for $signature in $table/tr[td[1]/b = 'Signatures']/td[2]/code
  let $anns := (
    for $param in tokenize(replace($signature/text(), '^\(|\) .*', ''), ', ')
    let $tokens := tokenize($param, ' as ', 'q')
    return ' : @param ' || $tokens[1] || ' value of type ' || $tokens[2],

    for $return in replace($signature/text(), '^.* as ', '')[. != 'empty-sequence()']
    return ' : @return value of type ' || $return,

    for $error in $table/tr[td[1]/b = 'Errors']/td[2]/code
      [not(preceding-sibling::node()[1] instance of text())]
    let $code := $error/b ! (contains(., ':') ?? . !! ($prefix || ':' || .))
    let $message := (
      let $fs := $error/following-sibling::node()
      let $br := ($fs/self::br)[1]
      return $fs[empty($br) or . << $br]
    )
    return ' : @error ' || $code || ' ' ||
      replace(local:serialize($message, $url), '^: ', '')
  )
  return (
    '(:~ ' || out:nl() ||
    ' : ' || string-join(local:serialize($summary, $url)) || out:nl() ||
    (' :' || out:nl() || string-join($anns, out:nl()) || out:nl())[exists($anns)] ||
    ' :)' || out:nl() ||
    'declare function ' || $signature || ' external;' || out:nl()
  )
};

(:~
 : Creates an xqdoc page.
 : @param  $xml  page contents
 : @param  $url  page url
 : @return string
 :)
declare %private function local:page(
  $xml  as node(),
  $url  as xs:string
) as xs:string {
  let $uris := $xml//code[starts-with(following-sibling::text()[1], ' namespace')]/text()
  let $prefixes := $xml//code[starts-with(following-sibling::text()[1], ' prefix.')]/text()
  let $error := (
    for-each-pair($uris, $prefixes, function($uri, $prefix) {
      if(contains($uri, 'error')) then $prefix else ()
    }),
    $prefixes[1]
  )[1]
  return string-join((
    local:header($xml, $url),
    local:namespaces($uris, $prefixes),
    local:functions($xml, $error, $url)
  ), out:nl())
};

(:~
 : Parses a URL and writes an xqdoc page.
 : @param  $xml  page contents
 : @param  $url  page url
 : @return string
 :)
declare %private function local:create(
  $url  as xs:string
) as empty-sequence() {
  let $xml := html:parse(fetch:binary($BASE || $url))
  let $prefix := ($xml//code[starts-with(following-sibling::text()[1], ' prefix.')]/text())[1]
  let $xqdoc := local:page($xml, $url)
  return file:write-text($ROOT-DIR || $prefix || '.xqm', $xqdoc)
};

file:create-dir($ROOT-DIR),

let $xml := html:parse(fetch:binary($BASE || '/wiki/Module_Library'))
for $url in $xml//td/a[@title]/@href
return (
  local:create($url),
  prof:sleep(50)
)
