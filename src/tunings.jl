"""
    TuningSystem{T}

Data structure for a tuning system.
A tuning system is defined by a vector of `scalings` of the type `T` (probably `<: Number`).
The scalings are frequency rations within the octave of the pitches of the tones in the octave.
It also includes `names` of each scaling.
In case of the 12 tone equal temperement, it could be the names of the notes: C, C#, D, D#, E, ..., B.
It also includes a name of the tuning (used for plotting etc).

Preferably use the constructor function [`tuning`](@ref ) to construct it.
"""
struct TuningSystem{T}
    steps::Int
    scalings::Vector{T}
    name::String
    names::Vector{String}
end

import Base.length
Base.length(t::TuningSystem) = length(t.scalings)

"""
     tuning(v::Vector{T}, [n::String], [s::Vector{String}]) where T <: Number -> TuningSystem

Construct a [`TuningSystem`](@ref).

## Arguments
- `v::Vector`: The vector of scaings defining the function.
- `n::String`: The name of the tuning system. Defaults to "tuning"
- `s::Vector{String}`: The names of the scalings. Defaults to `string.v()`

"""
tuning(l::Int,v::Vector{T}, n::String, s::Vector{String}) where T <: Number = TuningSystem(l,v,n,s)
tuning(v::Vector{T}, n::String, s::Vector{String}) where T <: Number = TuningSystem(length(v),v,n,s)
tuning(v::Vector{T}, n::String) where T <: Number = TuningSystem(length(v), v, n, string.(v))
tuning(v::Vector{T}) where T <: Number = TuningSystem(length(v), v, :tuning, string.(v))

"""
    equal_tempered(n)

Constructs an equal tempered tuning of length `n`.

If the length `n` is 12, the names of the scalings are set to the standard names of the notes: "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B".

The `scalings` of and equal tempered scale of length `n` divides the octave evenly on a log scale.
This means the ratio between successive scalings are `2^(1/n)`.

So the vector of scalings is:

``` julia
    scalings = [(2^(1/n))^x for x in 0:(n-1)]
```

"""
function equal_tempered(n) ## n TET n Tone Equal Temperement. n EDO Even Divisions of Octave
    scalings = [(2^(1/n))^x for x in 0:(n-1)]
    if n == 12
        names = ["C","C#","D", "D#", "E", "F", "F#", "G", "G#", "A", "A#","B"]
    else
        names = string.(Int.(round.(cents.(scalings))))
    end
    tuning(n, scalings, string(n,"TET"), names)
end

function geometric_tuning(ratio, steps; name=missing)
    if ismissing(name)
        name = string(steps,"step",ratio)
    end
    tuning(sort(pitch_class.([(ratio)^x for x in 0:(steps-1)])), name)
end

import Base.vcat
function cat_tunings(t::Vector{T}) where T <: TuningSystem
    ## TODO: deduplication in overloaded unique
    scales = reduce(vcat, map(x->x.scalings, t))
    names = reduce(vcat, map(x->x.names, t))
    name = join(reduce(vcat, map(x->x.name, t)),"+")
    perm = sortperm(scales)
    tuning(scales[perm], name, names[perm])
end

using DataFrames
import DataFrames.rename!
function DataFrames.rename!(t::TuningSystem, name)
    TuningSystem(
        t.steps,
        t.scalings,
        name,
        t.names,
    )
end

et12 = tet12 = equal_tempered(12) ## tuning([(2^(1/12))^x for x in 0:11],"12 TET", ["C","C#","D", "D#", "E", "F", "F#", "G", "G#", "A", "A#","B"])
pythagorean13 = tuning(unique(sort([pitch_class.([(3//2)^x for x in 0:6]); pitch_class.([(2//3)^x for x in 0:6])])),"Pyth13")
pythagorean = tuning(unique(sort([pitch_class.([(3//2)^x for x in 0:6]); pitch_class.([(2//3)^x for x in 0:5])])),"Pythagorean") ##  We usually remove the diminished 5th, https://johncarlosbaez.wordpress.com/2023/10/07/pythagorean-tuning/
pyth2 = tuning(pitch_class.([(3//2)^x for x in -6:6]),"Pyth sym") ## Symmetric pythagorean

just13 = tuning(sort([1, 16//15, 9//8, 6//5, 5//4, 4//3, 64//45, 45//32, 3//2, 8//5, 5//3, 16//9, 15//8]), "Just13")
just = tuning([1, 16//15, 9//8, 6//5, 5//4, 4//3,  45//32, 3//2, 8//5, 5//3, 16//9, 15//8], "Just")



import DataFrames.DataFrame
function DataFrame(t::TuningSystem)
    df = DataFrame(name = t.names, scalings = t.scalings*1.0, cents = cents.(t.scalings), diff_cents =  round.(cents_diff.(t.scalings), digits=2))    
    rename!(df, string(t.name) .*("_".*names(df)))
    df
end

function harmonics(n::Int)
    tuning(unique(sort(pitch_class.(1//1:n))), string("harm",n))
end

function subharmonics(n::Int)
    tuning(unique(sort(pitch_class.(1//1 ./(1:n)))), string("subharm",n))
end


harm = harmonics(24)       ## tuning(unique(sort(pitch_class.(1//1:24//1))), :harm24)
subharm = subharmonics(24) ## tuning(unique(sort(pitch_class.((1//1)./(1:24)))), :subharm)
harm32 = harmonics(32)     ## tuning(unique(sort(pitch_class.((1//1:32//1)))), :harm32)
