
"""
    Fixed(
        position::GeometryBasics.Point{3,T}
        panel_dimensions::Tuple{T,T}
        inclination::T
        panel_height::T
        ref_mesh_panel::GeometryBasics.Mesh
    )

Structure for a fixed structure.

# Arguments

- `position::GeometryBasics.Point{3,T}`: Position of the structure.
- `panel_dimensions::Tuple{Float64,Float64}`: Dimensions of the solar panel: (width, height).
- `inclination::Float64`: Panel inclination.
- `panel_height::Float64`: Height of the panel.
- `ref_mesh_panel::GeometryBasics.Mesh`: Reference mesh for the panel.

# Example

```julia
s = Fixed(
    position=Point3(0.0, 0.0, 0.0),
    panel_dimensions=(1.0, 4.0),
    inclination=25.0,
    panel_height=4.0,
    ref_mesh_panel=solar_panel(),
)
```

"""
struct Fixed{T} <: ModuleStructure
    position::GeometryBasics.Point{3,T}
    panel_dimensions::Tuple{T,T}
    inclination::T
    panel_height::T
    ref_mesh_panel::GeometryBasics.Mesh
end

function Fixed(;
    position=Point3(0.0, 0.0, 0.0),
    panel_dimensions=(1.0, 4.2),
    inclination=25.0,
    panel_height=4.00,
    ref_mesh_panel=solar_panel(),
)
    return Fixed(position, panel_dimensions, inclination, panel_height, ref_mesh_panel)
end

function structure_meshes(s::Fixed)
    trans = Translation(0.0, 0.0, s.panel_height) ∘
            LinearMap(RotX(deg2rad(s.inclination))) ∘
            LinearMap(LinearAlgebra.Diagonal([s.panel_dimensions[1], s.panel_dimensions[2], 0.01]))

    mesh_ = PlantGeom.apply_transformation_to_mesh(trans, s.ref_mesh_panel)
    return mesh_
end

function mtg_structure(s::Fixed, meshes)
    pos = s.position

    panel_node = MultiScaleTreeGraph.Node(
        MultiScaleTreeGraph.NodeMTG("/", "Panel", 1, 1),
        Dict{Symbol,Any}(
            :geometry => PlantGeom.Geometry(ref_mesh=PlantGeom.RefMesh("Panel", meshes), transformation=Translation(pos[1], pos[2], pos[3])),
        )
    )

    return panel_node
end
