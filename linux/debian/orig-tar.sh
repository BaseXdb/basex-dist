#!/bin/sh -e

VERSION=$2
TAR=../basex_$VERSION.orig.tar.gz
DIR=basex-$VERSION
TAG=$(echo "$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export https://svn.uni-konstanz.de/dbis/basex/tags/${TAG}/basex/ $DIR
GZIP=--best tar -c -z -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
