changequote()changequote([,])
DB.DBA.XML_SET_NS_DECL('dct','http://purl.org/dc/terms/', 1);
DB.DBA.XML_SET_NS_DECL('dbpedia','http://does.not.exist/', 1);
DB.DBA.XML_SET_NS_DECL('fibo-fbc-fct-bc','https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/BusinessCenters/', 1);
DB.DBA.XML_SET_NS_DECL('fibo-fbc-fct-bci','https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/BusinessCentersIndividuals/', 1);
DB.DBA.XML_SET_NS_DECL('fibo-fnd-dt-bd','https://spec.edmcouncil.org/fibo/ontology/FND/DatesAndTimes/BusinessDates/', 1);
DB.DBA.XML_SET_NS_DECL('fibo-fnd-plc-loc','https://spec.edmcouncil.org/fibo/ontology/FND/Places/Locations/', 1);
DB.DBA.XML_SET_NS_DECL('fibo-fnd-rel-rel','https://spec.edmcouncil.org/fibo/ontology/FND/Relations/Relations/', 1);
DB.DBA.XML_SET_NS_DECL('fibo-fnd-utl-av','https://spec.edmcouncil.org/fibo/ontology/FND/Utilities/AnnotationVocabulary/', 1);
DB.DBA.XML_SET_NS_DECL('gleif','https://rdf.gleif.org/L1/', 1);
DB.DBA.XML_SET_NS_DECL('gn','http://sws.geonames.org/', 1);
DB.DBA.XML_SET_NS_DECL('lcc-3166-1-adj','https://www.omg.org/spec/LCC/Countries/ISO3166-1-CountryCodes-Adjunct/', 1);
DB.DBA.XML_SET_NS_DECL('lcc-3166-2-adj','https://www.omg.org/spec/LCC/Countries/ISO3166-2-SubdivisionCodes-Adjunct/', 1);
DB.DBA.XML_SET_NS_DECL('lcc-cr','https://www.omg.org/spec/LCC/Countries/CountryRepresentation/', 1);
DB.DBA.XML_SET_NS_DECL('lcc-lr','https://www.omg.org/spec/LCC/Languages/LanguageRepresentation/', 1);
DB.DBA.XML_SET_NS_DECL('owl','http://www.w3.org/2002/07/owl#', 1);
DB.DBA.XML_SET_NS_DECL('pav','http://purl.org/pav/', 1);
DB.DBA.XML_SET_NS_DECL('prov','http://www.w3.org/ns/prov#', 1);
DB.DBA.XML_SET_NS_DECL('rdf','http://www.w3.org/1999/02/22-rdf-syntax-ns#', 1);
DB.DBA.XML_SET_NS_DECL('rdfs','http://www.w3.org/2000/01/rdf-schema#', 1);
DB.DBA.XML_SET_NS_DECL('skos','http://www.w3.org/2004/02/skos/core#', 1);
DB.DBA.XML_SET_NS_DECL('sm','http://www.omg.org/techprocess/ab/SpecificationMetadata/', 1);
DB.DBA.XML_SET_NS_DECL('sws','http://sws.geonames.org/', 1);
DB.DBA.XML_SET_NS_DECL('tempo','http://purl.org/tempo/', 1);
DB.DBA.XML_SET_NS_DECL('time','http://www.w3.org/2006/time#', 1);
DB.DBA.XML_SET_NS_DECL('unlcd','https://github.com/uncefact/codes-locode/blob/main/vocab/unlocode/', 1);
DB.DBA.XML_SET_NS_DECL('wd','http://www.wikidata.org/entity/', 1);
DB.DBA.XML_SET_NS_DECL('xsd','http://www.w3.org/2001/XMLSchema#', 1);

include(/home/freundt/exper/eco/sql/dump-generic.sql)
CREATE DUMP_PROCEDURE(dump_BusinessCentersIndividuals,
SPARQL
DEFINE input:storage ""
PREFIX owl: <http://www.w3.org/2002/07/owl#>
SELECT ?s ?p ?o
FROM <http://data.ga-group.nl/iso10383/BusinessCentersIndividuals/>
WHERE {
	{
	?s a ?t ; ?p ?o .
	FILTER(?t != owl:Ontology)
	} UNION {
	BIND(owl:sameAs AS ?p)
	?s owl:sameAs ?o
	}
}
);

dump_BusinessCentersIndividuals('/tmp/BusinessCentersIndividuals.ttl');
CHECKPOINT;
