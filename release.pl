# Creates all files for a new release.
#
# (C) BaseX Team, BSD License

use warnings;
use strict;
use File::Basename;
use File::Copy;
use File::Path;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use File::Copy::Recursive qw(rcopy);

# path to main class
my $main = "org.basex.BaseXGUI";

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
  mkdir "release/";

  # extract pom version
  version();

  # create artifacts
  artifacts();
  copy("../basex/basex-core/target/basex-$version.jar", "release/BaseX.jar");
  copy("../basex/basex-api/target/basex-api-$version.jar", "release/basex-api-$version.jar");

  # prepare start scripts
  mkdir "release/bin/";
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
      next if $l =~ m|^CORE=|;
      $l =~ s|target[/\\]classes|BaseX.jar|;
      $l =~ s|;%MAIN%[/\\]\.\.[/\\]basex-core[/\\]lib[/\\]\*||;
      $l =~ s|:\$CORE[/\\]lib[/\\]\*||;
      print $out $l;
    }
    close($in);
    close($out);
  }

  # assemble webapp files
  rcopy("../basex/basex-api/src/main/webapp/", "release/webapp/");
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
  system('cd ../basex && mvn install -q -DskipTests');
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

  my $source = "release/";
  my $target = "release/basex";
  mkdir "$source/basex/";
  rcopy("$source/BaseX.jar", "$target/BaseX.jar");
  rcopy("../basex/LICENSE", $target);
  rcopy("../basex/CHANGELOG", $target);
  rcopy("readme.txt", $target);
  rcopy(".basexhome", $target);
  mkdir "$target/bin/";
  rcopy("$source/bin/", "$target/bin/");
  mkdir "$target/data/";
  mkdir "$target/data/.logs/";
  mkdir "$target/etc/";
  rcopy("etc/", "$target/etc/");
  mkdir "$target/lib/";
  foreach my $file(
    glob("../basex/basex-core/lib/*"),
    glob("../basex/basex-api/lib/*"),
    glob("lib/*")
  ) {
    rcopy($file, "$target/lib") if $file !~ m|/lib/basex-$version|;
  }
  mkdir "$target/lib/custom/";
  rcopy("$source/basex-api-$version.jar", "$target/lib/basex-api-$version.jar");
  mkdir "$target/repo/";
  rcopy("repo/", "$target/repo/");
  mkdir "$target/src/";
  rcopy("src/", "$target/src/");
  mkdir "$target/webapp/";
  rcopy("$source/webapp/", "$target/webapp/");

  my $zip = Archive::Zip->new();
  zip_rec($zip, $target, "basex");
  # save the zip file
  $zip->writeToFileNamed("release/BaseX.zip") == AZ_OK or
    die "Could not write ZIP file.";
}

# recursively add zip files
sub zip_rec {
  my $zip = shift;
  my $source = shift;
  my $target = shift;
  # Parse files
  foreach my $file(glob("$source/.* $source/*")) {
    next if $file =~ /\.$/;
    my $trg = "$target/".basename($file);
    if(-d $file) {
      $zip->addDirectory($trg);
      zip_rec($zip, $file, $trg);
    } else {
      my $f = $zip->addFile($file, $trg);
      $f->unixFileAttributes($file =~ /\./ ? 0644 : 0755);
    }
  }
};


# creates the war file
sub war {
  print "* Create WAR file\n";

  # create WAR file
  system("cd ../basex/basex-api && mvn war:war");
  move("../basex/basex-api/target/basex-api-$version.war", "release/basex.war");
}

# creates the installer
sub exe {
  print "* Create EXE file\n";

  # prepare installer
  open(my $in, "win/BaseX.nsi");
  open(my $out, ">win/tmp.nsi");
  foreach my $line (<$in>) {
    $line =~ s/0\.0\.0\.0/$full/;
    print $out $line;
  }
  close($in);
  close($out);

  # create installer
  system("$nsis win/tmp.nsi");
  move("win/Setup.exe", "release/BaseX.exe");
  unlink("win/tmp.nsi");
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

  # artifact base name: "BaseX124" for a release, "BaseX130-20260706.234438"
  # for a snapshot (a version with a "-SNAPSHOT" qualifier gets a timestamp).
  (my $digits = $version) =~ s/-.*//;   # strip qualifier: 13.0-SNAPSHOT -> 13.0
  $digits =~ s/\.//g;                    # remove dots:      13.0        -> 130
  my $name = "BaseX$digits";
  if($version =~ /-/) {
    my ($sec, $min, $hou, $day, $mon, $yr) = localtime();
    $name .= sprintf("-%04d%02d%02d.%02d%02d%02d",
      $yr + 1900, $mon + 1, $day, $hou, $min, $sec);
  }
  print "* Artifact name: $name\n";

  # BaseX.app.zip is built on macOS only; skip the rename when it is absent.
  move("release/BaseX.app.zip", "release/$name.app.zip") if -e "release/BaseX.app.zip";
  move("release/BaseX.zip", "release/$name.zip");
  move("release/BaseX.jar", "release/$name.jar");
  move("release/basex.war", "release/$name.war");
  move("release/BaseX.exe", "release/$name.exe");
  unlink("release/basex-api-$version.jar");
  rmtree("release/basex");
  rmtree("release/bin");
  rmtree("release/webapp");
}
