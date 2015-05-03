# cTAKES_test
This repository includes a collection of code and scripts to run and test Apache cTAKES on plain text.

[Apache cTAKES](http://ctakes.apache.org/) is a natural language processing system for extraction of information from electronic medical record clinical free-text. cTAKES stands for clinical Text Analysis and Knowledge Extraction System.

## Getting started

To run cTAKES against plain text, you can launch the following script:

> ./run_ctakes.sh -i /path/to/input -o /path/to/output -u user -p pass [-c /path/to/ctakes]

You may request a UMLS username and password at [UMLS Terminology Services](https://uts.nlm.nih.gov/license.html). Furthermore, you can specify the pathname to CTAKES_HOME; by default, the scripts looks for cTAKES into /usr/local.
