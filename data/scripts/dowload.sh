#!/bin/bash
if [ -z "$1" ]; then
    echo "Erro: nenhum parâmetro fornecido."
    echo "Uso: $0 <parametro>"
    exit 1
fi

wget -O - https://dados.pbh.gov.br/dataset/alvaras-de-localizacao-e-funcionamento-emitidos |grep '<a class="dropdown-item resource-url-analytics"' | grep csv | sed 's/<a.*href="//g' | sed 's/".*$//g' | sed 's/\s*//g' | xargs wget -P $1
rm $1/2021-12_alvaras_localizacao_funcionamento_emitidos.csv
mv $1/2021-12_alvaras_localizacao_funcionamento_emitidos_v2.csv $1/2021-12_alvaras_localizacao_funcionamento_emitidos.csv
