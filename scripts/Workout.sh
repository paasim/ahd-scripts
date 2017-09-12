#! /usr/local/bin/bash

awk '/^ <Workout /{pr=1;} ; /^ <ActivitySummary /{pr=0} ; pr{print $0}' $1 >> $2
