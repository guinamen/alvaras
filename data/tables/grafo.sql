CREATE TABLE "grafo" (
	"ano_mes"	TEXT NOT NULL,
	"atividade_a"	TEXT NOT NULL,
	"atividade_b"	TEXT NOT NULL,
	"total"	INTEGER NOT NULL,
	CHECK (total >= 0),
	FOREIGN KEY("ano_mes") REFERENCES carga("ano_mes"),
	FOREIGN KEY("atividade_a") REFERENCES secao("codigo"),
	FOREIGN KEY("atividade_b") REFERENCES secao("codigo"),
	PRIMARY KEY("ano_mes","atividade_a","atividade_b")
);
