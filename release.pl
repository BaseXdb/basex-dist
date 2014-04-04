# Creates all files for a new release.
# 
# (C) BaseX Team 2005-12, BSD License

use warnings;
use strict;
use File::Basename;
use File::Copy;
use File::Path;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use File::Copy::Recursive qw(rcopy);
 
# path to main class
my $main = "org.basex.BaseXGUI";

# home of launch4j
my $launch4j = "win/launch4j/launch4jc.exe";
# home of nsis
my $nsis = "win/nsis/makensis.exe /V1";

# original version, as found in pom.xml
my $version = "";
# full version with four numbers
my $full = "";

# prepare release
prepare();
# create zip file
zip();
# create app file
app();
# create installer
exe();
# create war file
war();
# create pad file
pad();
# finish release
finish();

# prepares a new release
sub prepare {
  print "* Prepare release\n";

  # delete old release files
  rmtree("release");
  mkdir "release";

  # extract pom version
  version();

  # create artifacts
  artifacts();
  copy("../basex/basex-core/target/basex-$version.jar", "release/basex.jar");
  copy("../basex/basex-api/target/basex-api-$version.jar", "release/basex-api.jar");

  # prepare start scripts
  mkdir "release/bin";
  for my $f(
    glob("../basex/basex-core/etc/*"),
    glob("../basex/basex-api/etc/*")
  ) {
    next if -d $f;
    (my $n = $f) =~ s|.*/||;
    open(my $in, $f);
    binmode $in;
    open(my $out, ">release/bin/$n");
    binmode $out;
    while(my $l = <$in>) {
      # replace "target/classes"
      $l =~ s|%PWD%/\.\./\.\./basex/target/classes|%LIB%/basex-api.jar|;
      $l =~ s|target/classes|BaseX.jar|;
      next if $l =~ m|\.\./\.\./basex|;
      print $out $l;
    }
    close($in);
    close($out);
  }

  # assemble webapp files
  rcopy("../basex/basex-api/src/main/webapp", "release/webapp");
  unlink("release/webapp/.gitignore");
  rmtree("release/webapp/WEB-INF/data");
  rmtree("release/webapp/WEB-INF/repo");

  # write version file
  print "* Write version file\n";
  open(my $out, ">release/version.txt");
  print $out $version;
  close($out);
}

# create artifacts
sub artifacts {
  print "* Create BaseX artifacts\n";
  rmtree("../basex/basex-core/lib/");
  rmtree("../basex/basex-api/lib/");
  system("cd ../basex && mvn install -q -DskipTests");
}

# gets version from pom file
sub version {
  open(POM, "../basex/pom.xml") or die "pom.xml not found";
  while(my $l = <POM>) {
    next if $l !~ m|<version>(.*)</version>|;
    $version = $1;
    $full = $version;
    if(length($full) > 5) {
      $full =~ s/-.*//;
      $full .= ".0" while $full !~ /\..*\./;
      $full .= ".".time();
    } else {
      $full .= ".0" while $full !~ /\..*\..*\./;
    }
    last;
  }
  close(POM);
  print "* Version: $version ($full)\n";
}

# creates the zip archive
sub zip {
  print "* Create ZIP file\n";

  my $zip = Archive::Zip->new();

  # Add files from disk
  $zip->addFile("release/basex.jar", "basex/BaseX.jar");
  $zip->addFile("../basex/license.txt", "basex/license.txt");
  $zip->addFile("../basex/changelog.txt", "basex/changelog.txt");
  $zip->addFile("readme.txt", "basex/readme.txt");
  $zip->addString("", "basex/.basexhome");

  # Add scripts
  foreach my $file(glob("release/bin/*")) {
    (my $target = $file) =~ s|.*/|basex/bin/|;
    my $m = $zip->addFile($file, $target);
    $m->unixFileAttributes($file =~ /.bat$/ ? 0644 : 0755);
  }
  # Add database directory
  $zip->addDirectory("basex/data");
  # Add etc directory
  $zip->addTree("etc", "basex/etc");
  # Add libraries
  $zip->addDirectory("basex/lib");
  foreach my $file(
    glob("../basex/basex-core/lib/*"),
    glob("../basex/basex-api/lib/*"),
    glob("lib/*")
  ) {
    next if $file =~ m|/lib/basex-$version|;
    (my $target = $file) =~ s|.*/||;
    $zip->addFile($file, "basex/lib/$target");
  }
  $zip->addFile("release/basex-api.jar", "basex/lib/basex-api.jar");
  # Add repository directory
  $zip->addDirectory("basex/repo");
  # Add webapp directory
  $zip->addTree("release/webapp", "basex/webapp");

  # save the zip file
  $zip->writeToFileNamed("release/BaseX.zip") == AZ_OK or
    die "Could not write ZIP file.";
}

