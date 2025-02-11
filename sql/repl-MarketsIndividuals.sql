log_enable(3,1);

SET u{GRAPH} http://data.ga-group.nl/iso10383/MarketsIndividuals/;
SET u{STAGE} MarketsIndividuals-staging;
SET u{DIFFG} MarketsIndividuals-diff;

SPARQL CREATE SILENT GRAPH <$u{STAGE}>;
SPARQL CLEAR GRAPH <$u{STAGE}>;

DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '/home/freundt/author/iso10383/MarketsIndividuals.ttl.repl';
ld_add('/home/freundt/author/iso10383/MarketsIndividuals.ttl.repl', '$u{STAGE}');
rdf_loader_run();
CHECKPOINT;

LOAD 'sql/diff.sql';
LOAD 'sql/unify-delta.sql';
LOAD 'sql/fixup-delta.sql';
LOAD 'sql/patch.sql';

SPARQL ADD <$u{STAGE}> TO <$u{GRAPH}>;
SPARQL ADD <$u{DIFFG}> TO <$u{GRAPH}>;

LOAD 'sql/prov-massage.sql';
CHECKPOINT;
