#!/bin/bash
# wget -O - https://dados.pbh.gov.br/dataset/alvaras-de-localizacao-e-funcionamento-emitidos |grep '<a class="dropdown-item resource-url-analytics"' | grep csv | sed 's/<a.*href="//g' | sed 's/".*$//g' | sed 's/\s*//g' | xargs wget

if [ -z "$1" ]; then
    echo "Erro: nenhum parâmetro fornecido."
    echo "Uso: $0 <parametro>"
    exit 1
fi


echo "BEGIN;"
echo 'CREATE TABLE "carga" ("ano_mes" TEXT NOT NULL, "bimestre" INTEGER, "trimestre" INTEGER, "quadrimestre" INTEGER, PRIMARY KEY('ano_mes'));'
#echo "CREATE TABLE 'carga' ('ano_mes'	TEXT NOT NULL, PRIMARY KEY('ano_mes'));"
echo "CREATE TABLE 'alvara' ('codigo'	TEXT NOT NULL UNIQUE,'ano_mes'	TEXT NOT NULL,'regional'	TEXT NOT NULL,'area'	NUMERIC NOT NULL CHECK('area' > 0),FOREIGN KEY('ano_mes') REFERENCES 'carga'('ano_mes'),FOREIGN KEY('regional') REFERENCES 'regional'('regional'),PRIMARY KEY('codigo','ano_mes'));"
echo "CREATE TABLE 'atividade' ('alvara'	TEXT NOT NULL,'atividade'	TEXT NOT NULL,PRIMARY KEY('alvara','atividade'),FOREIGN KEY('alvara') REFERENCES 'alvara'('codigo'));"

for filename in $1/*.csv; do
	ANO_MES=$(echo $filename | sed 's/_alvaras_localizacao_funcionamento_emitidos.csv//g' | sed 's/^.*20/20/g' |  sed 's/\.\///g')
	INSERT_CARGA=$(echo "INSERT INTO carga (ano_mes) VALUES ('$ANO_MES');")
	echo $INSERT_CARGA
	l_number=0
	while IFS= read -r line; do
		if [ $l_number -gt 0 ]; then
			IFS=';'
			read -ra arrIN <<< "$line"
			echo "INSERT INTO alvara VALUES('${arrIN[0]}', '$ANO_MES', '${arrIN[3]}', ${arrIN[5]});"
			IFS=', '
			read -ra ATIVIDADES <<< "${arrIN[4]}"
			for ATIVIDADE in "${ATIVIDADES[@]}";
			do
				if [ -n "${ATIVIDADE}" ]; then
					echo "INSERT INTO atividade VALUES ('${arrIN[0]}','$ATIVIDADE');"
				fi
			done
		fi
		l_number=$((l_number + 1))
    	done < "$filename"
done
echo "END;"
echo "WITH numeradas AS (SELECT ano_mes, ROW_NUMBER() OVER (ORDER BY ano_mes) AS rn FROM carga ) UPDATE carga SET bimestre = (SELECT (rn - 1) / 2 FROM numeradas WHERE numeradas.ano_mes = carga.ano_mes);"
echo "WITH numeradas AS (SELECT ano_mes, ROW_NUMBER() OVER (ORDER BY ano_mes) AS rn FROM carga) UPDATE carga SET trimestre = (SELECT (rn - 1) / 3 FROM numeradas WHERE numeradas.ano_mes = carga.ano_mes);"
echo "WITH numeradas AS (SELECT ano_mes, ROW_NUMBER() OVER (ORDER BY ano_mes) AS rn FROM carga) UPDATE carga SET quadrimestre = (SELECT (rn - 1) / 4 FROM numeradas WHERE numeradas.ano_mes = carga.ano_mes);"