# creates the war file
sub war {
  print "* Create WAR file\n";

  # create WAR file
  system("cd ../basex/basex-api && mvn compile war:war");
  move("../basex/basex-api/target/basex-api-$version.war", "release/basex.war");
}

# creates the app archive
sub app {
  print "* Create APP file\n";

  # create WAR file
  system("cd mac && ant");

  my $zip = Archive::Zip->new();
  $zip->addTree("mac/dist", "");

  # save the zip file
  unless ($zip->writeToFileNamed("release/BaseX.app.zip") == AZ_OK ) {
    die "Could not write APP file.";
  }
}

# creates the installer
sub exe {
  print "* Create EXE file\n";

  # add start class and libraries
  my $cc = "<classPath>\n".
    "    <mainClass>$main</mainClass>\n";
  foreach my $file(glob("../basex/basex-core/lib/*")) {
    $file =~ s|.*/|lib/|;
    $cc .= "    <cp>$file</cp>\n";
  }
  foreach my $file(glob("../basex/basex-api/lib/*")) {
    next if $file =~ /basex-\d/;
    $file =~ s|.*/|lib/|;
    $cc .= "    <cp>$file</cp>\n";
  }
  # add basex-api to find additional libraries
  $cc .= "    <cp>lib/basex-api.jar</cp>\n";
  $cc .= "  </classPath>";

  # prepare launch script
  open(my $in, "win/launch4j.xml");
  my @raw = <$in>;
  open(my $out, ">release/launch4j.xml");
  (my $ff = $full) =~ s/-.*//;
  (my $vv = $version) =~ s/-.*//;
  foreach my $line (@raw) {
    $line =~ s/\$full/$ff/g;
    $line =~ s/\$version/$vv/g; 
    $line =~ s/\$classpath/$cc/g; 
    print $out $line;
  }
  close($in);
  close($out);

  # create executable
  system("$launch4j release/launch4j.xml");
  # remove launch script
  unlink("release/launch4j.xml");
  # move executable to final destination
  move("BaseX.exe", "release/BaseX.exe");

  # create installer
  system("$nsis win/BaseX.nsi");
  # move installer to final destination
  move("win/Setup.exe", "release/BaseX.exe");
}

# write PAD file
sub pad {
  print "* Update PAD file\n";

  my ($sec,$min,$hou,$day,$month,$year,$etc) = localtime();
  $year += 1900;
  $month++;
  $month = "0$month" if length($month) == 1;
  $day = "0$day" if length($day) == 1;

  my $bytes = -s "release/BaseX.zip";
  my $kb = int($bytes / 102.4) / 10;
  my $mb = int($kb / 102.4) / 10;

  open(my $in, "BaseXPADFile.xml");
  open(my $out, ">release/BaseXPADFile.xml");
  while(my $l = <$in>) {
    $l =~ s/\$version/$version/;
    $l =~ s/\$month/$month/;
    $l =~ s/\$day/$day/;
    $l =~ s/\$year/$year/;
    $l =~ s/\$bytes/$bytes/;
    $l =~ s/\$mb/$mb/;
    $l =~ s/\$kb/$kb/;
    print $out $l;
  }
  close($in);
  close($out);
}

# finishes the release files
sub finish {
  print "* Finish release\n";

  (my $v = $version) =~ s/\.//g;
  move("release/BaseX.app.zip", "release/BaseX$v.app.zip");
  move("release/BaseX.zip", "release/BaseX$v.zip");
  move("release/basex.jar", "release/BaseX$v.jar");
  move("release/basex.war", "release/BaseX$v.war");
  move("release/BaseX.exe", "release/BaseX$v.exe");
  unlink("release/basex-api.jar");
  rmtree("release/bin");
  rmtree("release/webapp");
}
