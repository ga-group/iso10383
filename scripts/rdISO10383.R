#!/home/freundt/usr/bin/Rscript --vanilla

library(readxl)
library(data.table)

capwords <- function(s, strict = FALSE)
{
	cap <- function(s) {
		paste(toupper(substring(s, 1, 1)),tolower(substring(s, 2)), sep="", collapse=" ")
	}
	sapply(strsplit(s, split = " "), cap, USE.NAMES=!is.null(names(s)))
}

cities <- setkey(fread("iso	fibo
Aichi	Nagoya
Alberta	Calgary
Antwerpen	Antwerp
Bermuda	Hamilton
Berne	Bern
Boca Raton	BocaRaton
Bryanston, Sandton	BryanstonSandton
Bryanston - Sandton	BryanstonSandton
Bucarest	Bucharest
Calcutta	Kolkata
Cluj Napoca	ClujNapoca
Cybercity, Ebene	Ebene
Dar Es Salaam	Dar_es_Salaam
Delhi	New_Delhi
Dusseldorf	Duesseldorf
Ebene City	Ebene
Ekaterinburg	Yekaterinburg
El Salvador	Antiguo_Cuscatlan
Espirito Santo	Vitoria
Firenze	Florence
Frankfurt Am Main	Frankfurt
Genova	Genoa
Gift City, Gandhinagar	GIFT_City
Guatemala	Guatemala_City
Illinois	Glenview
Klagenfurt Am Woerthersee	Klagenfurt_am_Woerthersee
Kuwait	Kuwait_City
Kiev	Kyiv
Lao	Vientiane
Lisboa	Lisbon
Madras	Chennai
Mexico	Mexico_City
Milano	Milan
Montenegro	Podgorica
Muenchen	Munich
Nasau	Nassau
New Jersey	Summit
New York, Ny	New_York
Nicosia (lefkosia)	Nicosia
Nigita	Niigata
Nizhniy Novgorod	Nizhny_Novgorod
Not Applicable	
Palma De Mallorca	PalmaDeMallorca
Panama	Panama_City
Port Of Spain	Port_of_Spain
Rio De Janeiro	Rio_de_Janeiro
Roma	Rome
Rostov	Rostov-on-Don
S-hertogenbosch	s-Hertogenbosch
Saint-petersburg	Saint-Petersburg
Sea Girt	SeaGirt
St Albans	StAlbans
St Albans	StAlbans
St John	St_Johns
St.  Peter Port	Saint_Peter_Port
Taiwan	Taipei
The Woodlands	TheWoodlands
Torino	Turin
Ulaan Baatar	Ulaanbaatar
Unterschleisshem	Unterschleissheim
Vila	Port_Vila
Washington/new York	Washington|New_York
"))

if (sys.nframe() == 0L) {
	args <- commandArgs(trailingOnly=TRUE)
	outf <- ""

	x <- lapply(lapply(args, read_excel, na=c("n/a","N/A")), as.data.table)
	m <- lapply(args, file.mtime)
	mapply(function(dt, t) dt[, accd:=t], x, m)
	x <- rbindlist(x, use.names=TRUE, fill=TRUE)

	x[, WEBSITE:=tolower(WEBSITE)]
	x[!is.na(WEBSITE) & !grepl("^https?://", WEBSITE), WEBSITE:=paste0("http://",WEBSITE)]
#	x[!is.na(WEBSITE) & !grepl("https?://.*/", WEBSITE), WEBSITE:=paste0(WEBSITE, "/")]
	## massage city names
	x[!is.na(CITY), CITY:=capwords(CITY)]
	x[cities, on=c(CITY="iso"), CITY:=i.fibo]

	if (hasName(x, "CREATION-ISO DATE")) {
		x[grepl("^[0-9]{8}", `CREATION-ISO DATE`), `CREATION-ISO DATE`:=as.character(as.IDate(`CREATION-ISO DATE`, format="%Y%m%d"))]
	}
	if (hasName(x, "MODIF-ISO DATE")) {
		x[grepl("^[0-9]{8}", `MODIF-ISO DATE`), `MODIF-ISO DATE`:=as.character(as.IDate(`MODIF-ISO DATE`, format="%Y%m%d"))]
	}
	if (hasName(x, "CREATION DATE")) {
		x[grepl("^[0-9]{8}", `CREATION DATE`), `CREATION DATE`:=as.character(as.IDate(`CREATION DATE`, format="%Y%m%d"))]
	}
	if (hasName(x, "LAST UPDATE DATE")) {
		x[grepl("^[0-9]{8}", `LAST UPDATE DATE`), `LAST UPDATE DATE`:=as.character(as.IDate(`LAST UPDATE DATE`, format="%Y%m%d"))]
	}
	if (hasName(x, "LAST VALIDATION MONTH")) {
		x[grepl("^[0-9]{8}", `LAST VALIDATION MONTH`), `LAST VALIDATION MONTH`:=as.character(as.IDate(`LAST VALIDATION MONTH`, format="%Y%m%d"))]
	}
	if (hasName(x, "LAST VALIDATION DATE")) {
		x[grepl("^[0-9]{8}", `LAST VALIDATION DATE`), `LAST VALIDATION DATE`:=as.character(as.IDate(`LAST VALIDATION DATE`, format="%Y%m%d"))]
	}
	if (hasName(x, "EXPIRY DATE")) {
		x[grepl("^[0-9]{8}", `EXPIRY DATE`), `EXPIRY DATE`:=as.character(as.IDate(`EXPIRY DATE`, format="%Y%m%d"))]
	}

	fwrite(x, outf, na="", sep='\t', quote=FALSE)
}
