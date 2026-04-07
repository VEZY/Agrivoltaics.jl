using Test
using Agrivoltaics

@testset "Geometric KPI tests" begin
    @testset "calculate_gcr" begin
        # Example panel dimensions: width=1 m, length=2 m
        # row spacing=4 m, interrow spacing=5 m
        # projected panel area = 2 * cos(30°) = 1.7320508075688772 m^2
        # ground area = 4 * 5 = 20 m^2
        # expected GCR = 1.7320508075688772 / 20 = 0.08660254037844386
        gcr = calculate_gcr((1.0, 2.0), 30.0, 4.0, 5.0)
        @test isapprox(gcr, 0.08660254037844386; atol=1e-8, rtol=1e-8)

        # Zero tilt should return (panel area / ground area) (no cosine reduction)
        gcr_flat = calculate_gcr((1.0, 2.0), 0.0, 4.0, 5.0)
        @test isapprox(gcr_flat, 0.1; atol=1e-8, rtol=1e-8)
    end
end

@testset "Radiation KPI tests" begin
    @testset "calculate_total_shaded_area" begin
        # Test with perpendicular normals (dot product = 1)
        panel_normal = [0.0, 0.0, 1.0]
        sun_normal = [0.0, 0.0, 1.0]
        total_panel_surface = 10.0
        shaded_area = calculate_total_shaded_area(total_panel_surface, panel_normal, sun_normal)
        @test shaded_area == 10.0

        # Test with parallel normals (dot product = 0)
        panel_normal = [0.0, 0.0, 1.0]
        sun_normal = [0.0, 1.0, 0.0]
        shaded_area = calculate_total_shaded_area(total_panel_surface, panel_normal, sun_normal)
        @test shaded_area == 0.0
    end

    @testset "calculate_par_reduction" begin
        par_without_panels = 1000.0
        total_panel_surface = 10.0
        panel_normal = [0.0, 0.0, 1.0]
        sun_normal = [0.0, 0.0, 1.0]
        total_ground_area = 100.0
        par_reduction = calculate_par_reduction(par_without_panels, total_panel_surface, panel_normal, sun_normal, total_ground_area)
        expected = 1000.0 * (1 - 10.0 / 100.0)  # 900.0
        @test par_reduction == expected
    end

    @testset "calculate_lhi" begin
        # Create a default system
        s = System()
        lhi = calculate_lhi(s)
        @test lhi == 0.8  # Placeholder value
    end
end

@testset "Yield KPI tests" begin
    @testset "calculate_ler" begin
        # Test with a dummy input
        input = 1.0
        ler = calculate_ler(input)
        @test ler == 1.2  # Placeholder value
    end
end
