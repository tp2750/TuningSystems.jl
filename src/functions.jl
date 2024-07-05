"""
  Transpose by full octaves to get in the range [1; 2[
"""
function pitch_class(x; base=1)
    x = copy(x)/base
    while x < 1
        x = x*2
    end
    while x >= 2
        x = x/ 2
    end
    x * base
end

"""
   Express a frequency ratio as cents
   There is 1200 cents on an octave
"""
function cents(x)
    log2(x)/log2(2^(1/1200))
end


"""
   Distance in cents to rearest 100 cents
"""
function cents_diff(x)
    cents(x) - 100*round(cents(x)/100,digits=0)
end

"""
   Find period of signal composed of periodic signals
"""
function period(v::Vector{T};frequency=false) where T <: Rational
    # ref https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://www.utdallas.edu/~raja1/EE%25203302%2520Fall%252016/Lecture%2520Notes/Determining%2520the%2520Periodicity%2520of%2520the%2520Sum%2520of%2520Periodic%2520Signals.doc&ved=2ahUKEwib3LrUjZCHAxWQgv0HHQ4pBCsQFnoECBAQAw&usg=AOvVaw2C21kIPpoJfQJ2q87dEovO
    ## Let x(t) = x1(t) +  x2(t) + … xN(t) where xj(t) is a periodic signal with fundamental period Tj seconds, j = 1,2…N.
    ## form the ratios Fj =  T1 / Tj, j=2,…N.  If every one of the ratios is a rational number, then x(t) is periodic.  Otherwise, it is not periodic.
    ## 1. Convert the ratios T1 / Tj, j = 2,…N to a ratio of integers, with common factors between numerator and denominator canceled out.  Now the ratios will be of the form Nj / Dj , for j=2,…N.
    ## 2. Find the least common multiple (LCM) of the Dj ‘s.  Let this number be K.
    ## 3. 3. The fundamental period of x(t), T,  is then given by T = K T1 seconds
    t = frequency ? 1 .//v : copy(v) ## get periods
    t = sort(t)
    f = t[1] .// t
    popfirst!(f)
    denoms = denominator.(f)
    k = lcm(denoms...)
    p = k*t[1]
    ## return frequency ? 1//p : p ## not type stable (is using units)
    return p
end
period(v::Vector{T};frequency=false) where T <: Number = period(rationalize.(v); frequency)
period(p; frequency=false) = p

"""
   simple_period approximates the period as the inverse of the beat_frequency
   If all periods are equal, that period is return (rather than Inf)
"""
function simple_period(v::Vector{T};frequency=false) where T <: Number
    freqs = frequency ? v : 1 ./ v
    min_diff = minimum(diff(sort(freqs)))
    min_diff = min_diff == 0 ? first(unique(freqs)) : min_diff
    1/min_diff
end
simple_period(p; frequency=false) = p

"""
   beat_frequency(v::Vector) is? the minimal difference between frequencies.   
"""
function beat_frequency(v::Vector{T}) where T <: Number
    minimum(diff(sort(freqs)))    
end
