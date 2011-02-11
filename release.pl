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

# start methods
drop();
version();
pkg("basex");
pkg("basex-api");
modl4J();
launch4J();
nsis();
zip();
movefiles();

# gets version from pom file
sub version {
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
  unlink("../$name/target/*.jar");
  exc("cd ../$name && mvn install -DskipTests=true");
}

# modifies the launch4j xml
sub modl4J {
  open(L4J, "win/launch4j.xml");
  my @raw_data=<L4J>;
  open(L4JTMP, '>>launch4jtmp.xml');
  foreach my $line (@raw_data) {
    $line =~ s/\$f/$f/g;
    $line =~ s/\$v/$v/g; 
    print L4JTMP $line;
  }
  close(L4J);
  close(L4JTMP);
}

# launch launch4J
sub launch4J {
  copy("../basex/target/basex-$v.jar", "BaseX.jar");
  exc($launch4j." launch4jtmp.xml");
}

# launch nsis
sub nsis {
  copy("../basex-api/target/basex-api-$v.jar", "basex-api.jar");
  exc($nsis." win/installer/BaseX.nsi");
}

# creates zip archive
sub zip {
  my $zip = Archive::Zip->new();

  # Add directories
  $zip->addDirectory("lib");
  $zip->addDirectory("bin");
  $zip->addDirectory("etc");

  # Add files from disk
  $zip->addFile("BaseX.jar");
  $zip->addFile("etc/factbook.xml", "etc/factbook.xml");
  $zip->addFile("basex-api.jar", "lib/basex-api.jar");

  # write to the rest file
  mkdir "release";
  copy("scripts/basexrest.bat", "basexrest.bat");
  open (REST,'>> basexrest.bat');
  print REST 'java -cp "%CP%;." %VM% org.basex.api.jaxrx.JaxRxServer %*';
  close(REST);

  $zip->addFile("basexrest.bat", "bin/basexrest.bat");

  # bin folder
  my @files = dir("scripts");
  my $file;

  foreach $file(@files) {
    if(substr($file, 0, 5) eq "basex" && $file ne "basexrest.bat") {
      $zip->addFile("scripts/$file", "bin/$file");
    }	
  }

  # lib folder
  @files = dir("../basex-api/lib");

  foreach $file(@files) {
    if(substr($file, 0, 1) ne ".") {
      $zip->addFile("../basex-api/lib/$file", "lib/$file");
    }	
  }

  # Save the Zip file
  unless ($zip->writeToFileNamed("BaseX.zip") == AZ_OK ) {
    die "write error";
    }
  unlink("basexrest.bat");
}

sub dir {
  my $dir = shift;
  opendir DIR, "$dir" or die "cannot open dir $dir: $!";
  my @file = readdir DIR;
  closedir DIR;
  return @file;
}

# moves all files to release folder
sub movefiles {
  $v =~ s/\.//g;
  move("BaseX.zip","release/BaseX$v.zip");
  move("BaseX.jar","release/BaseX$v.jar");
  move("installer/Setup.exe","release/BaseX$v.exe");
  unlink("BaseX.exe");
  unlink("basex-api.jar");
  unlink("launch4jtmp.xml");
}

# deletes tmp files
sub drop {
  foreach my $file(glob("release/*")) {
    unlink($file);
  }
  unlink("release/*");
  rmdir("release");
  unlink("BaseX.exe");
  unlink("basex-api.jar");
  unlink("launch4jtmp.xml");  
}

# executes a command
sub exc {
  my $cmd = shift;
  print "\n> $cmd\n";
  system "$cmd";
  sleep 1;
}
