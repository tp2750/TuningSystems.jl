```@meta
EditURL = "tutorial.jl"
```

# [TuningSystems.jl Tutorial](@ref tutorial)

TuningSystems.jl is a package for working with music in differnt tonalities.
A tuning assigns frequencies to notes.

* Main input, Output
* Key Functions
* main output
* more varieties of inputs
* Links to the rest

The 12 tone equal tempered tuning is what we know from the piano:
the octave is subdivided into 12 semitones, each with a frequency ratio to the next of `2^1/12`.

We can generate the 12 tone equal tempered tunings using the [`equal_tempered`](@ref) function nad show it as a DataFrame:

````@example tutorial
using TuningSystems
using DataFrames

et12 = equal_tempered(12) ## the is equal to predefined tet12
DataFrame(et12)
````

There are also other tunings defined in the package, and we can compare then in a plot.
Here is how to plot the 12 tone equal tempered togeter with the just intonation and pythagorean tunings.

````@example tutorial
using Plots

plot(et12, title="Tunings")
plot!(just)
plot!(pythagorean)
````

TuningSystems can also genrate and plot sound from notes, using a tuning.
Below, we plot 100 ms of the major triad in just intonation, and play it for 2 seconds.

````@example tutorial
plot(s(t.([1, 5/4, 3/2] .* 440)), title="Major triad", xlim=(0,0.1), label="")

play(s(t.([1, 5/4, 3/2] .* 440)), bpm=30, file="c-major-just.wav")
````

![C major](c-major-just.wav)

TuningSystems defines

* TuningSystem: the frequency scalings inside an octave
* Note: a note-number, duration and volume
* Tone: frequency, duration, volume
* Sound: function generating the sound

We can `plot`
* TuningSystem: the scalings on a logarithmic y-axes
* Sound: the funcion generating the sound

We can `play`
* Sound: Samples the function. Plays it (and optionally writes it to a file).

In the example above, we gave the frequencies directly, but in general, the flow is:
`sound(tone(note(n), tuning=tet12), synth=sin)`:

* A `Tone` is a `Note` in a `TuningSystem`
* A `Sound` is a `Tone` played with a `synth` (which is a preiodic function. Defaults to `sin`)

To re-do the major triad we do:

````@example tutorial
C_just = tone.(note.(split("C E G")), tuning=just)

plot(sound(C_just), xlim=(0,.1))

play(sound(C_just))
````

Now it is easy to compare this to the C-major in 12 tone euqla temperement or pythagorean. There are short-cut functions defined for `sound`, `tone`, `note` as `s`, `t`, `n`

````@example tutorial
plot(plot(s(t.(n.(split("C E G")), tuning=just)), xlim=(0,0.1), title="Just"),
     plot(s(t.(n.(split("C E G")), tuning=tet12)), xlim=(0,0.1), title="12 TET"),
     plot(s(t.(n.(split("C E G")), tuning=pythagorean)), xlim=(0,0.1), title="Pythagorean")
     )

plot(s(t.(n.(split("C E G")), tuning=just)), xlim=(0,0.1), label="Just")
plot!(s(t.(n.(split("C E G")), tuning=tet12)), xlim=(0,0.1), label="12 TET")
plot!(s(t.(n.(split("C E G")), tuning=pythagorean)), xlim=(0,0.1), label="Pythagorean")
````

The sound function has a special method for `Vector{Tone}` that generates the "chord" of all sounds together (by summing them).
This is what we use above for the plotting.

The `play` function on a  `Vector{Sound}` will play the sounds one after the next (concatenating the samples.

The difference is seen below, by playing forst the C-major chrod, and ten "arpegiating it"

````@example tutorial
play(s(t.(n.(split("C E G")), tuning=just))) ## Chrod

play(s.(t.(n.(split("C E G")), tuning=just))) ## individual tones
````

This package was first presented on JuliaCon2024: Link.

Documentation is here: []().

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

