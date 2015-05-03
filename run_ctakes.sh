#!/bin/bash
#
# Script     : run_ctakes.sh
# Usage      : ./run_ctakes.sh -i /path/to/input -o /path/to/output -u user -p password [-c /path/to/ctakes]
# Author     : Giuseppe Totaro
# Date       : 04-30-2015 [MM-DD-YYYY]
# Last Edited: 05-02-2015, Giuseppe Totaro
# Description: This scripts relies on Apache cTAKES to run BagOfCUIsGenerator 
#              that extracts CUIs (CUI stands for Concept Unique Identifier) 
#              from each file in the given directory. 
# Notes      : The UMLS database (including CUIs) is available online:
#              https://uts.nlm.nih.gov/home.html
#

function usage() {
        echo "Usage: run_ctakes.sh -i /path/to/input -o /path/to/output -u user -p password [-c /path/to/ctakes]"
        exit 1
}

INPUT=""
OUTPUT=""
UMLS_USER=""
UMLS_PASS=""
CTAKES_HOME=""

while [ "$1" != ""  ] 
do
        case $1 in
                -i|--input)
                INPUT="$2"
                shift
                ;;  
                -o|--output)
                OUTPUT="$2"
                shift
                ;;  
                -u|--user)
                UMLS_USER=$2
                shift
                ;;  
                -p|--password)
                UMLS_PASS=$2
                shift
                ;;
		-c|--ctakes-home)
		CTAKES_HOME=$2
                shift
		;;
                *)  
                usage
                ;;  
        esac
	shift
done

if [ $INPUT == "" ] || [ $OUTPUT == "" ] || [ $UMLS_USER == "" ] || [ $UMLS_PASS == "" ]
then
        usage
fi

UMLS_USER="-Dctakes.umlsuser=${UMLS_USER}"
UMLS_PASS="-Dctakes.umlspw=${UMLS_PASS}"
[[ $CTAKES_HOME == "" ]] && CTAKES_HOME=/usr/local/apache-ctakes-3.2.1

JARS=($(find ${CTAKES_HOME}/lib -iname "*.jar" -type f))
SAVE_IFS=$IFS
IFS=$":"
JOIN="${JARS[*]}"
IFS=$SAVE_IFS

current_dir=$PWD
cd $CTAKES_HOME/desc/ctakes-clinical-pipeline

java -Dctakes.umlsuser=gostep -Dctakes.umlspw=Mazza31av -cp $CTAKES_HOME/desc/:$CTAKES_HOME/resources/:$JOIN -Dlog4j.configuration=file:$CTAKES_HOME/config/log4j.xml -Xms512M -Xmx3g org.apache.ctakes.clinicalpipeline.runtime.BagOfCUIsGenerator ${INPUT} ${OUTPUT}

cd $current_dir

echo "Process completed. Output: ${OUTPUT}"
