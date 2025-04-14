# Analysis of adversary leverage with Tamarin
We added decision rules in Tamarin and then used the reachability of the protocol model or the distinguishability of the two systems to automate the detection or proof of the existence of an adversarial leverage in the protocol.


# Organization

The folder is divided into models of four categories of protocols and the model of the Bluetooth protocol SSP mode.

./[protocol]: the protocols we analyzed

././explicit leverage: Analysis model for explicit leverage.

././explicit leverage/Perfect Encryption: non-extended algebraic property analysis

././explicit leverage/Prefix Property Encryption: extended algebraic property analysis

././implicit leverage: Analysis model for implicit leverage.

fig: Store the analyzed path map as .png

time.log: It saved the instructions and time of our analysis.

# How to reproduce the results
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

