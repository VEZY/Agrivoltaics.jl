using Test

@testset "Fixed design" begin
    design = Fixed(position=Agrivoltaics.Point3(1.0, 2.0, 3.0), panel_dimensions=(1.2, 4.8), inclination=30.0, panel_height=2.5)

    meshes = Agrivoltaics.structure_meshes(design)
    @test meshes isa Agrivoltaics.GeometryBasics.Mesh

    node = structure(design)
    @test string(Agrivoltaics.MultiScaleTreeGraph.symbol(node)) == "Panel"
    @test length(Agrivoltaics.MultiScaleTreeGraph.children(node)) == 0
    @test haskey(Agrivoltaics.MultiScaleTreeGraph.attributes(node), :geometry)
end

@testset "Vertical design" begin
    design = Vertical(position=Agrivoltaics.Point3(0.5, 1.5, 0.0), panel_dimensions=(1.0, 2.0), support_dimensions=(0.8, 0.3), npanels_stacked=3)

    meshes = Agrivoltaics.structure_meshes(design)
    @test propertynames(meshes) == (:panel, :support)
    @test meshes.panel isa Agrivoltaics.GeometryBasics.Mesh
    @test meshes.support isa Agrivoltaics.GeometryBasics.Mesh

    node = structure(design)
    descendants = Agrivoltaics.MultiScaleTreeGraph.traverse(node, x -> x)

    @test string(Agrivoltaics.MultiScaleTreeGraph.symbol(node)) == "VerticalModule"
    @test length(Agrivoltaics.MultiScaleTreeGraph.children(node)) == 5
    @test length(descendants) == 6
    @test count(n -> string(Agrivoltaics.MultiScaleTreeGraph.symbol(n)) == "Panel", descendants) == 3
    @test count(n -> occursin("Support", string(Agrivoltaics.MultiScaleTreeGraph.symbol(n))), descendants) == 2
    @test all(haskey(Agrivoltaics.MultiScaleTreeGraph.attributes(child), :geometry) for child in Agrivoltaics.MultiScaleTreeGraph.children(node))
end

@testset "Two-axis design" begin
    design = TwoAxis(position=Agrivoltaics.Point3(0.0, 0.0, 0.0), tracking_angle=15.0)

    meshes = Agrivoltaics.structure_meshes(design)
    @test propertynames(meshes) == (:main_support, :secondary_support, :panel1, :panel2, :panel3, :panel4, :panel5, :panel6, :panel7, :panel8)
    @test all(getproperty(meshes, name) isa Agrivoltaics.GeometryBasics.Mesh for name in propertynames(meshes))

    node = structure(design)
    @test string(Agrivoltaics.MultiScaleTreeGraph.symbol(node)) == "MainSupport"
    @test length(Agrivoltaics.MultiScaleTreeGraph.children(node)) == 1
    @test length(Agrivoltaics.MultiScaleTreeGraph.traverse(node, x -> x)) == 2
    @test haskey(Agrivoltaics.MultiScaleTreeGraph.attributes(node), :geometry)
    @test string(Agrivoltaics.MultiScaleTreeGraph.symbol(Agrivoltaics.MultiScaleTreeGraph.children(node)[1])) == "TopStructure"
    @test haskey(Agrivoltaics.MultiScaleTreeGraph.attributes(Agrivoltaics.MultiScaleTreeGraph.children(node)[1]), :geometry)
end
