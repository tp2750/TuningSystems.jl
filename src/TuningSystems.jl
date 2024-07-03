module TuningSystems

using Plots

include("functions.jl")
export pitch_class, cents

include("tunings.jl")
export tuning, equal, tet12, pythagorean, just, harmonics, subharmonics

include("play.jl")
export tone, t, sound, s, play, save_wav, sample

include("plot.jl")
export plot_tuning

end
