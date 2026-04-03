function calculate_par_reduction(par_without_panels::Float64, total_panel_surface::Float64, panel_normal::Vector{Float64}, sun_normal::Vector{Float64}, total_ground_area::Float64)
    # Calculate the PAR reduction factor for the given agrivoltaic configuration
    par_reduction = par_without_panels * (1 - calculate_total_shaded_area(total_panel_surface, panel_normal, sun_normal) / total_ground_area)

    return par_reduction
end

function calculate_lhi(s::System)
    # Calculate the light homogeneity index for the given agrivoltaic configuration
    # This is a placeholder implementation - replace with actual calculation
    lhi = 0.8  # Example value
    return lhi
end

function calculate_radiation_kpis(s::System)
    par_reduction = calculate_par_reduction(s)
    lhi = calculate_lhi(s)
    
    return Dict("PAR Reduction" => par_reduction, "Light Homogeneity Index" => lhi)
end

"""
    calculate_total_shaded_area(total_panel_surface::Float64, panel_normal::Vector{Float64}, sun_normal::Vector{Float64})
    
Calculate the shaded area for direct radiation based on the agrivoltaic configuration.
"""
function calculate_total_shaded_area(total_panel_surface::Float64, panel_normal::Vector{Float64}, sun_normal::Vector{Float64})
    total_shaded_area = total_panel_surface * dot(panel_normal, sun_normal)

    return total_shaded_area
end