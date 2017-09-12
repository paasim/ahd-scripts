#! /usr/local/bin/bash

grep '^ <Record \|^ </Record>' $1 | grep -v 'AppleStandHour' >> $2
