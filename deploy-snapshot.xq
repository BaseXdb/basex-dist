(:~
 : Deploys a new snapshot: changed Maven modules and the release files.
 :
 : Usage: basex [-bdry=true] deploy-snapshot.xq
 :
 : @author BaseX Team, BSD License
 :)
import module namespace deploy = 'http://basex.org/dist/deploy' at 'modules/deploy.xqm';

(:~ Print commands instead of executing them. :)
declare variable $dry  as xs:boolean external := false();

deploy:run(release := false(), dry := $dry)
