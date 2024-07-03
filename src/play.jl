## Playing notes

struct Tone
    frequency::Float64
    phase::Float64
    duration::Float64
    volume::Float64
    # func::Function
end
tone(f=400, p=0, d=1, v=1) = Tone(f, p, d, v)

struct Sound ## TODO: Store Vector of tones
    func::Function
    frequency::Float64 ## TODO: Use for plotting
    duration::Float64
end
sound(t::Tone; synth=sin) =  Sound(x -> t.volume*synth(2pi*t.frequency*x + t.phase), t.frequency, t.duration)
sound(f::T, p=0, d=1, v=1; synth=sin) where T <: Number = sound(tone(f,d,1,v);synth)  ## =400

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

t = tone
s = sound

using WAV

function sample(t::Sound; samplerate=44100)
    x = 0:1/samplerate:prevfloat(t.duration)
    y = t.func.(x)
    (x,y)
end
function save_wav(file, t::Sound; samplerate=44100)
    (_,y) = sample(t; samplerate)
    wavwrite(y, file, Fs=samplerate)
end

function play(t::Sound) ## TODO. Add rescaling option to Rescale to max 1. In general add "mastering"
    tf = tempname()
    save_wav(tf, t)
    wavplay(tf)
end

