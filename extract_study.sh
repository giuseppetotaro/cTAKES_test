#!/bin/bash
#
# Script     : extract_study.sh
# Usage      : ./run_study.sh /path/to/input /path/to/output
# Author     : Giuseppe Totaro
# Date       : 05-02-2015 [MM-DD-YYYY]
# Last Edited: 05-02-2015, Giuseppe Totaro
# Description: This scripts runs StudyExtractor class (that leverages on Apache 
#              Tika) to extract "Study Title" and "Study Description" fields 
#              from ISA-Tab files and then write the extracted contents for 
#              every study file.
# Notes      : Change "TIKA" and "STUDY_EXTRACTOR" to the actual locations of 
#              Tika jar and StudyExtractor respectively. 
#

if [ $# -lt 2 ]
then
	echo "Usage: $0 /path/to/input /path/to/output"
	exit 1
fi

INPUT=$1
OUTPUT=$2
TIKA="lib/tika-app-1.8.jar"
STUDY_EXTRACTOR="StudyExtractor"

java -cp ${TIKA}:${STUDY_EXTRACTOR}/bin StudyExtractor "$INPUT" "$OUTPUT"

echo "Process completed. Output: ${OUTPUT}"
