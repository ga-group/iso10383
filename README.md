[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](http://opensource.org/licenses/MIT)

ISO10383 (MIC)
==============

This repository is an RDF view on ISO10383's MICs in the [fibo-fbc-fct-mkti namespace](https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/MarketsIndividuals/).
Business centres have been taken from the ISDA/FpML business centre specification in the [fibo-fbc-fct-bci namespace](https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/BusinessCentersIndividuals/).

See <https://spec.edmcouncil.org/fibo/>
or <https://github.com/edmcouncil/fibo>

The project's canonical home is <http://data.ga-group.nl/iso10383/>.


Why?
----

FIBO's official ontology lacks historical identifiers and, consequently, annotations
about their temporal validity.

FIBO's business centres are not distictive.


How?
----

The Makefile contains some recipes to assemble a file that resembles FIBO's.

For MarketsIndividuals the primary source is the latest list of Market Identifier Codes
in the new data structure and format, to be obtained here:
<https://www.iso20022.org/market-identifier-codes>.

For BusinessCentersIndividuals the primary source is the latest business-center spec
file as published by FpML working group: <https://www.fpml.org/coding-scheme/>.

The resulting files are then enriched using supplementary files (maintained in this repo).

The supplementary files contain alignment data with wikidata, geonames, and dbpedia.


Where?
------

The [official github repository](https://github.com/ga-group/iso10383/) contains the
published datasets as well as separately maintained alignment and enrichment files.

For ease of access the latest versions of the datasets can be downloaded here:

- [MarketsIndividuals.ttl](MarketsIndividuals.ttl)
- [BusinessCentersIndividuals.ttl](BusinessCentersIndividuals.ttl)

