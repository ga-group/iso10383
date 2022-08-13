#!/usr/bin/mawk -f

BEGIN {
	FS = OFS = "\t"
	symm["dct:replaces"] = "dct:isReplacedBy"
	symm["dct:isReplacedBy"] = "dct:replaces"
}
($2 == "dct:replaces") || ($2 == "dct:isReplacedBy") {
	print
        gsub(/ \./, "", $3)
	tmp = $1
	$1 = $3
	$3 = tmp " ."
	$2 = symm[$2]
	print
}
/^@/
