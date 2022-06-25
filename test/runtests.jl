using Test, Unitful

t1 = @elapsed using SolMod
@info "Loading SolMod took $(round(t1,digits = 2)) seconds"

macro printline()  # useful in hunting for where tests get stuck
    file = split(string(__source__.file), "/")[end]
    printstyled("  ", file, ":", __source__.line, "\n", color=:light_black)
end

@testset "All tests" begin
    include("test_TPD_NRTL.jl")
    include("test_Curve_NRTL.jl")
    include("test_etc.jl")
end