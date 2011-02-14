# Creates all files for a new release.
# 
# (C) BaseX Team 2005-11, ISC License

use warnings;
use strict;
use File::Copy;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

# home of launch4j
my $launch4j = "win/tools/launch4j/launch4jc.exe";
# home of nsis
my $nsis = "win/tools/nsis/makensis.exe /V1";
# versions
my $f = "";
my $v = "";

# prepare release
prepare();
# create installer
exe();
# create zip file
zip();
# finish release
finish();

# prepares a new release
sub prepare {
  print "* Prepare release\n";

  foreach my $file(glob("release/*")) {
    unlink($file);
  }
  mkdir("release");

  # extract pom version
  version();
  # create packages
  pkg("basex");
  pkg("basex-api");
}

# gets version from pom file
sub version {
  print "* Extract version from POM file\n";

  open(POM, "../BaseX/pom.xml");
  my @raw_data=<POM>;
  my $line = $raw_data[6];
  my $pos = index($line, "</version>") - 11;
  $v = substr $line, 11, $pos;
  if (length($v) == 3) {
    $f = $v . ".0.0";
  } elsif (length($v) == 5) {
    $f = $v . ".0";
  }
  close(POM);
}

# packages both projects
sub pkg {
  my $name = shift;
  print "* Create $name package\n";

  unlink("../$name/target/*.jar");
  system("cd ../$name && mvn install -q -DskipTests=true");
  move("../$name/target/$name-$v.jar", "release/$name.jar");
}

# modifies the launch4j xml
sub exe {
  print "* Create executable\n";

  open(L4J, "win/launch4j.xml");
  my @raw_data=<L4J>;
  open(L4JTMP, '>>release/launch4j.xml');
  foreach my $line (@raw_data) {
    $line =~ s/\$f/$f/g;
    $line =~ s/\$v/$v/g; 
    print L4JTMP $line;
  }
  close(L4J);
  close(L4JTMP);

  system($launch4j." release/launch4j.xml");
  unlink("release/launch4j.xml");
  move("BaseX.exe", "release/BaseX.exe");

  system($nsis." win/installer/BaseX.nsi");
  unlink("release/BaseX.exe");
}

# creates zip archive
sub zip {
  print "* Create ZIP file\n";

  my $zip = Archive::Zip->new();

  # Add directories
  $zip->addDirectory("lib");
  $zip->addDirectory("bin");
  $zip->addDirectory("etc");

  # Add files from disk
  $zip->addFile("release/basex.jar", "BaseX.jar");
  foreach my $file(glob("etc/*")) {
    $zip->addFile($file, $file);
  }
  $zip->addFile("release/basex-api.jar", "lib/basex-api.jar");

  # bin folder
  foreach my $file(glob("bin/*")) {
    next if $file =~ /basexrest.bat/;
    $zip->addFile($file, $file);
  }

  # add the start call in rest script
  # (needs to be done manually, as file is also modified by .nsi script)
  copy("bin/basexrest.bat", "release/basexrest.bat");
  open (REST,'>> release/basexrest.bat');
  print REST 'java -cp "%CP%;." %VM% org.basex.api.jaxrx.JaxRxServer %*';
  close(REST);

  $zip->addFile("release/basexrest.bat", "bin/basexrest.bat");

  # lib folder
  foreach my $file(glob("../basex-api/lib/*")) {
    (my $target = $file) =~ s|.*/|lib/|;
    $zip->addFile($file, $target);
  }

  # save the zip file
  unless ($zip->writeToFileNamed("release/BaseX.zip") == AZ_OK ) {
    die "Could not write ZIP file.";
  }
  unlink("release/basexrest.bat");
}

# finishes the new release
sub finish {
  print "* Finish release\n";

  $v =~ s/\.//g;
  move("release/BaseX.zip","release/BaseX$v.zip");
  move("release/basex.jar","release/BaseX$v.jar");
  move("win/installer/Setup.exe","release/BaseX$v.exe");
  unlink("release/basex-api.jar");
}
