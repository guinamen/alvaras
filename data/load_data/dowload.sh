#!/bin/bash

wget -O - https://dados.pbh.gov.br/dataset/alvaras-de-localizacao-e-funcionamento-emitidos |grep '<a class="dropdown-item resource-url-analytics"' | grep csv | sed 's/<a.*href="//g' | sed 's/".*$//g' | sed 's/\s*//g' | xargs wget
rm 2021-12_alvaras_localizacao_funcionamento_emitidos.csv
mv 2021-12_alvaras_localizacao_funcionamento_emitidos_v2.csv 2021-12_alvaras_localizacao_funcionamento_emitidos.csv
