module Agrivoltaics

import PlantGeom, MultiScaleTreeGraph
import GeometryBasics: Point3, Mesh, TriangleFace, mesh, Cylinder
import GeometryBasics
import LinearAlgebra
using Rotations
using CoordinateTransformations

include("structures/structure.jl")
include("structures/generic_structure.jl")


include("structures/designs/fixed.jl")
include("structures/designs/two_axis.jl")
include("structures/designs/vertical.jl")


# General functions:
export cylindrical_support, solar_panel
export structure

# Designs:
export Fixed, TwoAxis, Vertical

end
