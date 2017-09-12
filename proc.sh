#! /usr/local/bin/bash
temp=temp.xml
name="${1%.*}" # remove file extension
export=$2

echo "<d>" > $temp
scripts/$name.sh $export $temp
echo "</d>" >> $temp

R -f R/$name.R --args $temp res/$name.feather
rm $temp
