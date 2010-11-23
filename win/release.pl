# Creates all files for a new release.
# 
# (C) Workgroup DBIS, University of Konstanz 2005-10, ISC License

use warnings;
use strict;

#home of programs
my $programs = "C:/Programme";
# home of basex projects
my $basexh = "C:\\JPs";
# home of launch4j
my $launch4j = "$programs/Launch4j/launch4jc.exe";
# home of nsis
my $nsis = "$programs/NSIS/makensis.exe /V1";
# versions
my $f = "";
my $v = "";

clean();
version();
pkg("basex");
pkg("basex-api");
modl4J();
launch4J();
nsis();
drop();

# cleans possible files
sub clean {
exc("del BaseX.jar");
exc("del launch4jtmp.xml");
exc("del BaseX.exe");
}

# gets version from pom file
sub version {
  open(POM, "$basexh\\BaseX\\pom.xml");
  my @raw_data=<POM>;
  my $c = 1;
  foreach my $line (@raw_data) {
    if($c == 7) {
      my $pos = index($line, "</version>") - 11;
      $v = substr $line, 11, $pos;
      if (length($v) == 3) {
      $f = $v . ".0.0";
      } elsif (length($v) == 5) {
      $f = $v . ".0";
      } 
    }
    $c++;
  }
  close(POM);
}

# packages both projects
sub pkg {
  my $name = shift;
  exc("del $basexh\\$name\\target\\*.jar");
  exc("cd $basexh\\$name && mvn package -DskipTests=true");
}

# modifies the launch4j xml
sub modl4J {
  open(L4J, "launch4j.xml");
  my @raw_data=<L4J>;
  open (L4JTMP, '>>launch4jtmp.xml');
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
exc("copy $basexh\\basex\\target\\basex-$v.jar");
exc("ren basex-$v.jar BaseX.jar");
exc($launch4j." launch4jtmp.xml");
}

# launch nsis
sub nsis {
exc($nsis." installer/BaseX.nsi");
}

# deletes tmp files
sub drop {
exc("del BaseX.jar");
exc("del launch4jtmp.xml");
exc("del BaseX.exe");  
}

# executes a command
sub exc {
  my $cmd = shift;
  print "\n> $cmd\n";
  system "$cmd";
  sleep 1;
}