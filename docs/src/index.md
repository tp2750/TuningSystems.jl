```@meta
CurrentModule = TuningSystems
```

# TuningSystems

Documentation for [TuningSystems](https://github.com/tp2750/TuningSystems.jl).

# Tunings

``` julia
using TuningSystems
using Plots
plot(tet12, markersize=0)
plot!(pythagorean)
plot!(harmonics(24))
plot!(just)
plot!(pythagorean13)
hline!([0,400,700], label="I")
hline!([700, 1100, 200], label="V", line=(1,:dash))
hline!([500, 900, 1200], label="IV", line=(1,:dash))
plot!(subharmonics(24))
plot!(harmonics(32))
```

![Tunings](img/tunings1.png)

![Tunings 2](img/tunings2.png)

![Tunings 3](img/tunings3.png)

The number of the harmonics is the nominator of the fraction.
The number of the sub-harmonics is the denominator of the fraction

# Playing

Define Tone and Sound structs using frequencies.

``` julia
using TuningSystems
using Plots
plot(sound(tone(400)), xlim=(0,1/400))
```

![440Hz](img/sin440.png)

Tones in a row matrix are played together.
`s` is shourhand for `sound`, and there is an implicit `tone` when just giving the frequency.

``` julia
plot(s([s(400) s(440) s(450)]), xlim=(0,1/10), label="")
```

![440Hz](img/sin400_440_450.png)


Actually play it

``` julia
using TuningSystems
play(s(440))
```


```@index
```

```@autodocs
Modules = [TuningSystems]
```
