struct System
    panel::MultiScaleTreeGraph.Node
    panel_mesh::GeometryBasics.Mesh
    norms::GeometryBasics.FaceView
    row_spacing::Float64
    interrow_spacing::Float64
end

function System(;
    panel=Agrivoltaics.Fixed(panel_dimensions=(1.0, 4.2), inclination=25.0, panel_height=4.0) |> structure,
    panel_mesh=PlantGeom.refmesh_to_mesh(panel),
    norms=GeometryBasics.face_normals(panel_mesh.position, panel_mesh.faces),
    row_spacing=2.0,
    interrow_spacing=0.1,
)
    return System(panel, panel_mesh, norms, row_spacing, interrow_spacing)
end