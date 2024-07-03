struct TuningSystem{T}
    steps::Int
    scalings::Vector{T}
    name::Symbol
    names::Vector{String}
end

tuning(l::Int,v::Vector{T}, n::Symbol, s::Vector{String}) where T <: Number = TuningSystem(l,v,n,s)
tuning(v::Vector{T}, n::Symbol, s::Vector{String}) where T <: Number = TuningSystem(length(v),v,n,s)
tuning(v::Vector{T}, n::Symbol) where T <: Number = TuningSystem(length(v), v, n, string.(v))
tuning(v::Vector{T}) where T <: Number = TuningSystem(length(v), v, :tuning, string.(v))



tet12 = tuning([(2^(1/12))^x for x in 0:11],:tet12, ["C","C#","D", "D#", "E", "F", "F#", "G", "G#", "A", "A#","B"])
pythagorean13 = tuning(unique(sort([pitch_class.([(3//2)^x for x in 0:6]); pitch_class.([(2//3)^x for x in 0:6])])),:pyth13)
pythagorean = tuning(unique(sort([pitch_class.([(3//2)^x for x in 0:6]); pitch_class.([(2//3)^x for x in 0:5])])),:pythagorean) ##  We usually remove the diminished 5th, https://johncarlosbaez.wordpress.com/2023/10/07/pythagorean-tuning/
pyth2 = tuning(pitch_class.([(3//2)^x for x in -6:6]),:pyth_sym)

just13 = tuning(sort([1, 16//15, 9//8, 6//5, 5//4, 4//3, 64//45, 45//32, 3//2, 8//5, 5//3, 16//9, 15//8]), :just13)
just = tuning([1, 16//15, 9//8, 6//5, 5//4, 4//3,  45//32, 3//2, 8//5, 5//3, 16//9, 15//8], :just)



using DataFrames
import DataFrames.DataFrame
function DataFrame(t::TuningSystem)
    df = DataFrame(name = t.names, cents = cents.(t.scalings), diff_cents =  round.(cents_diff.(t.scalings), digits=2))    
    rename!(df, string(t.name) .*("_".*names(df)))
    df
end

function harmonics(n::Int)
    tuning(unique(sort(pitch_class.(1//1:n))), Symbol(string("harm",n)))
end

function subharmonics(n::Int)
    tuning(unique(sort(pitch_class.(1//1 ./(1:n)))), Symbol(string("subharm",n)))
end


harm = harmonics(24)       ## tuning(unique(sort(pitch_class.(1//1:24//1))), :harm24)
subharm = subharmonics(24) ## tuning(unique(sort(pitch_class.((1//1)./(1:24)))), :subharm)
harm32 = harmonics(32)     ## tuning(unique(sort(pitch_class.((1//1:32//1)))), :harm32)
