#!/bin/sh
MOTIF="(in-package :awele)"
for i in $*
do
    sed  -e "s/^(in-package :awele)//" $i
done
