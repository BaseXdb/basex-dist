(:~
 : This <a href="http://docs.basex.org/wiki/Module_Library">XQuery Module</a> contains functions for installing, listing and deleting modules contained in the <a href="http://docs.basex.org/wiki/Repository">Repository</a> .
 : 
 : @author BaseX Team
 : @see http://docs.basex.org/wiki/Module_Library
 :)
module namespace repo = "http://basex.org/modules/repo";
declare namespace bxerr = "http://basex.org/errors";

(:~
 : Installs a package or replaces an existing package. The parameter <code>$path</code> indicates the path to the package.
 :
 : @error bxerr:BXRE0001 the package does not exist.
 : @error bxerr:BXRE0002 a package uses an invalid namespace URI.
 : @error bxerr:BXRE0003 the package to be installed requires a package which is still not installed.
 : @error bxerr:BXRE0004 the package descriptor is invalid.
 : @error bxerr:BXRE0005 the module contained in the package to be installed is already installed as part of another package.
 : @error bxerr:BXRE0006 the package cannot be parsed.
 : @error bxerr:BXRE0009 the package version is not supported.
 : @error bxerr:BXRE0010 the package contains an invalid JAR descriptor.
 : @error bxerr:BXRE0011 the package contains a JAR descriptor but it cannot be read.
 :)
declare function repo:install($path as xs:string) as empty-sequence() external;

(:~
 : Deletes a package. The parameter <code>$pkg</code> indicates either the package name as specified in the package descriptor or the name, suffixed with a hyphen and the package version.
 :
 : @error bxerr:BXRE0007 the package cannot be deleted.
 : @error bxerr:BXRE0008 another package depends on the package to be deleted.
 :)
declare function repo:delete($pkg as xs:string) as empty-sequence() external;

(:~
 : Lists the names and versions of all currently installed packages.
 :)
declare function repo:list() as element(package)* external;



