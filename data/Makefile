# Variáveis
SQLITE = /usr/bin/sqlite3
CSV_DIR = csv
DOWN_LOAD_CSV = ./scripts/dowload.sh
GENERATE_SQL = ./scripts/generate_sql.sh
DATA_SQL = data.sql
DATA_BASE = database.db
DATA_BASE_TABLES = tables/*.sql
GENERATE_GRAPH = ./scripts/generate_graph.R
GENERATE_GRAPH_FILE = ./scripts/generate_graph_file.R
GRAPH_FILE = freq_subgraph.txt

freq_subgraph.txt: graph
	 $(GENERATE_GRAPH_FILE)

graph: database
	$(GENERATE_GRAPH)
	
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
	rm -f $(GRAPH_FILE)
