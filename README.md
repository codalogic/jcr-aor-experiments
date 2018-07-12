# jcr-aor-experiments

Experiments on how to implement object validation in JSON Content Rules (JCR).

jcr-aor.rb is the main code.

jcr-aor*.txt files contain the test input and have the following input:

`#` starts a comment line,

`?` starts a pattern line,

`+` starts a line that should be *accepted* by the most recent pattern line,

`-` starts a line the should be *rejected* by the most recent pattern line.

All other lines are ignored.
