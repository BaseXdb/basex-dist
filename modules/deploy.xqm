(:~
 : Functions for deploying a new snapshot or release:
 : the Maven modules that changed since the last run are deployed, the release files are
 : created from the built artifacts and uploaded to the server.
 : The server login and target directory are read from the environment variables
 : BASEX_DEPLOY_SERVER (e.g. "user@host") and BASEX_DEPLOY_TARGET (e.g. "~/html/releases").
 :
 : @author BaseX Team, BSD License
 :)
module namespace deploy = 'http://basex.org/dist/deploy';

import module namespace release = 'http://basex.org/dist/release' at 'release.xqm';

(:~ Server login. :)
declare %private variable $deploy:SERVER := environment-variable('BASEX_DEPLOY_SERVER')
  otherwise error((), 'BASEX_DEPLOY_SERVER is not set.');
(:~ Release directory on the server. :)
declare %private variable $deploy:TARGET := environment-variable('BASEX_DEPLOY_TARGET')
  otherwise error((), 'BASEX_DEPLOY_TARGET is not set.');
(:~ Working tree of the last Maven deployment. :)
declare %private variable $deploy:STATE  := $release:DIST || 'deploy.last';

(:~
 : Deploys a new snapshot or release.
 : @param $release  deploy a release instead of a snapshot
 : @param $dry      print commands instead of executing them
 :)
declare function deploy:run(
  $release  as xs:boolean,
  $dry      as xs:boolean
) as empty-sequence() {
  message(`* Target: { $deploy:SERVER }:{ $deploy:TARGET }`),
  if ($release and $release:SNAPSHOT) {
    error((), `Not a release version: { $release:VERSION }`)
  },
  deploy:maven($dry),
  if (not($dry)) {
    release:create('war')
  },
  deploy:upload($release, $dry)
};

(:~
 : Runs an external command and raises an error if it fails.
 : @param $command   command
 : @param $args      arguments
 : @param $dry       print the command instead of executing it
 : @param $attempts  number of attempts
 :)
declare %private function deploy:exec(
  $command   as xs:string,
  $args      as xs:string*,
  $dry       as xs:boolean,
  $attempts  as xs:integer  := 3
) as empty-sequence() {
  message(string-join(($command, $args), ' ')),
  if (not($dry)) {
    let $result := proc:execute($command, $args, { 'dir': $release:FILES })
    return (
      message(string($result/output)),
      if ($result/code != '0') {
        if ($attempts > 1) then (
          deploy:exec($command, $args, $dry, $attempts - 1)
        ) else (
          error((), `{ $command } failed: { $result/error }`)
        )
      }
    )
  }
};

(:~
 : Runs commands on the server.
 : @param $commands  commands to be chained
 : @param $dry       print the command instead of executing it
 :)
declare %private function deploy:ssh(
  $commands  as xs:string+,
  $dry       as xs:boolean
) as empty-sequence() {
  deploy:exec('ssh', ($deploy:SERVER, string-join($commands, ' &amp;&amp; ')), $dry)
};

(:~
 : Uploads files to the server.
 : @param $names  names of the files
 : @param $dir    target directory
 : @param $dry    print the commands instead of executing them
 :)
declare %private function deploy:scp(
  $names  as xs:string*,
  $dir    as xs:string,
  $dry    as xs:boolean
) as empty-sequence() {
  for $name in $names
  return deploy:exec('scp', ($name, `{ $deploy:SERVER }:{ $dir }/`), $dry)
};

(:~
 : Returns the suffix of a file name.
 : @param $name  file name
 : @return suffix (e.g. "zip")
 :)
declare %private function deploy:suffix(
  $name  as xs:string
) as xs:string {
  replace($name, '^.*\.', '')
};

(:~
 : Runs Git in the BaseX project.
 : @param $args  arguments
 : @param $env   environment variables (empty: inherited)
 : @return output
 :)
declare %private function deploy:git(
  $args  as xs:string+,
  $env   as map(xs:string, xs:string)  := {}
) as xs:string {
  proc:system('git', $args, { 'dir': $release:BASEX, 'environment': $env })
};

(:~
 : Stores the working tree of the BaseX project, including untracked files, as Git tree.
 : @return tree hash
 :)
declare %private function deploy:tree() as xs:string {
  let $index := file:create-temp-file('deploy', '.index')
  let $env := map:merge((
    for $name in available-environment-variables()
    return { $name: environment-variable($name) },
    { 'GIT_INDEX_FILE': $index }
  ))
  return (
    file:copy($release:BASEX || '.git/index', $index),
    deploy:git(('add', '-A'), $env) => void(),
    normalize-space(deploy:git('write-tree', $env)),
    file:delete($index)
  )
};

(:~
 : Returns the artifact id of a Maven module.
 : @param $module  module directory
 : @return artifact id
 :)
