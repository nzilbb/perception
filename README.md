# perception
Hexagon module for running speech-perception tasks

Hexagon is an open-source content management system written in Java:
[https://sourceforge.net/projects/hexagoncms/]

This module allows administrators to add speech recordings, and define
a set of questions about recordings. Participants are played the
recordings, and for each recording, are asked to answer the
questions.

Answers are saved in a database for later extraction in CSV files.

## Making the module

```
cd META-INF
ant
```

This creates *perception.jar* which can be installed as a module in a
Hexagon site.