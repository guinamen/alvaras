CREATE TABLE "grafo_secao" (
	"ano_mes"	TEXT NOT NULL,
	"atividade_a"	TEXT NOT NULL,
	"atividade_b"	TEXT NOT NULL,
	"total"	INTEGER NOT NULL,
	CHECK (total > 0),
	FOREIGN KEY("ano_mes") REFERENCES carga("ano_mes"),
	FOREIGN KEY("atividade_a") REFERENCES secao("codigo"),
	FOREIGN KEY("atividade_b") REFERENCES secao("codigo"),
	PRIMARY KEY("ano_mes","atividade_a","atividade_b")
);
CREATE TABLE "grafo_secao_bimestre" (
	"ano_mes"	INTEGER NOT NULL,
	"atividade_a"	TEXT NOT NULL,
	"atividade_b"	TEXT NOT NULL,
	"total"	INTEGER NOT NULL,
	CHECK (total > 0),
	FOREIGN KEY("ano_mes") REFERENCES carga("bimestre"),
	FOREIGN KEY("atividade_a") REFERENCES secao("codigo"),
	FOREIGN KEY("atividade_b") REFERENCES secao("codigo"),
	PRIMARY KEY("ano_mes","atividade_a","atividade_b")
);
CREATE TABLE "grafo_secao_trimestre" (
	"ano_mes"	INTEGER NOT NULL,
	"atividade_a"	TEXT NOT NULL,
	"atividade_b"	TEXT NOT NULL,
	"total"	INTEGER NOT NULL,
	CHECK (total > 0),
	FOREIGN KEY("ano_mes") REFERENCES carga("trimestre"),
	FOREIGN KEY("atividade_a") REFERENCES secao("codigo"),
	FOREIGN KEY("atividade_b") REFERENCES secao("codigo"),
	PRIMARY KEY("ano_mes","atividade_a","atividade_b")
);

CREATE TABLE "grafo_secao_quadrimestre" (
	"ano_mes"	INTEGER NOT NULL,
	"atividade_a"	TEXT NOT NULL,
	"atividade_b"	TEXT NOT NULL,
	"total"	INTEGER NOT NULL,
	CHECK (total > 0),
	FOREIGN KEY("ano_mes") REFERENCES carga("quadrimestre"),
	FOREIGN KEY("atividade_a") REFERENCES secao("codigo"),
	FOREIGN KEY("atividade_b") REFERENCES secao("codigo"),
	PRIMARY KEY("ano_mes","atividade_a","atividade_b")
);

CREATE TABLE "grafo_divisao" (
	"ano_mes"	TEXT NOT NULL,
	"atividade_a"	TEXT NOT NULL,
	"atividade_b"	TEXT NOT NULL,
	"total"	INTEGER NOT NULL,
	CHECK (total > 0),
	FOREIGN KEY("ano_mes") REFERENCES carga("ano_mes"),
	FOREIGN KEY("atividade_a") REFERENCES divisao("codigo"),
	FOREIGN KEY("atividade_b") REFERENCES divisao("codigo"),
	PRIMARY KEY("ano_mes","atividade_a","atividade_b")
);
CREATE TABLE "grafo_grupo" (
	"ano_mes"	TEXT NOT NULL,
	"atividade_a"	TEXT NOT NULL,
	"atividade_b"	TEXT NOT NULL,
	"total"	INTEGER NOT NULL,
	CHECK (total > 0),
	FOREIGN KEY("ano_mes") REFERENCES carga("ano_mes"),
	FOREIGN KEY("atividade_a") REFERENCES grupo("codigo"),
	FOREIGN KEY("atividade_b") REFERENCES grupo("codigo"),
	PRIMARY KEY("ano_mes","atividade_a","atividade_b")
);
CREATE TABLE "grafo_classe" (
	"ano_mes"	TEXT NOT NULL,
	"atividade_a"	TEXT NOT NULL,
	"atividade_b"	TEXT NOT NULL,
	"total"	INTEGER NOT NULL,
	CHECK (total > 0),
	FOREIGN KEY("ano_mes") REFERENCES carga("ano_mes"),
	FOREIGN KEY("atividade_a") REFERENCES classe("codigo"),
	FOREIGN KEY("atividade_b") REFERENCES classe("codigo"),
	PRIMARY KEY("ano_mes","atividade_a","atividade_b")
);
