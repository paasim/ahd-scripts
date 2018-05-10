#!/usr/bin/env bash

# print the column names
echo "ts hr"

# HKQuantity is used to identify the records
grep "HKQuantityTypeIdentifierHeartRate\|<low value\|<value xsi" $1 |
  # print <low value and <value after HKQuantity
  awk '/HeartRate/ {pr=3} pr>0 { pr-- ; print}' |
  # keep only the (numeric) values, tr used to remove unnecessary "
  grep -o '[0-9+]\+' |
  # transform to tabular format
  awk 'ORS=NR%2?FS:RS'
