module SourceConcat

using JSON3
using Glob
using Dates
using Printf
using InteractiveUtils

#! include .
include("base.collect.paths.jl")
include("base.concat.jl")
include("base.concat.lines.jl")
include("base.configfile.jl")
include("utils.clipboard.file.jl")
include("utils.config.validate.jl")
include("utils.jl")
include("utils.lang.map.jl")

end