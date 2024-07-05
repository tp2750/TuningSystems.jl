using TuningSystems
using Test

@testset "TuningSystems.jl" begin
    @test pitch_class.(harmonics(5).scalings) == [1, 5//4, 3//2]
    @test cents.(harmonics(5).scalings) == [0.0, 386.3137138648418, 701.9550008654002]
    @test length(equal_tempered(12)) == 12
    @test equal_tempered(2).names == ["0", "600"]
end