declare %private function deploy:artifact(
  $module  as xs:string
) as xs:string {
  string(doc(`{ $release:BASEX }{ $module }/pom.xml`)/*:project/*:artifactId)
};

(:~
 : Returns the Maven modules that need to be deployed.
 : @param $tree  current working tree
 : @return modules
 :)
declare %private function deploy:modules(
  $tree  as xs:string
) as xs:string* {
  (: changed files; first run or unknown tree: all modules :)
  let $paths := if (file:exists($deploy:STATE)) then (
    try {
      let $last := normalize-space(file:read-text($deploy:STATE))
      return tokenize(deploy:git(('diff', '--name-only', $last, $tree)), '\n')[.]
    } catch * {
      'pom.xml'
    }
  ) else (
    'pom.xml'
  )
  let $changed := (
    for $path in $paths
    (: innermost module containing the file :)
    let $module := (
      for $dir in $release:MODULES
      where $dir = '.' or starts-with($path, `{ $dir }/`)
      order by string-length($dir) descending
      return $dir
    )[1]
    let $prefix := if ($module = '.') then '' else `{ $module }/`
    return switch () {
      (: changed POM: module and its submodules :)
      case $path = `{ $prefix }pom.xml` return $release:MODULES[
        $module = '.' or starts-with(., $prefix) or . = $module
      ]
      (: other files of the root project are ignored :)
      case $module = '.' return ()
      default return $module
    }
  )
  (: artifacts required for the release files :)
  let $missing := (
    for $module in ('basex-core', 'basex-api')
    let $jar := `{ $release:BASEX }{ $module }/target/{ deploy:artifact($module) }-{ $release:VERSION }.jar`
    where not(file:exists($jar))
    return $module
  )
  (: web applications bundled with the API :)
  let $bundled := doc($release:BASEX || 'basex-api/pom.xml')
    //*:dependency[*:groupId = 'org.basex.modules']/*:artifactId
  let $api := 'basex-api'[$changed ! deploy:artifact(.) = $bundled]
  return $release:MODULES[. = ($changed, $missing, $api)]
};

(:~
 : Deploys the Maven modules that changed since the last deployment.
 : @param $dry  print the command instead of executing it
 :)
declare %private function deploy:maven(
  $dry  as xs:boolean
) as empty-sequence() {
  let $tree := deploy:tree()
  let $modules := deploy:modules($tree)
  let $args := (
    'deploy', '-T', '4', '-DskipTests', '-Daether.checksums.algorithms=SHA-1',
    '-pl', string-join($modules, ',')
  )
  return switch () {
    case empty($modules) return message('* No changes since last deployment')
    case $dry return message(`mvn { string-join($args, ' ') }`)
    default return (
      release:clean($modules),
      release:mvn($args),
      file:write-text($deploy:STATE, $tree)
    )
  }
};

(:~
 : Uploads the created files.
 : @param $release  upload a release instead of a snapshot
 : @param $dry      print the commands instead of executing them
 :)
declare %private function deploy:upload(
  $release  as xs:boolean,
  $dry      as xs:boolean
) as empty-sequence() {
  let $names := sort(file:list($release:FILES)[matches(., '\d')])
  return switch () {
    case empty($names) return error((), 'No release files found.')
    case $release return deploy:upload-release($names, $dry)
    default return deploy:upload-snapshot($names, $dry)
  }
};

(:~
 : Uploads a snapshot and links it as latest version.
 : @param $names  names of the files
 : @param $dry    print the commands instead of executing them
 :)
declare %private function deploy:upload-snapshot(
  $names  as xs:string*,
  $dry    as xs:boolean
) as empty-sequence() {
  let $latest := `{ $deploy:TARGET }/latest`
  let $tmp := `{ $latest }/.tmp`
  return (
    deploy:ssh(`rm -fr { $tmp } && mkdir { $tmp }`, $dry),
    deploy:scp($names, $tmp, $dry),
    deploy:ssh((
      `rm -f { $latest }/*`,
      `mv { $tmp }/* { $latest }/`,
      `chmod 644 { $latest }/*`,
      `rm -f { $deploy:TARGET }/BaseX-latest.*`,
      for $name in $names[starts-with(., 'BaseX')]
      return `ln -s latest/{ $name } { $deploy:TARGET }/BaseX-latest.{ deploy:suffix($name) }`
    ), $dry)
  )
};

(:~
 : Uploads a release and links it as current version.
 : @param $names  names of the files
 : @param $dry    print the commands instead of executing them
 :)
declare %private function deploy:upload-release(
  $names  as xs:string*,
  $dry    as xs:boolean
) as empty-sequence() {
  let $remote := `{ $deploy:TARGET }/{ $release:VERSION }`
  return (
    deploy:ssh(`rm -fr { $remote } && mkdir -p { $remote }`, $dry),
    deploy:scp($names, $remote, $dry),
    deploy:ssh((
      `rm -f { $deploy:TARGET }/BaseX.*`,
      for $name in $names[starts-with(., 'BaseX')]
      return `ln -s { $remote }/{ $name } { $deploy:TARGET }/BaseX.{ deploy:suffix($name) }`,
      `chmod -R g+rX { $remote }`
    ), $dry)
  )
};
