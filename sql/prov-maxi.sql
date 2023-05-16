ECHO "maximising " $u{PRED} " ... ";
SPARQL
PREFIX tempo: <http://purl.org/tempo/>
PREFIX pav: <http://purl.org/pav/>
PREFIX prov: <http://www.w3.org/ns/prov#>
WITH <$u{GRAPH}>
DELETE {
	?s $u{PRED} ?v
}
WHERE {
	{
	SELECT ?s MAX(?v) AS ?mv
	FROM <$u{GRAPH}>
	WHERE {
		?s $u{PRED} ?v
	}
	GROUP BY ?s
	}
	?s $u{PRED} ?v
	FILTER(?v < ?mv)
}
LIMIT 1000000
;
ECHO $ROWCNT "\n";
SET u{TOTAL} $IF $GTE $ROWCNT 1000000 "X" "!";
