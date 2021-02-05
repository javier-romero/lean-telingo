# lean-telingo

ASP meta encodings for temporal, dynamic, and metric logic programs based on reification

## desiderata

just first ideas, feel free to criticize

### input

  * a simple (standard) clingo program that allows us to use reification
	* modalities apply only to single literals
		* drop binary modalities for the time being
	* modalities are supplied via the last argument, eg p(a,next), q(42,now)
		* no modality is represented by now

  * (keep Susana's decompilation of theory atoms and terms on the radar)

### output

  * k=0 all states
  * k=1 all arcs
  * k=n all (stable) HT-traces of length n

### encoding

  * independent generator of traces

  * (modular) constraints selecting models by
	* input program
	* formalism (temporal,dynamic,metric)

  * blue print: Section on [meta encodings](https://www.cs.uni-potsdam.de/wv/publications/DBLP_journals/corr/abs-2008-06692.pdf)
