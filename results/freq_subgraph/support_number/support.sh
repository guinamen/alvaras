#!/bin/bash

val=0.5
str=''
while (( $(echo "$val >= 0.3" | bc -l) )); do
    result=$(java -jar ~/Downloads/spmf.jar run GSPAN $1 /dev/null $val 1000 false |grep -e Frequent -e Minsup | sed 's/[^0-9]*//g')
    val=$(echo "$val - 0.01" | bc)
    echo $result
done 
