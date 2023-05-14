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

cities <- fread("iso	fibo
Berne	Bern
Boca Raton	BocaRaton
Bryanston, Sandton	BryanstonSandton
Bucharest	Bucarest
Cluj Napoca	ClujNapoca
Dar Es Salaam	Dar_es_Salaam
Duesseldorf	Dusseldorf
Cybercity, Ebene	Ebene
Ebene City	Ebene
Frankfurt Am Main	Frankfurt
Gift City, Gandhinagar	GIFT_City
Kyiv	Kiev
Klagenfurt Am Woerthersee	Klagenfurt_am_Woerthersee
Kuwait	Kuwait_City
Lisboa	Lisbon
Mexico	Mexico_City
Milano	Milan
Muenchen	Munich
Delhi	New_Delhi
Nicosia (lefkosia)	Nicosia
Palma De Mallorca	PalmaDeMallorca
Panama	Panama_City
Vila	Port_Vila
Port Of Spain	Port_of_Spain
Rio De Janeiro	Rio_de_Janeiro
Roma	Rome
Saint-petersburg	Saint-Petersburg
St Albans	StAlbans
St.  Peter Port	Saint_Peter_Port
Sea Girt	SeaGirt
St Albans	StAlbans
The Woodlands	TheWoodlands
Torino	Turin
Washington/new York	Washington_New_York
S-hertogenbosch	s-Hertogenbosch
")

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
