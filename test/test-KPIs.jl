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
