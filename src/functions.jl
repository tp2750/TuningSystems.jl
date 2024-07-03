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
