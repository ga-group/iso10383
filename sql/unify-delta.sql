log_enable(3,1);

ECHO "unifying ... ";
SPARQL CLEAR GRAPH <$u{DIFFG}-tmp>;
SPARQL MOVE <$u{DIFFG}> TO <$u{DIFFG}-tmp>;
ECHO $ROWCNT;
-- split into two for virtuoso doesn't support BNODE
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?D a delta:Delta ;
		rdf:subject ?s ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?w
		] .
}
USING <$u{DIFFG}-tmp>
WHERE {
	?D a delta:Delta ;
		rdf:subject ?s ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?w
		] .
}
GROUP BY ?D ?s ?w
;
ECHO " + "$ROWCNT;

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?D a delta:Delta ;
		rdf:subject ?s ;
		?p ?o .
}
USING <$u{DIFFG}-tmp>
WHERE {
	?D a delta:Delta ;
		rdf:subject ?s ;
		?p ?o .
	FILTER(!ISBLANK(?o))
}
;
ECHO " + "$ROWCNT;

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?b ?q ?v
}
USING <$u{DIFFG}>
USING <$u{DIFFG}-tmp>
WHERE {
	GRAPH <$u{DIFFG}> {
	?D a delta:Delta ;
		rdf:subject ?s ;
		delta:hunk ?b .

	?b a delta:Hunk ;
		rdf:predicate ?w .
	}
	GRAPH <$u{DIFFG}-tmp> {
	?D a delta:Delta ;
		rdf:subject ?s ;
		delta:hunk [
			rdf:predicate ?w ;
			?q ?v
		] .
	}
}
LIMIT 2000000
;
ECHO " + "$ROWCNT"\n";

CHECKPOINT;
