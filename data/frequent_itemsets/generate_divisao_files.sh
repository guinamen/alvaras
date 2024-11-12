#!/bin/bash

echo "@CONVERTED_FROM_TEXT"
while IFS= read -r line
do
	IFS='|'
	read -ra arrIN <<< "$line"
	echo "@ITEM=${arrIN[0]}=${arrIN[1]}"

done < <(echo "select distinct id, descricao from atividade inner join cnae_divisao on cnae_divisao.codigo = SUBSTR(atividade, 1,LENGTH(atividade)-7) order by id;" | sqlite3 ../database.db)

while IFS= read -r line2
do
	echo "${line2}"

done < <(echo "select rtrim(replace(group_concat(DISTINCT id||'@!'), '@!,', ' '),'@!') from atividade inner join cnae_divisao on cnae_divisao.codigo = SUBSTR(atividade, 1,LENGTH(atividade)-7) group by alvara ;" | sqlite3 ../database.db)

