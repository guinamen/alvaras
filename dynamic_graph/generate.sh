#!/bin/bash

OUTPUT="$(ruby circle.rb)"
echo "graph {"
echo 'graph ['
echo 'overlap = false'
echo 'outputorder = edgesfirst'
echo  'splines=true'
echo  ']'

echo '{'
echo 'node [width=0.1 height=0.1 margin=0.1 fontcolor=black fontsize=11 shape=box style="filled,rounded" fillcolor=lightcoral ];'
echo $OUTPUT
echo '}'

while IFS= read -r line
do
	IFS='|'
	read -ra arrIN <<< "$line"
	echo "  ${arrIN[0]}--${arrIN[1]} [label="${arrIN[2]}" fontsize=11];"

done < <(echo "select no1, no2, total from secao where ano_mes = '$1';" | sqlite3 graph.db)

echo "}"
