#!/bin/sh

if [ ! -x /usr/bin/txt2man ]; then
  echo 'txt2man is used to produce manpages (please consider installing it).';
  echo '# apt-get install txt2man';
  exit 1;
fi

for i in basex basexgui basexclient basexserver; do
  /usr/bin/txt2man -s1 -t$i -v"The XML Database" ./$i.txt >./$i.1;
done;

echo "Fixing '-' in RESTORE command"
/bin/sed -ie 's/RESTORE \[name /RESTORE \[name\\-/' basex.1
