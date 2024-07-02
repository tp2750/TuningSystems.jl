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
plot!(harm)
plot!(just)
plot!(pythagorean13)
hline!([0,400,700], label="I")
hline!([700, 1100, 200], label="V", line=(1,:dash))
hline!([500, 900, 1200], label="IV", line=(1,:dash))
plot!(subharm)
plot!(harm32)
```

![Tunings](img/tunings1.png)

![Tunings 2](img/tunings2.png)

![Tunings 3](img/tunings3.png)

The number of the harmonics is the nominator of the fraction.
The number of the sub-harmonics is the denominator of the fraction

```@index
```

```@autodocs
Modules = [TuningSystems]
```
