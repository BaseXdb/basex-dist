(:~
 : Builds BaseX and creates all files for a new release.
 :
 : Usage: basex [-bbuild=war|none] build.xq
 :
 : @author BaseX Team, BSD License
 :)
import module namespace release = 'http://basex.org/dist/release' at 'modules/release.xqm';

(:~ Maven steps: build and install all modules, create the WAR file, or none. :)
declare variable $build  as enum('all', 'war', 'none') external := 'all';

release:create($build)
