module TuningSystems

using Plots

include("tunings.jl")
export pitch_class, tuning, equal, tet12, pythagorean, just, cents, harmonics, subharmonics

include("plot.jl")
export plot_tuning

end
