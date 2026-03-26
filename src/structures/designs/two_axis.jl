"""
    TwoAxis(
        module_dimensions=(7470.0, 2100.0),
        main_support_dimensions=(4580.0, 78.45),
        panel_x_offset=300.0,
        panel_dimensions=((module_dimensions[1] - panel_x_offset * 2.0) / 4, 992.0),
        panel_support_dimensions=(module_dimensions[1], module_dimensions[2] - panel_dimensions[2] * 2.0),
        ref_mesh_panel=solar_panel(),
        ref_mesh_support=cylindrical_support()
    )

Structure for a two-axis tracker with the given dimensions.

# Arguments

- `module_dimensions::Tuple{Float64,Float64}`: Dimensions of the module.
- `main_support_dimensions::Tuple{Float64,Float64}`: Dimensions of the main support structure.
- `panel_x_offset::Float64`: Offset of the solar panels in the x direction.
- `panel_dimensions::Tuple{Float64,Float64}`: Dimensions of the solar panel.
- `panel_support_dimensions::Tuple{Float64,Float64}`: Dimensions of the panel support structure.
- `ref_mesh_panel::GeometryBasics.Mesh`: Reference mesh for the solar panel.
- `ref_mesh_support::GeometryBasics.Mesh`: Reference mesh for the support structure.
- `tracking_angle::Float64`: Angle of the tracker.


# Example

```julia
s = TwoAxis(
    module_dimensions=(7.0, 2.0),
    main_support_dimensions=(4.5, 8.0),
    panel_x_offset=0.3,
    tracking_angle=15.0
)
```
"""
struct TwoAxis{T} <: ModuleStructure
    position::GeometryBasics.Point{3,T}
    module_dimensions::Tuple{T,T}
    main_support_dimensions::Tuple{T,T}
    panel_support_dimensions::Tuple{T,T}
    panel_dimensions::Tuple{T,T}
    panel_x_offset::T
    ref_mesh_panel::GeometryBasics.Mesh
    ref_mesh_support::GeometryBasics.Mesh
    tracking_angle::T
end

function TwoAxis(;
    position=Point3(0.0, 0.0, 0.0),
    module_dimensions=(7.47, 2.1),
    main_support_dimensions=(4.58, 0.07845),
    panel_x_offset=0.3,
    panel_dimensions=((module_dimensions[1] - panel_x_offset * 2.0) / 4, 0.992),
    panel_support_dimensions=(module_dimensions[1], module_dimensions[2] - panel_dimensions[2] * 2.0),
    ref_mesh_panel=solar_panel(),
    ref_mesh_support=cylindrical_support(),
    tracking_angle=0.0
)
    TwoAxis(position, module_dimensions, main_support_dimensions, panel_support_dimensions, panel_dimensions, panel_x_offset, ref_mesh_panel, ref_mesh_support, tracking_angle)
end

