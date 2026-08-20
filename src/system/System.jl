struct System
    panel::MultiScaleTreeGraph.Node
    panel_mesh::GeometryBasics.Mesh
    norms::GeometryBasics.FaceView
    row_spacing::Float64
    interrow_spacing::Float64
    par_without_panels::Float64
    total_panel_surface::Float64
    panel_normal::Vector{Float64}
    sun_normal::Vector{Float64}
    total_ground_area::Float64
end

function System(;
    panel=Agrivoltaics.Fixed(panel_dimensions=(1.0, 4.2), inclination=25.0, panel_height=4.0) |> structure,
    panel_mesh=PlantGeom.refmesh_to_mesh(panel),
    norms=GeometryBasics.face_normals(panel_mesh.position, panel_mesh.faces),
    row_spacing=2.0,
    interrow_spacing=0.1,
    par_without_panels=1000.0,
    total_panel_surface=4.2,
    panel_normal=[0.0, 0.0, 1.0],
    sun_normal=[0.0, 1.0, 0.0],
    total_ground_area=100.0
)
    return System(panel, panel_mesh, norms, row_spacing, interrow_spacing, par_without_panels, total_panel_surface, panel_normal, sun_normal, total_ground_area)
end