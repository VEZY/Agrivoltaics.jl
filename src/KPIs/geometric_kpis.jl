"""
    calculate_gcr(pv_structure<:ModuleStructure)

Return the value of the ground coverage ratio for the given agrivoltaic configuration
"""
function calculate_gcr(s::System)
    # Calculate the area of the ground covered by the panels:
    panel_length = s.panel.dimensions[2]  # Assuming length is the second dimension
    panel_width = s.panel.dimensions[1]   # Assuming width is the first dimension
    panel_area = panel_length * panel_width

    # Calculate the total area of the ground:
    ground_area = s.row_spacing * s.interrow_spacing

    # Calculate the ground coverage ratio:
    gcr = panel_area / ground_area

    return gcr
end

function calculate_sf(s::System)
    # Calculate the shading factor for the given agrivoltaic configuration
    # This is a placeholder implementation - replace with actual calculation
    sf = 0.5  # Example value
    return sf
end

function calculate_lhi(s::System)
    # Calculate the light homogeneity index for the given agrivoltaic configuration
    # This is a placeholder implementation - replace with actual calculation
    lhi = 0.8  # Example value
    return lhi
end