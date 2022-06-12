[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](http://opensource.org/licenses/MIT)

ISO10383 (MIC)
==============

This repository is an RDF view on ISO10383's MICs in the [fibo-fbc-fct-mkti namespace](https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/MarketsIndividuals/).
Business centres have been taken from the ISDA/FpML business centre specification in the [fibo-fbc-fct-bci namespace](https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/BusinessCentersIndividuals/).

See https://spec.edmcouncil.org/fibo/
or https://github.com/edmcouncil/fibo


Why?
----

FIBO's official ontology lacks historical identifiers and, consequently, annotations
about their temporal validity.

FIBO's business centres are not distictive.


How?
----

The Makefile contains some recipes to assemble a file that resembles FIBO's, taking
a source as input, i.e. an ISO10383 xlsx file or an FpML business-center-x-y spec file,
and enriching the file on the way using supplementary files (maintained in this repo).

The supplementary files contain alignment data with wikidata, geonames, and dbpedia.
