PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX : <http://ga.local/stk#>

SELECT ?sh ?sc ?sev (COUNT(?r) AS ?cnt) WHERE {
	?x a sh:ValidationReport ;
		sh:result ?r .
	?r sh:sourceShape ?sh ;
		sh:resultSeverity ?sev .
	OPTIONAL {
		?r sh:sourceConstraintComponent ?sc
	}
}
GROUP BY ?sh ?sc ?sev
ORDER BY ?sh ?sc ?sev
