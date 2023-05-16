log_enable(3,1);

ECHO "fixing ... ";
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x delta:deletion ?del ;
		delta:insertion ?ins .
}
WHERE {
	?x a delta:Hunk ;
		delta:deletion ?del ;
		delta:insertion ?ins .
	FILTER(STR(?del) = STR(?ins) && LANG(?del) = LANG(?ins) && DATATYPE(?del) = DATATYPE(?ins))
}
;
ECHO $ROWCNT;

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x ?p ?o
}
WHERE {
	?x a delta:Hunk ;
		?p ?o .
	FILTER(NOT EXISTS{?x delta:deletion ?del})
	FILTER(NOT EXISTS{?x delta:insertion ?ins})
}
;
ECHO " + "$ROWCNT;

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x delta:hunk ?y
}
WHERE {
	?x delta:hunk ?y .
	FILTER(NOT EXISTS{?y a delta:Hunk})
}
;
ECHO " + "$ROWCNT;

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x ?p ?o
}
WHERE {
	?x a delta:Delta ;
		?p ?o
	FILTER(NOT EXISTS{?x delta:hunk ?y})
}
;
ECHO " + "$ROWCNT"\n";

CHECKPOINT;
