module TuningSystems


include("functions.jl")
export pitch_class, cents

include("tunings.jl")
export tuning, equal, tet12, pythagorean, just, harmonics, subharmonics, equal_tempered

include("play.jl")
export note, n, tone, t, sound, s, play, save_wav, sample, tns

include("plot.jl")
export plot_tuning

end
