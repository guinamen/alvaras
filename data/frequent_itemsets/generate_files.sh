#!/bin/bash

echo "@CONVERTED_FROM_TEXT"
while IFS= read -r line
do
	IFS='|'
	read -ra arrIN <<< "$line"
	echo "@ITEM=${arrIN[0]}=${arrIN[1]}"

done < <(echo "select distinct id, descricao from atividade inner join cnae on cnae.codigo = SUBSTR(atividade, 1,LENGTH(atividade)-2) order by id;" | sqlite3 ../database.db)

while IFS= read -r line
do
	echo "${line}"

done < <(echo "select GROUP_CONCAT(id,' ') from atividade inner join cnae on cnae.codigo = SUBSTR(atividade, 1,LENGTH(atividade)-2) group by alvara ;" | sqlite3 ../database.db)

