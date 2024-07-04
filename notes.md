# Tuning Systems
TP, 2024-06-30

# Conclusions

* pitch_class: fold into a given octave (default: [1;2[)
* cents(a,b): difference between a and b in cents. Positive if a>b
* compare_tunings(a,b): Use a as reference. Find closest in b and report diff in cents

## TODO

* plot multiple tunings
* plot melodies and harmonies (this can also plot tunings)
* table comparing tunings
* harmonics
* play sound
* Use package extensions

# Tunings

## Logarithmic

* tet12
* tet19
* tet53

## Geometric

* pythagorean

## Harmonic

## Limit

* just = 5 limit

## TODO Mean tone

# Data Structures

What is a tuning system?

 Wikipedia: 
  A tuning system is the system used to define which tones, or pitches, to use when playing music. In other words, it is the choice of number and spacing of frequency values used. 

A tuning System is a mapping between note-steps and tones. 
It assigns frequencies to the MIDI note numbers.
Middle C (C4) is MIDI note number 60.

So T: N -> R

It is enough to define a tunings system within one octave.

## TuningSystem

``` julia
struct TuningSystem
	steps::Int
    scaling::Vector{Float64}
    name::Symbol
end

plot(tet12)
```
# Playing

* MIDI.jl defines Note(pitch, velocity, position, duration, channel = 0)
* pitch is an integer.
* MIDI.jl fixes pitch_to_name(60) == "C4"

Given TuningSystem and a root frequency, we can map pitches to frequencies.

Note: MIDI.Note
Tone: frequency, duration, synthesizer?
Sound: Tone, synthesizer

# Playing again
2024-07-04

Note: pich_number; duration=1, volume=1
Tone: frequency; duration, volume
Sound: function; duration, (frequency)

note(::String)::Note
note(::Number)::Note
tone(::Note; tuning=TUNINGSYSTEM||tet12, tonica_number=60, tonica_frequency=440)
sound(::Tone; synth=sin, tuning=missing) ## non-missing tuning propagates to tone
sound(::Vector{Tone})::Sound = chord ## sum functions
#sound(::Note) = sound(tone(::Note))
#sound(::Vector{Note}) = sound(tone(Vector{Note}))
#sound(::Vector{Sound})::Sound = chord ## sum functions
play(::Sound; bpm=60, tuning=missing, synth=missing) ## sample. Non-missing tuning propagates to tone, non-missing synth propagates to sound
play(::Vector{Sound}) ## concatenate samples
#play(::Tone)
#play(::Vector{Tone})
n=note
t=tone
s=sound
set_tuning ## sets environment variable TUNINGSYSTEM
set_synth ## set env TUNINGSYSTEM_SYNTH

Now 
* play(s(["C", "E", "G"])) plays C-major chord
* play(s.(["C", "E", "G"])) plays triad as successive tones
* play(sound(lyr"c4 e g"C4; tuning=just))

Implementation strategy:
* Start simple: note(::Number), note(::String), tone(::Note; tuning, root_number, root_frequency), sound(::Tone; synth), sound(::Vector{Tone}), play(::Sound; bpm), play(::Vector{Sound})
* Lilypond string macro giving Vector{Note}

Gives 
* play(s(t.(lyr"c e g"C4))) ## chrod
* play(s.(t.(lyr"c e g"C4))) ## arpegiated


## TODO
* Is there a macro that "promotes" String, Number, Note to sound?
* If Unitful loaded: sound(440u"Hz")
* string macro for lilypond relative notation. lyr"c4 e2 g4"C4 == [note("C4"), note("E4"; duration=2), note("G4")]
* transpose
* mix, scale
* effects like chorus, reverbe: use sampled signals and DSP library
* Play adaptively in just intonation
* Wohl-temparierte clavier: play in different tunings

# TODO

* quantize(note, tuning): find closest pitch-class in tuning to given note
* plot scores in sec, log frequency scale

# References

* https://en.wikipedia.org/wiki/Musical_tuning (2024-06-30)
* https://johncarlosbaez.wordpress.com/2023/10/07/pythagorean-tuning/
* https://johncarlosbaez.wordpress.com/2023/10/30/just-intonation-part-1/
* https://johncarlosbaez.wordpress.com/2023/12/13/quarter-comma-meantone-part-1/
* https://johncarlosbaez.wordpress.com/2024/01/11/well-temperaments-part-1/
* https://johncarlosbaez.wordpress.com/2023/10/13/perfect-fifths-in-equal-tempered-scales/. Why 12 tones?
* https://en.wikipedia.org/wiki/Harmonic_seventh Harmonic 7
* https://en.wikipedia.org/wiki/Just_intonation I, IV, V as 4:5:6

## Other impelmentations
* https://github.com/nathanday/Intonation?tab=readme-ov-file
  - https://en.wikipedia.org/wiki/Limit_(music)
  - https://en.wikipedia.org/wiki/Pythagorean_tuning
  - https://en.wikipedia.org/wiki/Equal_temperament
  - https://en.wikipedia.org/wiki/Harmonic_series_(music)
* https://github.com/flappix/web_intonation

## More notes
* https://www.animations.physics.unsw.edu.au/jw/frequency-pitch-sound.htm pitch
* https://newt.phys.unsw.edu.au/jw/notes.html note numbers
* https://inspiredacoustics.com/en/MIDI_note_numbers_and_center_frequencies
* Subharmonics: https://en.wikipedia.org/wiki/Undertone_series
