#! /usr/local/bin/bash

echo "xml to line-oriented format and split it into multiple files..."
mkdir -p xmls
rm -f xmls/*
cat $1 | xml2 | awk -f scr/split.awk
rm xmls/@*
echo "done."

echo "split the records into multiple files..."
awk -f scr/rec_split.awk xmls/Record.lines
echo "done."
rm xmls/Record.lines

echo "transform separate files back to xml..."
for f in xmls/* ; do
  cat $f | 2xml > ${f%.*}.xml
  rm $f
done
echo "done."


echo "transform separate xml-files tibbles..."
for f in R/* ; do
  Rscript $f 2>r.out
done
echo "done."

rm xmls/*
