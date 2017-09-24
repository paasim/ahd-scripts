#! /usr/local/bin/awk

BEGIN {
  FS="/"
}
NF>=3{
  print >> "xmls/"$3".lines"
}
