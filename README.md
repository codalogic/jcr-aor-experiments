# jcr-aor-experiments

Experiments on how to implement object validation in JSON Content Rules (JCR).

jcr-aor.rb is the main code.

jcr-aor*.txt files contain the test input and have the following input:

`#` starts a comment line,

`?` starts a pattern line,

`+` starts a line that should be *accepted* by the most recent pattern line,

`-` starts a line the should be *rejected* by the most recent pattern line.

All other lines are ignored.

# The Pattern Format

The pattern line has the following format:

- spaces maybe included in the pattern; they are ignored

- use lower case letters to denote member rule names

- use `.` to indicate a wildcard that matches any letter

- for a simple sequence, do `abc`

- for a choice, use pipe separators: `a|b|c`

- use brackets to surround groups: `ab(c|d)ef`

- use Kleene operators to signify permitted repetition: `a?b*c+`

- use numbers for exact repetitions: `a2bc4`

- use tilde (`~`) for min -> max repetition range, where max in optional (defaults to unbounded): `a2~5b10~`
