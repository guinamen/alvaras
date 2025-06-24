# Variáveis
SQLITE = /usr/bin/sqlite3
CSV_DIR = csv
DOWN_LOAD_CSV = ./dowload.sh
GENERATE_SQL = ./generate_sql.sh
DATA_SQL = data.sql
DATA_BASE = database.db
DATA_BASE_TABLES = tables/*.sql

freq_subgraph.txt: graph
	./generate_graph_file.R

graph: database
	./generate_graph.R

database: data.sql
	cat $(DATA_BASE_TABLES) | $(SQLITE) $(DATA_BASE)
	cat $(DATA_SQL) | $(SQLITE) $(DATA_BASE)

data.sql: generate_csv
	$(GENERATE_SQL) $(CSV_DIR) > $(DATA_SQL)

generate_csv:
	mkdir -p $(CSV_DIR)
	chmod +x $(DOWN_LOAD_CSV)
	$(DOWN_LOAD_CSV) $(CSV_DIR)
	

clean:
	rm -rf $(CSV_DIR)
	rm -f $(DATA_SQL)
	rm -f $(DATA_BASE)
