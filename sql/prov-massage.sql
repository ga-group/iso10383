SET u{PRED} pav:importedOn;
LOAD 'sql/prov-mini-loop.sql';
SET u{PRED} tempo:validFrom;
LOAD 'sql/prov-mini-loop.sql';
SET u{PRED} tempo:validTill;
LOAD 'sql/prov-maxi-loop.sql';
SET u{PRED} pav:lastRefreshedOn;
LOAD 'sql/prov-maxi-loop.sql';
SET u{PRED} prov:generatedAtTime;
LOAD 'sql/prov-mini-loop.sql';
SET u{PRED} pav:sourceAccessedOn;
LOAD 'sql/prov-mini-loop.sql';
SET u{PRED} pav:sourceLastAccessedOn;
LOAD 'sql/prov-maxi-loop.sql';
