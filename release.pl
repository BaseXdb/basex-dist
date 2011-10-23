# Creates all files for a new release.
# 
# (C) BaseX Team 2005-11, ISC License

use warnings;
use strict;
use File::Copy;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

# static directories
my $release = "release";
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
# create war file
war();
# create app file
app();
# create installer
exe();
# create pad file
pad();
# finish release
finish();

# prepares a new release
sub prepare {
  print "* Prepare release\n";

  # delete old release files
  unlink(glob("$release/bin/*"));
  unlink(glob("$release/*"));
  mkdir $release;

  # extract pom version
  version();

  # prepare start scripts
  mkdir "$release/bin";
  for my $f(glob("../basex/etc/*"), glob("../basex-api/etc/*")) {
    next if -d $f;
    (my $n = $f) =~ s|.*/||;
    open(my $in, $f);
    binmode $in;
    open(my $out, ">".$release."/bin/$n");
    binmode $out;
    while(my $l = <$in>) {
      if($l =~ m|\.\./\.\./|) {
        # basexhttp.bat: replace "%PWD%/../../basex/target/classes" with "basex-api.jar"
        next if $l !~ s|%PWD%/\.\./\.\./basex/target/classes|%LIB%/basex-api.jar|;
      }
      $l =~ s|target/classes|BaseX.jar|;
      print $out $l;
      #print $out ($f =~ /.bat$/ ? "\r\n" : "\n");
    }
    close($in);
    close($out);
  }

  # create packages
  pkg("basex");
  pkg("basex-api");

  # write version file
  print "* Write version file\n";
  open(my $out, ">".$release."/version.txt");
  print $out $version;
  close($out);
}

# gets version from pom file
sub version {
  print "* Extract version from POM file\n";

  open(POM, "../basex/pom.xml") or die "pom.xml not found";
  while(my $l = <POM>) {
    next if $l !~ m|<version>(.*)</version>|;
    $version = $1;
    if (length($version) == 1) {
      $full = $version . ".0.0.0";
    } elsif (length($version) == 3) {
      $full = $version . ".0.0";
    } elsif (length($version) == 5) {
      $full = $version . ".0";
    } else {
      $full = substr($version, 0, 5).".".time();
    }
    last;
  }
  close(POM);
}

# creates project packages
sub pkg {
  my $name = shift;
  print "* Create $name-$version package\n";
  unlink("../$name/target/*.jar");
  system("cd ../$name && mvn install -q -DskipTests=true");
  move("../$name/target/$name-$version.jar", "$release/$name.jar");
}

# creates the zip archive
sub zip {
  print "* Create ZIP file\n";

  my $zip = Archive::Zip->new();

  # Add directories
  my $name = "basex";
  $zip->addDirectory("$name/");
  $zip->addDirectory("$name/lib");
  $zip->addDirectory("$name/bin");
  $zip->addDirectory("$name/data");
  $zip->addDirectory("$name/etc");
  $zip->addDirectory("$name/http");
  $zip->addDirectory("$name/repo");
  $zip->addString("", "$name/.basex");

  # Add files from disk
  $zip->addFile("$release/basex.jar", "$name/BaseX.jar");
  $zip->addFile("../$name/license.txt", "$name/license.txt");
  $zip->addFile("../$name/changelog.txt", "$name/changelog.txt");
  $zip->addFile("readme.txt", "$name/readme.txt");

  # Add example and DTD files
  foreach my $file(glob("etc/*")) {
    $zip->addFile($file, "$name/$file");
  }
  $zip->addFile("$release/basex-api.jar", "$name/lib/basex-api.jar");

  # Add scripts
  foreach my $file(glob("$release/bin/*")) {
    (my $target = $file) =~ s|.*/|$name/bin/|;
    my $m = $zip->addFile($file, $target);
    $m->unixFileAttributes($file =~ /.bat$/ ? 0644 : 0755);
  }

  # lib folders
  foreach my $file(glob("../basex/lib/*"), glob("../basex-api/lib/*")) {
    (my $target = $file) =~ s|.*/|$name/lib/|;
    $zip->addFile($file, $target);
  }

  # save the zip file
  unless ($zip->writeToFileNamed("$release/BaseX.zip") == AZ_OK ) {
    die "Could not write ZIP file.";
  }
  unlink("$release/basexhttp.bat");
}

# creates the war file
sub war {
  print "* Create WAR file\n";

  # create WAR file
  system("cd ../basex-api && mvn compile war:war");
  move("../basex-api/target/basex-api-$version.war", "$release/basex.war");
}

