#!/usr/bin/env bash

sed '/<HealthData/q' $1 | awk '/ATTLIST/{print $2}; /CDATA/{print "-"$1}'
