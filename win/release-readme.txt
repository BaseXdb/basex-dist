RELEASE ======================================================================

 The release script creates a folder release in the dist folder with the following
 content:
 -> Jar archives using Maven: BaseX.jar and baseX-api.jar
 -> Executable file using Launch4J: BaseX.exe
 -> Setup.exe installer using NSIS: Setup.exe

NOTES --------------------------------------------------------------------------

 This script gets the version from pom.xml from the BaseX project folder.

FILES --------------------------------------------------------------------------

 release.pl: Script for creating all the above versions for new releases.

--------------------------------------------------------------------------------
 
 Any kind of feedback is welcome; please check out the online documentation at
 http://basex.org/documentation and tell us if you run into any troubles
 while installing and running BaseX: basex-talk@mailman.uni-konstanz.de
 
 BaseX Team, 2011
 
================================================================================