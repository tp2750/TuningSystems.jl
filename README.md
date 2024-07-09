# TuningSystems

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tp2750.github.io/TuningSystems.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tp2750.github.io/TuningSystems.jl/dev/)
[![Build Status](https://github.com/tp2750/TuningSystems.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/tp2750/TuningSystems.jl/actions/workflows/CI.yml?query=branch%3Amain)

- what it does
- major features
- unique selling points
- compare to alternatives
- links t odocs, CI 
- references

## What it does
TuningSystems.jl is a package for working with music in differnt tonalities.


## Major Features
It includes a few pre-defined tunings:
* tet12: 12 tone equal tempered tuing
* pythagorean: pythagorean tuning
* just: just intonation tuning

It defines some functions to generate tunings:
* equal_tempered
* geometrc_tuning

If Plots is loaded, it defines functions for 
* plotting tuning systems
* plotting sounds of tones

It defines data structures for 
* Notes
* Tones
* Sounds
* Tuning systems

It includes functions for playing sounds.

## Unique selling Points
TuningSystems makes it easy to experiment with differnt tunings. 
Ex you can easily play the same melody or chrod in different tunings.

## Alternatives
Most other software in the JuliaMusic eco-system works with the standard equal temered tuning.
There is supplemantary functionality in MIDI,jl, MusicTheorey.jl.

We build on 
* MIDI.jl
* WAV.jl

# References
This was presented on JuliaCon2024.
