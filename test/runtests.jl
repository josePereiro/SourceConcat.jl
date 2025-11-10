using SourceConcat
using Test

@testset "SourceConcat.jl" begin

    include("_read_non_commented_lines.tests.jl")
    include("_remove_trailing_commas.tests.jl")

end

