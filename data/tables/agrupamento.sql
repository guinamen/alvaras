CREATE TABLE "agrupamento_classe" (
	"id"	INTEGER NOT NULL,
	"min"	INTEGER NOT NULL,
	"max"	INTEGER NOT NULL,
	CHECK(min > 0),
	CHECK(max > 0),
	PRIMARY KEY("id" AUTOINCREMENT)
);

