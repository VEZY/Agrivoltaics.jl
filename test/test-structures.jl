@testmodule StructureTestSetup begin
    # Code common to all tests
end

@testitem "Fixed design" setup = [StructureTestSetup] begin
    using GeometryBasics, MultiScaleTreeGraph
    design = Fixed(
        position=Point3(1.0, 2.0, 3.0),
        panel_dimensions=(1.2, 4.8),
        inclination=30.0,
        panel_height=2.5,
    )

    meshes = Agrivoltaics.structure_meshes(design)
    @test meshes isa GeometryBasics.Mesh

    node = structure(design)
    @test string(symbol(node)) == "Panel"
    @test length(children(node)) == 0
    @test haskey(attributes(node), :geometry)
end

@testitem "Vertical design" setup = [StructureTestSetup] begin
    using GeometryBasics, MultiScaleTreeGraph

    design = Vertical(
        position=Point3(0.5, 1.5, 0.0),
        panel_dimensions=(1.0, 2.0),
        support_dimensions=(0.8, 0.3),
        npanels_stacked=3,
    )

    meshes = Agrivoltaics.structure_meshes(design)
    @test propertynames(meshes) == (:panel, :support)
    @test meshes.panel isa GeometryBasics.Mesh
    @test meshes.support isa GeometryBasics.Mesh

    node = structure(design)
    descendants = traverse(node, x -> x)

    @test string(symbol(node)) == "VerticalModule"
    @test length(children(node)) == 5
    @test length(descendants) == 6
    @test count(n -> string(symbol(n)) == "Panel", descendants) == 3
    @test count(n -> occursin("Support", string(symbol(n))), descendants) == 2
    @test all(haskey(attributes(child), :geometry) for child in children(node))
end

@testitem "Two-axis design" setup = [StructureTestSetup] begin
    using GeometryBasics, MultiScaleTreeGraph

    design = TwoAxis(
        position=Point3(0.0, 0.0, 0.0),
        tracking_angle=15.0,
    )

    meshes = Agrivoltaics.structure_meshes(design)
    @test propertynames(meshes) == (:main_support, :secondary_support, :panel1, :panel2, :panel3, :panel4, :panel5, :panel6, :panel7, :panel8)
    @test all(getproperty(meshes, name) isa GeometryBasics.Mesh for name in propertynames(meshes))

    node = structure(design)
    @test string(symbol(node)) == "MainSupport"
    @test length(children(node)) == 1
    @test length(traverse(node, x -> x)) == 2
    @test haskey(attributes(node), :geometry)
    @test string(symbol(children(node)[1])) == "TopStructure"
    @test haskey(attributes(children(node)[1]), :geometry)
end
