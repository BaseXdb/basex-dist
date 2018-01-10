(: Generates recipe snippets to update basex homebrew formula.
 :
 : /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/basex.rb
 :)
declare namespace _ = 'http://basex.org/homebrew-basex';

declare variable $basex-version external := "latest";

(: Produce snippet to insert into stable/devel section in homebrew recipe.
 :
 : $ brew edit basex 
 : or edit file at
 : /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/basex.rb
 :)
declare function _:recipe-section(
    $info as element(basex),
    $version as xs:string,
    $sha as xs:string
  )
{ 
  let $url := $info/url
  let $basex-version := $info/basex-version
  return
    if ($basex-version eq 'latest')
    then
      concat(
        '  devel do&#xa;',
        '    url "'     || $url || '"&#xa;',
        '    version "' || $version || '"&#xa;',
        '    sha256 "'  || $sha || '"&#xa;', 
        '  end&#xa;'
      )
    else
      concat(
        '  url "'     || $url || '"&#xa;',
        '  version "' || $version || '"&#xa;',
        '  sha256 "'  || $sha || '"&#xa;'
      )
};

(: Compute sha256 of zip file. :)
declare function _:sha256(
    $fname as xs:string
  )
{
  proc:execute("shasum", ('-a', '256', $fname))/output
  => replace($fname, '')
  => normalize-space()
};

(: Download basex zip. :)
declare function _:download(
    $fname as xs:string,
    $url as xs:string
  )
{
  if (file:exists($fname)) then () else
  proc:execute("/usr/local/bin/wget", ('-nv', $url))
};

(:
 : Compute devel homebrew version string from filename.
 :
 : 'BaseX87-20170929.135923.zip'
 : => 
 : '8.7-rc20170929.135923'
 :)
declare function _:homebrew-version(
      $info as element(basex)
  ) as xs:string
{
  if ($info/basex-version ne 'latest') then $info/basex-version else
  let $fname := $info/name
  let $v :=
    $fname
    => replace('BaseX', '')
    => replace('.zip', '')
    => tokenize('-')
  let $major := string-join(
      for $c in string-to-codepoints($v[1]) 
      return codepoints-to-string($c),
      '.'
    )
  let $minor := $v[2]
  return
    $major || '-rc' || $minor
};

(:
 : List release information.
 : by listing the location and filename of basex snapshot or stable zip.
 : @param basex version, e.g., 'latest', '8.6.7'
 :)
declare function _:release-info(
    $bxv as xs:string
  )
{
  let $ssh-r := proc:execute("/usr/bin/ssh"
                             , ('basex-web', 'ls ~/files/releases/' || $bxv || '/*.zip'))
  where $ssh-r/code eq '0'
  return
    let $fpath := normalize-space($ssh-r/output/text())
    let $fname := file:name($fpath)
    let $fdir  := file:parent($fpath)
    return
      element basex {
        element basex-version { $bxv },
        element path { $fdir },
        element name { $fname },
        element url  { "http://files.basex.org/releases/" || $bxv || "/" || $fname }
      }
};

let $info    := _:release-info($basex-version)     => trace('[t0]:')
let $version := _:homebrew-version($info)          => trace('[t1]:')
let $_sidefx := _:download($info/name, $info/url)  => trace('[t2]:')
let $sha256  := _:sha256($info/name)               => trace('[t3]:')
return
  _:recipe-section(
    $info,
    $version,
    $sha256
  )
