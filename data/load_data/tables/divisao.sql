PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "divisao" (
	"id" INTEGER NOT NULL,
	"secao"	TEXT NOT NULL,
	"codigo"	TEXT NOT NULL,
	"descricao"	TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	UNIQUE("secao","codigo"),
	FOREIGN KEY("secao") REFERENCES "secao"("codigo")
);
INSERT INTO divisao VALUES(1,'A','01','AGRICULTURA, PECUÁRIA E SERVIÇOS RELACIONADOS * ');
INSERT INTO divisao VALUES(2,'A','02','PRODUÇÃO FLORESTAL * ');
INSERT INTO divisao VALUES(3,'A','03','PESCA E AQÜICULTURA * ');
INSERT INTO divisao VALUES(4,'B','05','EXTRAÇÃO DE CARVÃO MINERAL * ');
INSERT INTO divisao VALUES(5,'B','06','EXTRAÇÃO DE PETRÓLEO E GÁS NATURAL * ');
INSERT INTO divisao VALUES(6,'B','07','EXTRAÇÃO DE MINERAIS METÁLICOS * ');
INSERT INTO divisao VALUES(7,'B','08','EXTRAÇÃO DE MINERAIS NÃO-METÁLICOS * ');
INSERT INTO divisao VALUES(8,'B','09','ATIVIDADES DE APOIO À EXTRAÇÃO DE MINERAIS * ');
INSERT INTO divisao VALUES(9,'C','10','FABRICAÇÃO DE PRODUTOS ALIMENTÍCIOS * ');
INSERT INTO divisao VALUES(10,'C','11','FABRICAÇÃO DE BEBIDAS * ');
INSERT INTO divisao VALUES(11,'C','12','FABRICAÇÃO DE PRODUTOS DO FUMO * ');
INSERT INTO divisao VALUES(12,'C','13','FABRICAÇÃO DE PRODUTOS TÊXTEIS * ');
INSERT INTO divisao VALUES(13,'C','14','CONFECÇÃO DE ARTIGOS DO VESTUÁRIO E ACESSÓRIOS * ');
INSERT INTO divisao VALUES(14,'C','15','PREPARAÇÃO DE COUROS E FABRICAÇÃO DE ARTEFATOS DE COURO, ARTIGOS PARA VIAGEM E CALÇADOS * ');
INSERT INTO divisao VALUES(15,'C','16','FABRICAÇÃO DE PRODUTOS DE MADEIRA * ');
INSERT INTO divisao VALUES(16,'C','17','FABRICAÇÃO DE CELULOSE, PAPEL E PRODUTOS DE PAPEL * ');
INSERT INTO divisao VALUES(17,'C','18','IMPRESSÃO E REPRODUÇÃO DE GRAVAÇÕES * ');
INSERT INTO divisao VALUES(18,'C','19','FABRICAÇÃO DE COQUE, DE PRODUTOS DERIVADOS DO PETRÓLEO E DE BIOCOMBUSTÍVEIS * ');
INSERT INTO divisao VALUES(19,'C','20','FABRICAÇÃO DE PRODUTOS QUÍMICOS * ');
INSERT INTO divisao VALUES(20,'C','21','FABRICAÇÃO DE PRODUTOS FARMOQUÍMICOS E FARMACÊUTICOS * ');
INSERT INTO divisao VALUES(21,'C','22','FABRICAÇÃO DE PRODUTOS DE BORRACHA E DE MATERIAL PLÁSTICO * ');
INSERT INTO divisao VALUES(22,'C','23','FABRICAÇÃO DE PRODUTOS DE MINERAIS NÃO-METÁLICOS * ');
INSERT INTO divisao VALUES(23,'C','24','METALURGIA * ');
INSERT INTO divisao VALUES(24,'C','25','FABRICAÇÃO DE PRODUTOS DE METAL, EXCETO MÁQUINAS E EQUIPAMENTOS * ');
INSERT INTO divisao VALUES(25,'C','26','FABRICAÇÃO DE EQUIPAMENTOS DE INFORMÁTICA, PRODUTOS ELETRÔNICOS E ÓPTICOS * ');
INSERT INTO divisao VALUES(26,'C','27','FABRICAÇÃO DE MÁQUINAS, APARELHOS E MATERIAIS ELÉTRICOS * ');
INSERT INTO divisao VALUES(27,'C','28','FABRICAÇÃO DE MÁQUINAS E EQUIPAMENTOS * ');
INSERT INTO divisao VALUES(28,'C','29','FABRICAÇÃO DE VEÍCULOS AUTOMOTORES, REBOQUES E CARROCERIAS * ');
INSERT INTO divisao VALUES(29,'C','30','FABRICAÇÃO DE OUTROS EQUIPAMENTOS DE TRANSPORTE, EXCETO VEÍCULOS AUTOMOTORES * ');
INSERT INTO divisao VALUES(30,'C','31','FABRICAÇÃO DE MÓVEIS * ');
INSERT INTO divisao VALUES(31,'C','32','FABRICAÇÃO DE PRODUTOS DIVERSOS * ');
INSERT INTO divisao VALUES(32,'C','33','MANUTENÇÃO, REPARAÇÃO E INSTALAÇÃO DE MÁQUINAS E EQUIPAMENTOS * ');
INSERT INTO divisao VALUES(33,'D','35','ELETRICIDADE, GÁS E OUTRAS UTILIDADES * ');
INSERT INTO divisao VALUES(34,'E','36','CAPTAÇÃO, TRATAMENTO E DISTRIBUIÇÃO DE ÁGUA * ');
INSERT INTO divisao VALUES(35,'E','37','ESGOTO E ATIVIDADES RELACIONADAS * ');
INSERT INTO divisao VALUES(36,'E','38','COLETA, TRATAMENTO E DISPOSIÇÃO DE RESÍDUOS; RECUPERAÇÃO DE MATERIAIS * ');
INSERT INTO divisao VALUES(37,'E','39','DESCONTAMINAÇÃO E OUTROS SERVIÇOS DE GESTÃO DE RESÍDUOS * ');
INSERT INTO divisao VALUES(38,'F','41','CONSTRUÇÃO DE EDIFÍCIOS * ');
INSERT INTO divisao VALUES(39,'F','42','OBRAS DE INFRA-ESTRUTURA * ');
INSERT INTO divisao VALUES(40,'F','43','SERVIÇOS ESPECIALIZADOS PARA CONSTRUÇÃO * ');
INSERT INTO divisao VALUES(41,'G','45','COMÉRCIO E REPARAÇÃO DE VEÍCULOS AUTOMOTORES E MOTOCICLETAS * ');
INSERT INTO divisao VALUES(42,'G','46','COMÉRCIO POR ATACADO, EXCETO VEÍCULOS AUTOMOTORES E MOTOCICLETAS * ');
INSERT INTO divisao VALUES(43,'G','47','COMÉRCIO VAREJISTA * ');
INSERT INTO divisao VALUES(44,'H','49','TRANSPORTE TERRESTRE * ');
INSERT INTO divisao VALUES(45,'H','50','TRANSPORTE AQUAVIÁRIO * ');
INSERT INTO divisao VALUES(46,'H','51','TRANSPORTE AÉREO * ');
INSERT INTO divisao VALUES(47,'H','52','ARMAZENAMENTO E ATIVIDADES AUXILIARES DOS TRANSPORTES * ');
INSERT INTO divisao VALUES(48,'H','53','CORREIO E OUTRAS ATIVIDADES DE ENTREGA * ');
INSERT INTO divisao VALUES(49,'I','55','ALOJAMENTO * ');
INSERT INTO divisao VALUES(50,'I','56','ALIMENTAÇÃO * ');
INSERT INTO divisao VALUES(51,'J','58','EDIÇÃO E EDIÇÃO INTEGRADA À IMPRESSÃO * ');
INSERT INTO divisao VALUES(52,'J','59','ATIVIDADES CINEMATOGRÁFICAS, PRODUÇÃO DE VÍDEOS E DE PROGRAMAS DE TELEVISÃO; GRAVAÇÃO DE SOM E EDIÇÃO DE MÚSICA * ');
INSERT INTO divisao VALUES(53,'J','60','ATIVIDADES DE RÁDIO E DE TELEVISÃO * ');
INSERT INTO divisao VALUES(54,'J','61','TELECOMUNICAÇÕES * ');
INSERT INTO divisao VALUES(55,'J','62','ATIVIDADES DOS SERVIÇOS DE TECNOLOGIA DA INFORMAÇÃO * ');
INSERT INTO divisao VALUES(56,'J','63','ATIVIDADES DE PRESTAÇÃO DE SERVIÇOS DE INFORMAÇÃO * ');
INSERT INTO divisao VALUES(57,'K','64','ATIVIDADES DE SERVIÇOS FINANCEIROS * ');
INSERT INTO divisao VALUES(58,'K','65','SEGUROS, RESSEGUROS, PREVIDÊNCIA COMPLEMENTAR E PLANOS DE SAÚDE * ');
INSERT INTO divisao VALUES(59,'K','66','ATIVIDADES AUXILIARES DOS SERVIÇOS FINANCEIROS, SEGUROS, PREVIDÊNCIA COMPLEMENTAR E PLANOS DE SAÚDE * ');
INSERT INTO divisao VALUES(60,'L','68','ATIVIDADES IMOBILIÁRIAS * ');
INSERT INTO divisao VALUES(61,'M','69','ATIVIDADES JURÍDICAS, DE CONTABILIDADE E DE AUDITORIA * ');
INSERT INTO divisao VALUES(62,'M','70','ATIVIDADES DE SEDES DE EMPRESAS E DE CONSULTORIA EM GESTÃO EMPRESARIAL * ');
INSERT INTO divisao VALUES(63,'M','71','SERVIÇOS DE ARQUITETURA E ENGENHARIA; TESTES E ANÁLISES TÉCNICAS * ');
INSERT INTO divisao VALUES(64,'M','72','PESQUISA E DESENVOLVIMENTO CIENTÍFICO * ');
INSERT INTO divisao VALUES(65,'M','73','PUBLICIDADE E PESQUISA DE MERCADO * ');
INSERT INTO divisao VALUES(66,'M','74','OUTRAS ATIVIDADES PROFISSIONAIS, CIENTÍFICAS E TÉCNICAS * ');
INSERT INTO divisao VALUES(67,'M','75','ATIVIDADES VETERINÁRIAS * ');
INSERT INTO divisao VALUES(68,'N','77','ALUGUÉIS NÃO-IMOBILIÁRIOS E GESTÃO DE ATIVOS INTANGÍVEIS NÃO-FINANCEIROS * ');
INSERT INTO divisao VALUES(69,'N','78','SELEÇÃO, AGENCIAMENTO E LOCAÇÃO DE MÃO-DE-OBRA * ');
INSERT INTO divisao VALUES(70,'N','79','AGÊNCIAS DE VIAGENS, OPERADORES TURÍSTICOS E SERVIÇOS DE RESERVAS * ');
INSERT INTO divisao VALUES(71,'N','80','ATIVIDADES DE VIGILÂNCIA, SEGURANÇA E INVESTIGAÇÃO * ');
INSERT INTO divisao VALUES(72,'N','81','SERVIÇOS PARA EDIFÍCIOS E ATIVIDADES PAISAGÍSTICAS * ');
INSERT INTO divisao VALUES(73,'N','82','SERVIÇOS DE ESCRITÓRIO, DE APOIO ADMINISTRATIVO E OUTROS SERVIÇOS PRESTADOS ÀS EMPRESAS * ');
INSERT INTO divisao VALUES(74,'O','84','ADMINISTRAÇÃO PÚBLICA, DEFESA E SEGURIDADE SOCIAL * ');
INSERT INTO divisao VALUES(75,'P','85','EDUCAÇÃO * ');
INSERT INTO divisao VALUES(76,'Q','86','ATIVIDADES DE ATENÇÃO À SAÚDE HUMANA * ');
INSERT INTO divisao VALUES(77,'Q','87','ATIVIDADES DE ATENÇÃO À SAÚDE HUMANA INTEGRADAS COM ASSISTÊNCIA SOCIAL, PRESTADAS EM RESIDÊNCIAS COLETIVAS E PARTICULARES * ');
INSERT INTO divisao VALUES(78,'Q','88','SERVIÇOS DE ASSISTÊNCIA SOCIAL SEM ALOJAMENTO * ');
INSERT INTO divisao VALUES(79,'R','90','ATIVIDADES ARTÍSTICAS, CRIATIVAS E DE ESPETÁCULOS * ');
INSERT INTO divisao VALUES(80,'R','91','ATIVIDADES LIGADAS AO PATRIMÔNIO CULTURAL E AMBIENTAL * ');
INSERT INTO divisao VALUES(81,'R','92','ATIVIDADES DE EXPLORAÇÃO DE JOGOS DE AZAR E APOSTAS * ');
INSERT INTO divisao VALUES(82,'R','93','ATIVIDADES ESPORTIVAS E DE RECREAÇÃO E LAZER * ');
INSERT INTO divisao VALUES(83,'S','94','ATIVIDADES DE ORGANIZAÇÕES ASSOCIATIVAS * ');
INSERT INTO divisao VALUES(84,'S','95','REPARAÇÃO E MANUTENÇÃO DE EQUIPAMENTOS DE INFORMÁTICA E COMUNICAÇÃO E DE OBJETOS PESSOAIS E DOMÉSTICOS * ');
INSERT INTO divisao VALUES(85,'S','96','OUTRAS ATIVIDADES DE SERVIÇOS PESSOAIS * ');
INSERT INTO divisao VALUES(86,'T','97','SERVIÇOS DOMÉSTICOS * ');
INSERT INTO divisao VALUES(87,'U','99','ORGANISMOS INTERNACIONAIS E OUTRAS INSTITUIÇÕES EXTRATERRITORIAIS * ');
COMMIT;