function structure_meshes(s::TwoAxis)
    main_support_trans = Translation(s.module_dimensions[1] / 2, s.module_dimensions[2] / 2, 0.0) ∘
                         LinearMap(LinearAlgebra.Diagonal([
        s.main_support_dimensions[2],
        s.main_support_dimensions[2],
        s.main_support_dimensions[1],
    ]))
    main_support = PlantGeom.apply_transformation_to_mesh(main_support_trans, s.ref_mesh_support)

    secondary_support_trans = Translation(-s.panel_support_dimensions[1] / 2, s.module_dimensions[2] / 2, 0.0) ∘
                              LinearMap(RotY(π / 2)) ∘
                              LinearMap(LinearAlgebra.Diagonal([
        s.panel_support_dimensions[2],
        s.panel_support_dimensions[2],
        s.panel_support_dimensions[1],
    ]))
    secondary_support = PlantGeom.apply_transformation_to_mesh(secondary_support_trans, s.ref_mesh_support)

    scale_panel = LinearMap(LinearAlgebra.Diagonal([s.panel_dimensions[1], s.panel_dimensions[2], 0.01]))
    # Attaching the panels:
    panel1 = PlantGeom.apply_transformation_to_mesh(Translation(-s.panel_support_dimensions[1] / 2, s.module_dimensions[2] / 2 + s.panel_support_dimensions[2], 0.0) ∘ scale_panel, s.ref_mesh_panel)
    panel2 = PlantGeom.apply_transformation_to_mesh(Translation(s.panel_dimensions[1] - s.panel_support_dimensions[1] / 2, s.module_dimensions[2] / 2 + s.panel_support_dimensions[2], 0.0) ∘ scale_panel, s.ref_mesh_panel)
    panel3 = PlantGeom.apply_transformation_to_mesh(Translation(-s.panel_support_dimensions[1] / 2, 0.0, 0.0) ∘ scale_panel, s.ref_mesh_panel)
    panel4 = PlantGeom.apply_transformation_to_mesh(Translation(s.panel_dimensions[1] - s.panel_support_dimensions[1] / 2, 0.0, 0.0) ∘ scale_panel, s.ref_mesh_panel)

    panel5 = PlantGeom.apply_transformation_to_mesh(Translation(s.panel_dimensions[1] * 2 + s.panel_x_offset * 2.0 - s.panel_support_dimensions[1] / 2, s.module_dimensions[2] / 2 + s.panel_support_dimensions[2], 0.0) ∘ scale_panel, s.ref_mesh_panel)
    panel6 = PlantGeom.apply_transformation_to_mesh(Translation(s.panel_dimensions[1] * 3 + s.panel_x_offset * 2.0 - s.panel_support_dimensions[1] / 2, s.module_dimensions[2] / 2 + s.panel_support_dimensions[2], 0.0) ∘ scale_panel, s.ref_mesh_panel)
    panel7 = PlantGeom.apply_transformation_to_mesh(Translation(s.panel_dimensions[1] * 2 + s.panel_x_offset * 2.0 - s.panel_support_dimensions[1] / 2, 0.0, 0.0) ∘ scale_panel, s.ref_mesh_panel)
    panel8 = PlantGeom.apply_transformation_to_mesh(Translation(s.panel_dimensions[1] * 3 + s.panel_x_offset * 2.0 - s.panel_support_dimensions[1] / 2, 0.0, 0.0) ∘ scale_panel, s.ref_mesh_panel)

    return (; main_support, secondary_support, panel1, panel2, panel3, panel4, panel5, panel6, panel7, panel8)
end


function mtg_structure(s::TwoAxis, meshes)
    pos = s.position
    # ATM we only need to keep two meshes: the main support and the top structure, because only the top structure can move (but then it will be able to move ).
    # Iteratively merge the meshes:
    main_structure = meshes.main_support
    top_structure = merge([meshes.secondary_support, meshes.panel1, meshes.panel2, meshes.panel3, meshes.panel4, meshes.panel5, meshes.panel6, meshes.panel7, meshes.panel8])
    main_support_ref_mesh = PlantGeom.RefMesh("MainSupport", main_structure)
    top_structure_ref_mesh = PlantGeom.RefMesh("TopStructure", top_structure)

    main_support_node = MultiScaleTreeGraph.Node(
        MultiScaleTreeGraph.NodeMTG("/", "MainSupport", 1, 1),
        Dict{Symbol,Any}(
            :geometry => PlantGeom.Geometry(
                ref_mesh=main_support_ref_mesh,
                transformation=Translation(pos[1], pos[2], pos[3]),
            ),
        ),
    )

    top_structure_node = MultiScaleTreeGraph.Node(
        main_support_node,
        MultiScaleTreeGraph.NodeMTG("+", "TopStructure", 1, 1),
        Dict{Symbol,Any}(
            :geometry => PlantGeom.Geometry(
                ref_mesh=top_structure_ref_mesh,
                transformation=
                Translation(pos[1] + s.module_dimensions[1] / 2.0, pos[2], pos[3] + s.main_support_dimensions[1]) ∘
                LinearMap(RotY(deg2rad(-s.tracking_angle))),
            ),
        ),
    )

    return main_support_node
end
