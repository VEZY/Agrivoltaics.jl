using Test

if !isdefined(Main, :Agrivoltaics)
    include(joinpath(@__DIR__, "..", "src", "Agrivoltaics.jl"))
end
using .Agrivoltaics

include("test-structures.jl")
