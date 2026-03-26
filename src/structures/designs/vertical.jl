"""
    Vertical(;
        position=Point3(0.0, 0.0, 0.0),
        panel_dimensions=(1., 2.0),
        support_dimensions=(0.8, 0.3),
        npanels_stacked=1,
        ref_mesh_panel=solar_panel(),
        ref_mesh_support=cylindrical_support()
    )

Structure of a vertical bifacial panel with a single support.
"""
struct Vertical{T} <: ModuleStructure
    position::GeometryBasics.Point{3,T}
    panel_dimensions::Tuple{T,T}
    support_dimensions::Tuple{T,T}
    npanels_stacked::Int
    ref_mesh_panel::GeometryBasics.Mesh
    ref_mesh_support::GeometryBasics.Mesh
end

function Vertical(;
    position=Point3(0.0, 0.0, 0.0),
    panel_dimensions=(1.0, 2.0),
    support_dimensions=(0.8, 0.03),
    npanels_stacked=1,
    ref_mesh_panel=solar_panel(),
    ref_mesh_support=cylindrical_support()
)
    Vertical(position, panel_dimensions, support_dimensions, npanels_stacked, ref_mesh_panel, ref_mesh_support)
end

function structure(s::Vertical)
    meshes = structure_meshes(s)
    return mtg_structure(s, meshes)
end

function structure_meshes(s::Vertical)
    panel_trans = LinearMap(RotY(-π / 2.0)) ∘
                  LinearMap(LinearAlgebra.Diagonal([s.panel_dimensions[1], s.panel_dimensions[2], 1e-9]))
    panel = PlantGeom.apply_transformation_to_mesh(panel_trans, s.ref_mesh_panel)

    support_trans = LinearMap(LinearAlgebra.Diagonal([
        s.support_dimensions[2],
        s.support_dimensions[2],
        s.support_dimensions[1] + s.panel_dimensions[1] * s.npanels_stacked,
    ]))
    support = PlantGeom.apply_transformation_to_mesh(support_trans, s.ref_mesh_support)

    return (; panel, support)
end

function mtg_structure(s::Vertical, meshes)
    pos = s.position
    support_ref_mesh = PlantGeom.RefMesh("Support", meshes.support)
    panel_ref_mesh = PlantGeom.RefMesh("Panel", meshes.panel)

    module_node = MultiScaleTreeGraph.Node(MultiScaleTreeGraph.NodeMTG("/", "VerticalModule", 1, 1), Dict{Symbol,Any}())
    support_left_node = MultiScaleTreeGraph.Node(
        module_node,
        MultiScaleTreeGraph.NodeMTG("+", "SupportLeft", 1, 1),
        Dict{Symbol,Any}(
            :geometry => PlantGeom.Geometry(
                ref_mesh=support_ref_mesh,
                transformation=Translation(pos[1], pos[2], pos[3]),
            ),
        ),
    )
    support_right_node = MultiScaleTreeGraph.Node(
        module_node,
        MultiScaleTreeGraph.NodeMTG("+", "SupportRight", 1, 1),
        Dict{Symbol,Any}(
            :geometry => PlantGeom.Geometry(
                ref_mesh=support_ref_mesh,
                transformation=Translation(0.0, s.panel_dimensions[2] + s.support_dimensions[2], 0.0) ∘
                               Translation(pos[1], pos[2], pos[3]),
            ),
        ),
    )

    panel_node_bottom = MultiScaleTreeGraph.Node(
        module_node,
        MultiScaleTreeGraph.NodeMTG("+", "Panel", 0, 1),
        Dict{Symbol,Any}(
            :geometry => PlantGeom.Geometry(
                ref_mesh=panel_ref_mesh,
                transformation=Translation(0.0, s.support_dimensions[2] / 2.0, s.support_dimensions[1]) ∘
                               Translation(pos[1], pos[2], pos[3]),
            ),
        ),
    )

    for p in 1:(s.npanels_stacked-1)
        MultiScaleTreeGraph.Node(
            module_node,
            MultiScaleTreeGraph.NodeMTG("+", "Panel", p, 1),
            Dict{Symbol,Any}(
                :geometry => PlantGeom.Geometry(
                    ref_mesh=panel_ref_mesh,
                    transformation=Translation(0.0, s.support_dimensions[2] / 2.0, s.support_dimensions[1] + s.panel_dimensions[1] * p) ∘
                                   Translation(pos[1], pos[2], pos[3]),
                ),
            ),
        )
    end

    return module_node
end
