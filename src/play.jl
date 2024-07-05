import MIDI

## Playing notes
struct Note
    pitch::Int
    duration::Float64
    volume::Float64
end
note(n::Int, d=1, v=1) = Note(n,d,v)
note(n::T, d=1, v=1) where T <: AbstractString = Note(MIDI.name_to_pitch(n), d,v)

struct Tone
    frequency::Float64
    phase::Float64
    duration::Float64
    volume::Float64
    # func::Function
end
tone(f=400, p=0, d=1, v=1) = Tone(f, p, d, v)
"""
        Generate Tone from Note and TuningSystem.
        If tuning is missing, use ENV["TUNINGSYSTEM"] or equal_tempered(12)
"""
function tone(n::Note; tuning = missing, root_number = 60, root_frequency = 261.6255653005986) ## 261.63
    if ismissing(tuning)
        if ismissing(get(ENV, "TUNINGSYSTEM", missing))
            tuning = equal_tempered(12)
        else
            tuning = ENV["TUNINGSYSTEM"]
        end
    end
    octave_length = length(tuning)
    pitch_diff = n.pitch - root_number
    scale_idx = mod(pitch_diff, octave_length) + 1    
    scaling = tuning.scalings[scale_idx]
    octave = pitch_diff >=0 ? div(pitch_diff, octave_length) : div(pitch_diff, octave_length, RoundFromZero) 
    freq = (root_frequency * scaling)*2.0^octave
    @debug "pitch=$(n.pitch), octave=$octave, scale index=$scale_idx, scaling=$scaling, frequency=$freq"
    Tone(freq, 0, n.duration, n.volume)
end
struct Sound ## TODO: Store Vector of tones
    func::Function
    frequency::Float64 ## TODO: Use for plotting
    duration::Float64
end
sound(t::Tone; synth=sin) =  Sound(x -> t.volume*synth(2pi*t.frequency*x + t.phase), t.frequency, t.duration)
sound(f::T, p=0, d=1, v=1; synth=sin) where T <: Number = sound(tone(f,d,1,v);synth)  ## =400
function sound(v::Vector{Tone}) ## chord
    sound(sound.(v))
end
function sound(v::Vector{Sound}) ## Combine
    ## plot(s([s(400) s(440) s(450)]), xlim=(0,1/10))
    freqs = map(x-> x.frequency, v)
    freq = 1 / simple_period(freqs, frequency=true) 
    duration = maximum(map(x -> x.duration, v)) ## assert all equal?
    Sound(x -> sum(map(t -> t.func(x), v)), freq, duration) ## mean?
end
sound(s::Sound) = s

n = note
t = tone
s = sound

tns(s::String; tuning = missing, root_number = 60, root_frequency = 261.6255653005986) = tone.(note.(split(s)); tuning, root_number, root_frequency)

using WAV

function sample(s::Sound; bpm=60, samplerate=44100)
    x = 0:1/samplerate:prevfloat(s.duration*60/bpm)
    y = s.func.(x)
    # (x,y)
    (convert.(Float32,x),convert.(Float32,y)) # WAV is Float32 based
end
function save_wav(file, s::Sound; bpm = 60, samplerate=44100)
    (_,y) = sample(s; bpm, samplerate)
    wavwrite(y, file, Fs=samplerate)
end
function save_wav(file, v::Vector{Sound}; bpm = 60, samplerate=44100)
    s = sample.(v; bpm, samplerate)
    ys = Vector{Float32}[]
    for (x,y) in s
        push!(ys,y)
    end
    yv = reduce(vcat, ys)
    wavwrite(yv, file, Fs=samplerate)
end
"""
        play(s)
        s: Sound. Sample and play
        s: Vector{Sound}. Sample, concatenate and play
"""
function play(s; bpm=60, samplerate = 44100) ## TODO. Add rescaling option to Rescale to max 1. In general add "mastering"
    tf = tempname()
    save_wav(tf, s; bpm, samplerate)
    wavplay(tf)
end
# function play(s::Sound; bpm=60, samplerate = 44100) ## TODO. Add rescaling option to Rescale to max 1. In general add "mastering"
#     tf = tempname()
#     save_wav(tf, s; bpm, samplerate)
#     wavplay(tf)
# end
# function play(v::Vector{Sound}; bpm=60, samplerate = 44100)
#     tf = tempname()
#     save_wav(tf, v; bpm, samplerate)
#     wavplay(tf)
# end

## Remove this:
# import StatsBase
function sound(m::Matrix{Sound}) ## TODO: concat vector of tones and sum (mean?) the functions
    ## plot(s([s(400) s(440) s(450)]), xlim=(0,1/10))
    freqs = map(x-> x.frequency, m)
    min_diff = minimum(diff(vec(freqs)))
    min_diff = min_diff == 0 ? first(unique(freqs)) : min_diff
    duration = maximum(vec(map(x -> x.duration, m))) ## assert all equal?
    Sound(x -> sum(map(t -> t.func(x), m)), min_diff, duration) ## mean?
#    Sound(x -> StatsBase.mean(map(t -> t.func(x), m)), min_diff, duration) ## mean?
end

