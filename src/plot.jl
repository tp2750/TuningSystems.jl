using Plots
function plot_tuning(t::TuningSystem)
    x = fill(string(t.name),length(t.scalings))
    y = log2.(t.scalings)
    plot(x,y, seriestype = :scatter, label=string(t.name))
end

function plot_tuning(v::Vector{TuningSystem})
    x = fill(string(t.name),length(t.scalings))
    y = log2.(t.scalings)
    plot(x,y, seriestype = :scatter, label=string(t.name))
end


@recipe function f(t::TuningSystem)
    seriestype --> :scatter
    plot_title --> "Tuning"
    # ylimit --> (-0.1,1)
    ylimit --> extrema([-50,1250,cents.(t.scalings)...])
    label --> nothing
    # yticks --> -1:1//12:1
    yticks --> 0:100:1200
    annotationfontsize --> 12
    legend_position --> :outerright
    legend_font_pointsize --> 7
    markersize --> 3
    # ygridlinewidth --> 1
    ygridalpha --> 0.4
    @series begin
        x = fill(string(t.name),length(t.scalings))
        # y = log2.(t.scalings)
        y = cents.(t.scalings)
        annotations --> (x,y,t.names)
        x,y
    end
end

## Type recipe See https://daschw.github.io/recipes/
@recipe f(::Type{Sound}, s::Sound) = s.func
@recipe f(::Type{Tone}, t::Tone) = sound(t).func