# creates app archive
sub app {
  print "* Create APP file\n";

  my $zip = Archive::Zip->new();
  my $info = "";
  my $classes = "<array>\n".
    "        <string>\$JAVAROOT/repo/org/basex/basex/$version/basex-$version.jar</string>\n";
  foreach my $file(glob("../basex/lib/*")) {
    $file =~ s|.*/|\$JAVAROOT/repo/lib/|;
    $classes .= "        <string>$file</string>\n";
  }
  $classes .= "      </array>";

  open(my $in, "mac/OSXBundle/Info.plist");
  while(my $l = <$in>) {
    $info =~ s/\$\{bundleName\}/BaseX/;
    $info =~ s/\$\{iconFile\}/BaseX.icns/;
    $info =~ s/\$\{mainClass\}/$main/;
    $info =~ s/\$\{classpath\}/$classes/;
    $info .= $l;
  }
  close($in);
  $zip->addString($info,
    "BaseX.app/Contents/Info.plist");
  my $m = $zip->addFile("mac/OSXBundle/JavaApplicationStub",
    "BaseX.app/Contents/MacOS/JavaApplicationStub");
  $m->unixFileAttributes(0755);
  $zip->addFile("mac/OSXBundle/BaseX.icns",
    "BaseX.app/Contents/Resources/BaseX.icns");

  # lib folder
  foreach my $file(glob("../basex/lib/*"), glob("../basex-api/lib/*")) {
    (my $target = $file) =~ s|.*/|BaseX.app/Contents/Resources/Java/repo/lib/|;
    $zip->addFile($file, $target);
  }
  $zip->addFile("$release/basex-api.jar", 
    "BaseX.app/Contents/Resources/Java/repo/lib/basex-api.jar");
  $zip->addFile("$release/basex.jar",
    "BaseX.app/Contents/Resources/Java/repo/org/basex/basex/$version/basex-$version.jar");

  # save the zip file
  unless ($zip->writeToFileNamed("$release/BaseX.app") == AZ_OK ) {
    die "Could not write APP file.";
  }
}

# creates the installer
sub exe {
  print "* Create executable\n";

  # remove last line from http script (will be readded by NSI script)
  #my $tmp = "";
  #open(my $in, "$release/bin/basexhttp.bat");
  #while(my $l = <$in>) {
  #  next if $l =~ m|%CP%.*BaseXHTTP|;
  #  $tmp .= $l;
  #}
  #close($in);
  #open(my $out, ">".$release."/bin/basexhttp.bat");
  #print $out $tmp;
  #close($out);

  # add start class and libraries
  my $cc = "<classPath>\n".
    "    <mainClass>$main</mainClass>\n";
  foreach my $file(glob("../basex/lib/*")) {
    $file =~ s|.*/|lib/|;
    $cc .= "    <cp>$file</cp>\n";
  }
  $cc .= "  </classPath>";

  # prepare launch script
  open(my $in, "win/launch4j.xml");
  my @raw = <$in>;
  open(my $out, ">".$release."/launch4j.xml");
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
  system("$launch4j $release/launch4j.xml");
  # remove launch script
  unlink("$release/launch4j.xml");
  # move executable to final destination
  move("BaseX.exe", "$release/BaseX.exe");

  # create installer
  print "* Create installer\n";
  system("$nsis win/BaseX.nsi");
  # move installer to final destination
  move("win/Setup.exe", "$release/BaseX.exe");
}

# write PAD file
sub pad {
  print "* Update PAD file\n";

  my ($sec,$min,$hou,$day,$month,$year,$etc) = localtime();
  $year += 1900;
  $month++;
  $month = "0$month" if length($month) == 1;
  $day = "0$day" if length($day) == 1;

  my $bytes = -s "$release/BaseX.zip";
  my $kb = int($bytes / 102.4) / 10;
  my $mb = int($kb / 102.4) / 10;

  open(my $in, "BaseXPADFile.xml");
  open(my $out, ">".$release."/BaseXPADFile.xml");
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
  move("$release/BaseX.app", "$release/BaseX$v.app");
  move("$release/BaseX.zip", "$release/BaseX$v.zip");
  move("$release/basex.jar", "$release/BaseX$v.jar");
  move("$release/basex.war", "$release/BaseX$v.war");
  move("$release/BaseX.exe", "$release/BaseX$v.exe");
  unlink("$release/basex-api.jar");
  #unlink(glob("$release/bin/*"));
  rmdir("$release/bin");
}
