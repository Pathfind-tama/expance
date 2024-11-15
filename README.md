Analysis of adversary capabilities
***********************************
We added a decision rule to Tamarin, and then used the accessibility of the priming to automate the process of finding if there is some special adversary capability for that protocol.


Organization
***********************************
./protocol:the protocols we analyzed
./Perfect Encryption: non-extended algebraic property analysis
./Prefix Property Encryption/fig: extended algebraic property analysis
././fig: Store the analyzed path map as .png

How to reproduce the results
***********************************
This analysis uses version 1.6.0 of the [Tamarin-prover](https://github.com/tamarin-prover/tamarin-prover). Instructions for the installation and usage can be found in chapter 2 of the [manual](https://tamarin-prover.github.io/manual/book/002_installation.html).

It is possible to reproduce the experiment through the command
```
$ tamarin-prover --prove *.spthy
```

If you want to use the interactive interface to analyze it, use the following command
```
$ tamarin-prover interactive *.spthy
```

If you want to measure the time taken to verify a particular lemma you can use the previously
described preprocessor to mark each lemma, and only include the one you wish to time.
```
$ time tamarin-prover --prove *.spthy 
```

Apology
***********************************
We have released part of the code, and we plan to release the remaining code after our paper is accepted.
