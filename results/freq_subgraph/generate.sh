#!/bin/bash

FILE="$1"
GRAPH_FILE="../../data/freq_subgraph.txt"

if [ -f "$FILE" ]; then
  echo "Removendo arquivo: $FILE"
  rm "$FILE"
fi
touch $FILE
java -jar ~/Downloads/spmf.jar run GSPAN $GRAPH_FILE  $FILE $2 1000 false > log.txt

