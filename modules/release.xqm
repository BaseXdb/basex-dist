(:~
 : Functions for creating the release files.
 :
 : @author BaseX Team, BSD License
 :)
module namespace release = 'http://basex.org/dist/release';

declare namespace File = 'java:java.io.File';
declare namespace Files = 'java:java.nio.file.Files';
declare namespace FileSystem = 'java:java.nio.file.FileSystem';
declare namespace FileSystems = 'java:java.nio.file.FileSystems';
declare namespace Map = 'java:java.util.Map';
declare namespace Path = 'java:java.nio.file.Path';
declare namespace PosixFilePermissions = 'java:java.nio.file.attribute.PosixFilePermissions';
declare namespace Process = 'java:java.lang.Process';
declare namespace ProcessBuilder = 'java:java.lang.ProcessBuilder';
declare namespace URI = 'java:java.net.URI';

(:~ Distribution project. :)
declare variable $release:DIST     := file:parent(file:base-dir());
(:~ BaseX project. :)
declare variable $release:BASEX    := $release:DIST || '../basex/';
(:~ Directory with the created files. :)
declare variable $release:FILES    := $release:DIST || 'release/';
(:~ Version, as found in the POM file. :)
declare variable $release:VERSION  := string(doc($release:BASEX || 'pom.xml')/*:project/*:properties/*:revision);
(:~ Maven modules. :)
declare variable $release:MODULES  := release:modules('.');
(:~ Indicates if the version is a snapshot. :)
declare variable $release:SNAPSHOT := contains($release:VERSION, '-');

(:~ Version without qualifier. :)
declare %private variable $release:PLAIN    := substring-before($release:VERSION || '-', '-');
(:~ Timestamp of a snapshot. :)
declare %private variable $release:STAMP    := if ($release:SNAPSHOT) {
  format-dateTime(current-dateTime(), '-[Y0001][M01][D01].[H01][m01][s01]')
};
(:~ Directory with the web application archives. :)
declare %private variable $release:WEBAPPS  := $release:BASEX || 'basex-api/target/webapp/';
(:~ Full version with four numbers; days since 2000 for a snapshot (16 bits each). :)
declare %private variable $release:FULL     := string-join((
  let $numbers := tokenize($release:PLAIN, '\.')
  return ($numbers, (count($numbers) to 2) ! '0'),
  if ($release:SNAPSHOT) then (
    xs:integer((current-date() - xs:date('2000-01-01')) div xs:dayTimeDuration('P1D'))
  ) else (
    0
  )
), '.');

(:~ Artifact name: "BaseX124" for a release, "BaseX130-20260706.234438" for a snapshot. :)
declare variable $release:NAME     := `BaseX{ translate($release:PLAIN, '.', '') }{ $release:STAMP }`;
(:~ Suffixes of the created release files. :)
declare variable $release:SUFFIXES := ('zip', 'jar', 'war', 'exe');

(:~
 : Creates all files for a new release.
 : @param $build  Maven steps: build and install all modules, create the WAR file, or none
 :)
declare function release:create(
  $build  as enum('all', 'war', 'none')
) as empty-sequence() {
  release:prepare($build = 'all'),
  release:zip(),
  release:exe(),
  release:war($build != 'none'),
  release:finish()
};

(:~
 : Returns a Maven project and its modules.
 : @param $dir  project directory, relative to the BaseX project
 : @return directories
 :)
declare %private function release:modules(
  $dir  as xs:string
) as xs:string* {
  $dir,
  for $module in doc(`{ $release:BASEX }{ $dir }/pom.xml`)/*:project/*:modules/*:module
  return release:modules(if ($dir = '.') then string($module) else `{ $dir }/{ $module }`)
};

(:~
 : Removes the archives and copied libraries of Maven modules.
 : @param $modules  module directories
 :)
declare function release:clean(
  $modules  as xs:string*
) as empty-sequence() {
  for $module in $modules[. != '.']
  let $dir := `{ $release:BASEX }{ $module }/`
  let $target := $dir || 'target/'
  return (
    if (file:exists($target)) {
      for $jar in file:list($target, false(), '*.jar')
      return file:delete($target || $jar)
    },
    file:delete($dir || 'lib/', true())
  )
};

(:~
 : Runs Maven in the BaseX project and streams its output.
 : @param $args  arguments
 : @param $dir   working directory, relative to the BaseX project
 :)
declare function release:mvn(
  $args  as xs:string+,
  $dir   as xs:string  := '.'
) as empty-sequence() {
  message(`mvn { string-join($args, ' ') }`),
  let $builder := ProcessBuilder:new(('cmd', '/c', 'mvn', $args))
  let $process := ProcessBuilder:start(ProcessBuilder:inheritIO(
    ProcessBuilder:directory($builder, File:new($release:BASEX || $dir))
  ))
  where Process:waitFor($process) != 0
  return error((), 'Maven failed.')
};

(:~
 : Runs an external command in the distribution project and raises an error if it fails.
 : @param $command  command
 : @param $args     arguments
 :)
declare %private function release:run(
  $command  as xs:string,
  $args     as xs:string*
) as empty-sequence() {
  let $result := proc:execute($command, $args, { 'dir': $release:DIST })
  return (
    message(string($result/output)),
    if ($result/code != '0') {
      error((), `{ $command } failed: { $result/output }{ $result/error }`)
    }
  )
};

(:~
 : Returns the files and directories of a directory as archive entries.
 : @param $dir   source directory
 : @param $name  name of the target directory
 : @return entries
 :)
declare %private function release:entries(
  $dir   as xs:string,
  $name  as xs:string
) as record(name, file)* {
  { 'name': `{ $name }/`, 'file': $dir },
  for $path in sort(file:list($dir, true()))
  let $entry := translate($path, '\', '/')
  return { 'name': `{ $name }/{ $entry }`, 'file': $dir || $entry }
};

(:~
 : Prepares a new release.
 : @param $build  build and install all modules
 :)
declare %private function release:prepare(
  $build  as xs:boolean
) as empty-sequence() {
  message('* Prepare release'),
  message(`* Version: { $release:VERSION } ({ $release:FULL })`),
  file:delete($release:FILES, true()),
  file:create-dir($release:FILES),
  if ($build) {
    message('* Create BaseX artifacts'),
    release:clean($release:MODULES),
    release:mvn(('install', '-q', '-DskipTests'))
  },
  file:copy(`{ $release:BASEX }basex-core/target/basex-{ $release:VERSION }.jar`, $release:FILES || 'BaseX.jar'),
  file:copy(`{ $release:BASEX }basex-api/target/basex-api-{ $release:VERSION }.jar`, $release:FILES),

  (: start scripts: replace class paths :)
  file:create-dir($release:FILES || 'bin'),
  for $file in ('basex-core', 'basex-api') ! file:children(`{ $release:BASEX }{ . }/etc/`)
  where file:is-file($file)
  return file:write-text(
    $release:FILES || 'bin/' || file:name($file),
    file:read-text($file, { 'normalize-newlines': false() })
    => replace('^CORE=[^\r\n]*\r?\n', '', 'm')
    => replace('target[/\\]classes', 'BaseX.jar')
    => replace(';%MAIN%[/\\]\.\.[/\\]basex-core[/\\]lib[/\\]\*', '')
    => replace(':\$CORE[/\\]lib[/\\]\*', '')
  ),

  (: web application files; web applications as archives :)
  file:copy($release:BASEX || 'basex-api/src/main/webapp', $release:FILES || 'webapp'),
  for $path in ('.gitignore', 'WEB-INF/data', 'WEB-INF/repo')
  return file:delete($release:FILES || 'webapp/' || $path, true()),
  for $zip in file:list($release:WEBAPPS, false(), '*.zip')
  return file:copy($release:WEBAPPS || $zip, $release:FILES || 'webapp/'),

  message('* Write version file'),
  file:write-text($release:FILES || 'version.txt', $release:VERSION)
};

(:~
 : Creates the ZIP archive.
 :)
declare %private function release:zip() as empty-sequence() {
  message('* Create ZIP file'),
  let $zip := $release:FILES || 'BaseX.zip'
  let $entries := (
    { 'name': 'basex/BaseX.jar', 'file': $release:FILES || 'BaseX.jar' },
    for $name in ('LICENSE', 'CHANGELOG')
    return { 'name': `basex/{ $name }`, 'file': $release:BASEX || $name },
    release:entries($release:FILES || 'bin/', 'basex/bin'),
    { 'name': 'basex/data/' },
    { 'name': 'basex/data/.logs/' },
    release:entries($release:DIST || 'dist/basex/', 'basex')[?name != 'basex/'],
    for $dir in ('basex-core', 'basex-api') ! `{ $release:BASEX }{ . }/lib/`
    for $name in file:list($dir)[not(starts-with(., `basex-{ $release:VERSION }`))]
    return { 'name': `basex/lib/{ $name }`, 'file': $dir || $name },
    { 'name': 'basex/lib/custom/' },
    {
      'name': `basex/lib/basex-api-{ $release:VERSION }.jar`,
      'file': `{ $release:FILES }basex-api-{ $release:VERSION }.jar`
    },
    release:entries($release:FILES || 'webapp/', 'basex/webapp')
  )
  return (
    file:write-binary($zip, archive:create(
      for $entry in $entries
      let $time := if ($entry?file) then file:last-modified($entry?file) else current-dateTime()
      return <archive:entry last-modified='{ $time }'>{ $entry?name }</archive:entry>,
      $entries ! (if (ends-with(?name, '/')) then '' else file:read-binary(?file))
    )),
    (: Unix permissions: executable start scripts and directories :)
    let $env := Map:of('enablePosixFileAttributes', 'true')
    let $fs := FileSystems:newFileSystem(Path:of(URI:create(string(file:path-to-uri($zip)))), $env)
    return (
      (: children first: updating a directory entry drops its child list (JDK 25) :)
      for $name in reverse($entries ! ?name)
      let $exec := ends-with($name, '/') or matches($name, '^basex/bin/[^.]+$')
      return Files:setPosixFilePermissions(
        FileSystem:getPath($fs, replace($name, '/$', ''), []),
        PosixFilePermissions:fromString(if ($exec) then 'rwxr-xr-x' else 'rw-r--r--')
      ),
      FileSystem:close($fs)
    ) => void()
  )
};

(:~
 : Creates the installer.
 :)
declare %private function release:exe() as empty-sequence() {
  message('* Create EXE file'),
  release:run(
    file:path-to-native($release:DIST || 'win/nsis/makensis.exe'),
    (
      '/V1',
      `/DPRODUCT_VERSION={ $release:FULL }`,
      `/DOUTFILE={ file:path-to-native($release:FILES) }BaseX.exe`,
      'win/BaseX.nsi'
    )
  )
};

(:~
 : Creates the WAR file.
 : @param $build  create the WAR file with Maven
 :)
declare %private function release:war(
  $build  as xs:boolean
) as empty-sequence() {
  message('* Create WAR file'),
  if ($build) {
    release:mvn(('-q', 'war:war'), 'basex-api')
  },
  file:copy(
    `{ $release:BASEX }basex-api/target/basex-api-{ $release:VERSION }.war`, $release:FILES || 'BaseX.war'
  )
};

(:~
 : Finishes the release files.
 :)
declare %private function release:finish() as empty-sequence() {
  message('* Finish release'),
  message(`* Artifact name: { $release:NAME }`),
  for $suffix in $release:SUFFIXES
  return file:move(`{ $release:FILES }BaseX.{ $suffix }`, `{ $release:FILES }{ $release:NAME }.{ $suffix }`),
  file:delete(`{ $release:FILES }basex-api-{ $release:VERSION }.jar`),
  for $dir in ('bin', 'webapp')
  return file:delete($release:FILES || $dir, true())
};
