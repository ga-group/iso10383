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

The business centres are reduced to distinctive entities, duplicates are owl:sameAs'd,
and erroneous resources have been purged altogether.  Furthermore, business centres
are aligned with geonames resources.
