PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX : <local#>

CONSTRUCT {
:cons.wd-align.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "there must be exactly one alignment with wikidata" ;
		sh:resultSeverity sh:Violation ;
		sh:sourceShape :cons.wd-align ;
		sh:value ?value ;
	] .
}
WHERE {
	?this skos:closeMatch ?anything .
	OPTIONAL {
	SELECT ?this (COUNT(?x) AS ?value) WHERE {
	?this skos:closeMatch ?x .
	FILTER(STRSTARTS(STR(?x), STR(wd:)))
	} GROUP BY ?this
	}
	FILTER(!BOUND(?value) || ?value != 1)
}

PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX gn: <http://sws.geonames.org/>
PREFIX : <local#>

CONSTRUCT {
:cons.gn-align.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "there must be exactly one alignment with geonames" ;
		sh:resultSeverity sh:Violation ;
		sh:sourceShape :cons.gn-align ;
		sh:value ?value ;
	] .
}
WHERE {
	?this skos:closeMatch ?anything .
	OPTIONAL {
	SELECT ?this (COUNT(?x) AS ?value) WHERE {
	?this skos:closeMatch ?x .
	FILTER(STRSTARTS(STR(?x), STR(gn:)))
	} GROUP BY ?this
	}
	FILTER(!BOUND(?value) || ?value != 1)
}
