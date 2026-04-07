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


include("system/system.jl")
include("KPIs/geometric_kpis.jl")
include("KPIs/radiation_kpis.jl")
include("KPIs/yield_kpis.jl")

# General functions:
export cylindrical_support, solar_panel
export structure

# Designs:
export Fixed, TwoAxis, Vertical

# KPIs:
export calculate_gcr, calculate_sf, calculate_lhi

# System:
export System

end
