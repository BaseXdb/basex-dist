# Creates all files for a new release.
# 
# (C) BaseX Team 2005-12, BSD License

use warnings;
use strict;
use File::Basename;
use File::Copy;
use File::Path;
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
  rmtree("release");
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
  rmtree("webapp");
  mkdir "webapp";
  for my $f(glob("../basex-api/src/main/webapp/*")) {
    copy($f, "webapp/".basename($f));
  }
  mkdir "webapp/restxq";
  for my $f(glob("../basex-api/src/main/webapp/restxq/*")) {
    copy($f, "webapp/restxq/".basename($f));
  }
  mkdir "webapp/WEB-INF";
  for my $f(glob("../basex-api/src/main/webapp/WEB-INF/*")) {
    copy($f, "webapp/WEB-INF/".basename($f));
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

# creates project packages
sub pkg {
  my $name = shift;
  print "* Create $name-$version package\n";
  foreach my $f(glob("../$name/target/*")) { unlink $f; }
  foreach my $f(glob("../$name/lib/*")) { unlink $f; }
  system("cd ../$name && mvn install -q -DskipTests");
  move("../$name/target/$name-$version.jar", "$release/$name.jar");
}

# creates the zip archive
sub zip {
  print "* Create ZIP file\n";

  my $zip = Archive::Zip->new();

  # Add directories
  my $name = "basex";
  # Add files from disk
  $zip->addDirectory("$name/");
  $zip->addFile("$release/basex.jar", "$name/BaseX.jar");
  $zip->addFile("../$name/license.txt", "$name/license.txt");
  $zip->addFile("../$name/changelog.txt", "$name/changelog.txt");
  $zip->addFile("readme.txt", "$name/readme.txt");
  $zip->addString("", "$name/.basex");

  # Add scripts
  $zip->addDirectory("$name/bin");
  foreach my $file(glob("$release/bin/*")) {
    (my $target = $file) =~ s|.*/|$name/bin/|;
    my $m = $zip->addFile($file, $target);
    $m->unixFileAttributes($file =~ /.bat$/ ? 0644 : 0755);
  }
  # Add database directory
  $zip->addDirectory("$name/data");
  # Add example files
  $zip->addDirectory("$name/etc");
  foreach my $file(glob("etc/*")) {
    $zip->addFile($file, "$name/$file");
  }
  # Add libraries
  $zip->addDirectory("$name/lib");
  foreach my $file(glob("../basex/lib/*"), glob("../basex-api/lib/*"), glob("../basex-dist/lib/*")) {
    next if $file =~ m|/lib/basex-$version|;
    (my $target = $file) =~ s|.*/|$name/lib/|;
    $zip->addFile($file, $target);
  }
  $zip->addFile("$release/basex-api.jar", "$name/lib/basex-api.jar");
  # Add repository directory
  $zip->addDirectory("$name/repo");
  # Add webapp directory
  $zip->addDirectory("$name/webapp");
  foreach my $file(glob("webapp/*")) {
    $zip->addFile($file, "$name/$file") if -f $file;
  }
  $zip->addDirectory("$name/webapp/WEB-INF");
  foreach my $file(glob("webapp/WEB-INF/*")) {
    $zip->addFile($file, "$name/$file");
  }
  $zip->addDirectory("$name/webapp/restxq");
  foreach my $file(glob("webapp/restxq/*")) {
    $zip->addFile($file, "$name/$file");
  }

  # save the zip file
  unless ($zip->writeToFileNamed("$release/BaseX.zip") == AZ_OK ) {
    die "Could not write ZIP file.";
  }
  #unlink("$release/basexhttp.bat");
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
  foreach my $file(glob("../basex/lib/*"), glob("../basex-api/lib/*"), glob("../basex-dist/lib/*")) {
    next if $file =~ m|/lib/basex-|;
    (my $target = $file) =~ s|.*/|BaseX.app/Contents/Resources/Java/repo/lib/|;
    $zip->addFile($file, $target);
  }
  $zip->addFile("$release/basex-api.jar", 
    "BaseX.app/Contents/Resources/Java/repo/lib/basex-api.jar");
  $zip->addFile("$release/basex.jar",
    "BaseX.app/Contents/Resources/Java/repo/org/basex/basex/$version/basex-$version.jar");

  # save the zip file
  unless ($zip->writeToFileNamed("$release/BaseX.app.zip") == AZ_OK ) {
    die "Could not write APP file.";
  }
}

# creates the installer
sub exe {
  print "* Create executable\n";

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
  move("$release/BaseX.app.zip", "$release/BaseX$v.app.zip");
  move("$release/BaseX.zip", "$release/BaseX$v.zip");
  move("$release/basex.jar", "$release/BaseX$v.jar");
  move("$release/basex.war", "$release/BaseX$v.war");
  move("$release/BaseX.exe", "$release/BaseX$v.exe");
  unlink("$release/basex-api.jar");
  rmtree("release/bin");
  rmtree("webapp");
}
