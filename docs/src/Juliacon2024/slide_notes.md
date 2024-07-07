# Tuning Systems
TP, 2024-07-07

# Abstract
Exploring musical tunings with Julia
07-12, 11:40–11:50 (Europe/Amsterdam), Method (1.5)

The equal-tempered 12-tone scale is ubiquitous in modern western music.
It is characterized by successive semi-tones having a constant frequency ratio of 2^(1/12) ≈ 1.06.
But there are many other ways to define tunings of musical instruments, and Julia is a great tool for exploring these tuning systems. The talk will demonstrate how I have used Julia to generate tones and explore tuning systems visually and auditory.

Julia has a number of well designed packages for representation of musical notes and generation of sounds. I've used these packages to explore tuning systems based on a series of blog posts by John Baez. I'll share my experiences and make some noise for Julia as a musical synthesizer.


# Synopsis

## Equal Tempered
* The natural choice.
* DataFrame(equal_tempered(12))
* play(sound.(tone.(note.(split("C C# D D# E F F# G G# A A# B C5")), tuning = equal_tempered(12), root_number=60)))
* play(sound(tone.(note.(split("C C# D D# E F F# G G# A A# B C5")), tuning = equal_tempered(12), root_number=60)), bpm=30)
* plot
## Why Other Tunings?
Why 12 semi tones?
## Pythagorean tuning
* Harminic intervals 
  * Octave
  * Fifth
* play difference
* plot 
* Circle of fifths
* 


## JuliaCon 2024
Exploring Musical Tunings with Julia

Let's talk about music.
Specifically about tunings.
A tuning defines the frequencies of the tones.

# Slide 1: 
On a normal piano, the 12 semi tones are distributed equally over the octave:
The frequency ratio between successive semitones is constant: 2^(1/12) ~ 1.06.
The tuning is fixed by A4 = 440Hz.
It sounds like this: play.
This equal division seems like the obvious thing to do.
But it has not always been like this, it is not like this in all cultures, and why 12 semi-tones?

Let's use julia to investigate.

Thanks to the JuliaMusic and Julia Sound? Eco system
- MIDI.jl
- PortAudio.jl
- WAV.jl
Also related
- recent: MusicTheory.jl
Refs:
- Baez

Husk:
- MIT course
- Simple midi-player (mvp: single channel)

cut
Piano is a highly "constructed intrument": each tones is produced by an individually tuned string.
Most instruments are not like this:
The tones are produced by manipulating the spectrum of a single shape.

