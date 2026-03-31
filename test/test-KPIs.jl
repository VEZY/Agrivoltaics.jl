@testitem "GCR indicator" setup = [KPIsTestSetup] begin
    using GeometryBasics, MultiScaleTreeGraph
    design = Fixed(
        position=Point3(1.0, 2.0, 3.0),
        panel_dimensions=(1.2, 4.8),
        inclination=30.0,
        panel_height=2.5,
    )

    syst = System(
        inrow_spacing=0.1,
        row_to_row_spacing=5,
        pv_structure=design,
    )
    
    gcr = calculate_gcr(design)
end