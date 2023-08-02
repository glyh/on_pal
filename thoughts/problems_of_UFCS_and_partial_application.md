There's a problem of ununification here.

UFCS expects the first param to be the `object`, while partial application (usually) expects the last param to be.

To solve this. we decide to modify the UFCS rule a bit so that it works inline with partial application.

I need to do a survey in clojure on the frequencey of "->" and "->>" being used to make a decision.
