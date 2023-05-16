log_enable(3,1);

ECHO "patching ... ";
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{GRAPH}>
DELETE {
	?s ?p ?o .
	?x delta:not-yet-applied true .
}
USING <$u{DIFFG}>
USING <$u{GRAPH}>
WHERE {
	GRAPH <$u{DIFFG}> {
	?x a delta:Delta ;
		delta:not-yet-applied true ;
		rdf:subject ?s ;
		delta:hunk [
			rdf:predicate ?p ;
			delta:deletion ?o
		]
	}
}
;
ECHO $ROWCNT "\n";

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x delta:not-yet-applied true .
}
USING <$u{DIFFG}>
WHERE {
	?x a delta:Delta ;
		delta:not-yet-applied true .
}
;

CHECKPOINT;
