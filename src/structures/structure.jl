abstract type ModuleStructure end

"""
    structure(s<:ModuleStructure)

Create a structure for a given module design, *e.g.* `Fixed` or `Vertical`.
"""
function structure(s::S) where {S<:ModuleStructure}
    meshes = structure_meshes(s)
    return mtg_structure(s, meshes)
end

function structure(s::T) where {T}
    error("The structure $T is not yet supported.")
end
