#!/bin/bash
if [ $1 ]; then
  basex -bbasex-version=$1 homebrew-basex.xq 
else
  basex homebrew-basex.xq
fi