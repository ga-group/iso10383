log_enable(3,1);

SPARQL CREATE SILENT GRAPH <$u{DIFFG}>;
SPARQL CLEAR GRAPH <$u{DIFFG}>;

ECHO "changes ... ";
## -s p A B
## +s p A C
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?d	a delta:Delta ;
		delta:not-yet-applied true ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?p ;
			delta:insertion ?oin ;
			delta:deletion ?oou
		] ;
		delta:patch-date ?dd ;
		rdf:subject ?s ;
		prov:generatedAtTime ?now
}
USING <$u{STAGE}>
USING <$u{GRAPH}>
WHERE {
	BIND(NOW() AS ?now)

	GRAPH <$u{STAGE}> {
	?s ?p ?oin ;
		pav:sourceLastAccessedOn ?dd
	}
	GRAPH <$u{GRAPH}> {
	?s ?p ?oou
	}
	FILTER(?oin != ?oou)
	FILTER NOT EXISTS {
		GRAPH <$u{STAGE}> {
		?s ?p ?oou
		}
	}
	FILTER NOT EXISTS {
		GRAPH <$u{GRAPH}> {
		?s ?p ?oin
		}
	}
	FILTER(?p != rdf:type)
	FILTER(?p != pav:sourceLastAccessedOn)
	FILTER(?p != pav:sourceAccessedOn)
	FILTER(?p != pav:lastRefreshedOn)
	FILTER(?p != pav:createdOn)
	FILTER(?p != pav:createdWith)
	FILTER(?p != prov:generatedAtTime)
	FILTER(?p != pav:importedOn)
	FILTER(?p != pav:importedFrom)
	FILTER(?p != tempo:validFrom)
	FILTER(?p != tempo:validTill)

	BIND(IRI(CONCAT(STR(?s),'_',STR(xsd:date(?dd)))) AS ?d)
}
;
ECHO $ROWCNT "\n";

ECHO "deletions ... ";
## -s p A B
## +s p A
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>

WITH <$u{DIFFG}>
INSERT {
	?d	a delta:Delta ;
		delta:not-yet-applied true ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?p ;
			delta:deletion ?oou
		] ;
		rdf:subject ?s ;
		delta:patch-date ?dd ;
		prov:generatedAtTime ?now
}
USING <$u{STAGE}>
USING <$u{GRAPH}>
WHERE {
	BIND(NOW() AS ?now)

	GRAPH <$u{STAGE}> {
	?s ?p ?oin ;
		pav:sourceLastAccessedOn ?dd
	}
	GRAPH <$u{GRAPH}> {
	?s ?p ?oou
	}
	FILTER NOT EXISTS {
		GRAPH <$u{STAGE}> {
		?s ?p ?oou
		}
	}
	FILTER(?p != rdf:type)
	FILTER(?p != pav:sourceLastAccessedOn)
	FILTER(?p != pav:sourceAccessedOn)
	FILTER(?p != pav:lastRefreshedOn)
	FILTER(?p != pav:createdOn)
	FILTER(?p != pav:createdWith)
	FILTER(?p != prov:generatedAtTime)
	FILTER(?p != pav:importedOn)
	FILTER(?p != pav:importedFrom)
	FILTER(?p != tempo:validFrom)
	FILTER(?p != tempo:validTill)

	BIND(IRI(CONCAT(STR(?s),'_',STR(xsd:date(?dd)))) AS ?d)
}
;
ECHO $ROWCNT "\n";

ECHO "insertions ... ";
## -s p A B
## +s p A B C
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?d	a delta:Delta ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?p ;
			delta:insertion ?oin
		] ;
		rdf:subject ?s ;
		delta:patch-date ?dd ;
		prov:generatedAtTime ?now
}
USING <$u{STAGE}>
USING <$u{GRAPH}>
WHERE {
	BIND(NOW() AS ?now)

	GRAPH <$u{STAGE}> {
	?s ?p ?oin ;
		pav:sourceLastAccessedOn ?dd
	}
	FILTER EXISTS {
		GRAPH <$u{GRAPH}> {
		?s pav:sourceLastAccessedOn ?sometime
		}
	}
	FILTER NOT EXISTS {
		GRAPH <$u{GRAPH}> {
		?s ?p ?oin
		}
	}
	FILTER(?p != pav:sourceLastAccessedOn)
	FILTER(?p != pav:sourceAccessedOn)
	FILTER(?p != pav:lastRefreshedOn)
	FILTER(?p != pav:createdOn)
	FILTER(?p != pav:createdWith)
	FILTER(?p != prov:generatedAtTime)
	FILTER(?p != pav:importedOn)
	FILTER(?p != pav:importedFrom)
	FILTER(?p != tempo:validFrom)
	FILTER(?p != tempo:validTill)

	BIND(IRI(CONCAT(STR(?s),'_',STR(xsd:date(?dd)))) AS ?d)
}
;
ECHO $ROWCNT "\n";

CHECKPOINT;
