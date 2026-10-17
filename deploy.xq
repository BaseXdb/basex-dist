(:~
 : Deploys a new snapshot or release: changed Maven modules and the release files.
 :
 : Usage: basex [-brelease=true] [-bdry=true] [-bclean=true] deploy.xq
 :
 : @author BaseX Team, BSD License
 :)
import module namespace deploy = 'http://basex.org/dist/deploy' at 'modules/deploy.xqm';

(:~ Deploy a release instead of a snapshot. :)
declare variable $release  as xs:boolean external := false();
(:~ Print commands instead of executing them. :)
declare variable $dry      as xs:boolean external := false();
(:~ Remove archives and copied libraries before building (always done for releases). :)
declare variable $clean    as xs:boolean external := false();

deploy:run($release, $dry, $clean)
