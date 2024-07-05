struct TuningSystem{T}
    steps::Int
    scalings::Vector{T}
    name::String
    names::Vector{String}
end

import Base.length
Base.length(t::TuningSystem) = length(t.scalings)

tuning(l::Int,v::Vector{T}, n::String, s::Vector{String}) where T <: Number = TuningSystem(l,v,n,s)
tuning(v::Vector{T}, n::String, s::Vector{String}) where T <: Number = TuningSystem(length(v),v,n,s)
tuning(v::Vector{T}, n::String) where T <: Number = TuningSystem(length(v), v, n, string.(v))
tuning(v::Vector{T}) where T <: Number = TuningSystem(length(v), v, :tuning, string.(v))

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
    tuning(sort(pitch_class.([(ratio)^x for x in 0:(steps)])), name)
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

import DataFrames.rename!
function DataFrames.rename!(t::TuningSystem, name)
    TuningSystem(
        t.steps,
        t.scalings,
        name,
        t.names,
    )
end

edo12 = tet12 = equal_tempered(12) ## tuning([(2^(1/12))^x for x in 0:11],"12 TET", ["C","C#","D", "D#", "E", "F", "F#", "G", "G#", "A", "A#","B"])
pythagorean13 = tuning(unique(sort([pitch_class.([(3//2)^x for x in 0:6]); pitch_class.([(2//3)^x for x in 0:6])])),"Pyth13")
pythagorean = tuning(unique(sort([pitch_class.([(3//2)^x for x in 0:6]); pitch_class.([(2//3)^x for x in 0:5])])),"Pythagorean") ##  We usually remove the diminished 5th, https://johncarlosbaez.wordpress.com/2023/10/07/pythagorean-tuning/
pyth2 = tuning(pitch_class.([(3//2)^x for x in -6:6]),"Pyth sym") ## Symmetric pythagorean

just13 = tuning(sort([1, 16//15, 9//8, 6//5, 5//4, 4//3, 64//45, 45//32, 3//2, 8//5, 5//3, 16//9, 15//8]), "Just13")
just = tuning([1, 16//15, 9//8, 6//5, 5//4, 4//3,  45//32, 3//2, 8//5, 5//3, 16//9, 15//8], "Just")



using DataFrames
import DataFrames.DataFrame
function DataFrame(t::TuningSystem)
    df = DataFrame(name = t.names, cents = cents.(t.scalings), diff_cents =  round.(cents_diff.(t.scalings), digits=2))    
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
