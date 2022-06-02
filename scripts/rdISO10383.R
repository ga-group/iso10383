#!/home/freundt/usr/bin/Rscript --vanilla

library(readxl)
library(data.table)

if (sys.nframe() == 0L) {
	args <- commandArgs(trailingOnly=TRUE)
	outf <- ""

	x <- rbindlist(lapply(lapply(args, read_excel), as.data.table), use.names=TRUE)
	x[, WEBSITE:=tolower(WEBSITE)]
	x[!is.na(WEBSITE) & !grepl("^https?://", WEBSITE), WEBSITE:=paste0("http://",WEBSITE)]
	x[!is.na(WEBSITE) & !grepl("https?://.*/", WEBSITE), WEBSITE:=paste0(WEBSITE, "/")]

	fwrite(x, outf, na="", sep='\t', quote=FALSE)
}
