#!/bin/bash
#
# Script     : build.sh
# Usage      : ./build.sh
# Author     : Giuseppe Totaro
# Date       : 05/02/2015 [MM-DD-YYYY]
# Last Edited: 
# Description: This scripts runs compiles all .java files for StudyExtractor.
# Notes      : Run this script in the parent folder of StudyExtractor.
#

TIKA="lib/tika-app-1.8.jar"

if [ ! -e $TIKA ]
then
	echo "Error: this program requires Apache Tika 1.8 library!"
	exit 1
fi

mkdir -p StudyExtractor/bin

for file in $(find . -name "*.java" -print)
do
	javac -cp ./:$TIKA -d ./StudyExtractor/bin ${file}
done
