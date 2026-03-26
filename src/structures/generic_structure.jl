
"""
    cylindrical_support()
    cylindrical_support(r, l)

Create a mesh for a simple cylindrical support structure with equal dimensions of one with no arguments, or with radius `r` and length `l` in the z direction.
"""
cylindrical_support() = mesh(Cylinder(Point3(0.0, 0.0, 0.0), Point3(0.0, 0.0, 1.0), 1.0))
cylindrical_support(r, l) = mesh(Cylinder(Point3(0.0, 0.0, 0.0), Point3(0.0, 0.0, l), r))

"""
    solar_panel()

A simple solar panel with dimension unit of one.
"""
function solar_panel()
    mesh_vertices = [
        Point3(0.0, 0.0, 0.0),
        Point3(1.0, 0.0, 0.0),
        Point3(1.0, 1.0, 0.0),
        Point3(0.0, 1.0, 0.0),
    ]

    mesh_faces = [
        TriangleFace(1, 2, 3),
        TriangleFace(1, 3, 4),
    ]

    plane = Mesh(mesh_vertices, mesh_faces)

    return plane
end