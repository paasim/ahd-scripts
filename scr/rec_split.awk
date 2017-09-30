BEGIN {
  FS="/"
  n = 0
}
NF==3{
  i++
  if (i % 100000 == 0) n++
}
{
  print >> "xmls/rec"n".lines"
}
