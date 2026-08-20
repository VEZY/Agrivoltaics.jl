"""
    calculate_gcr(panel_dimensions::Tuple{Float64, Float64}, panel_tilt::Float64, row_spacing::Float64, interrow_spacing::Float64)

Return the value of the ground coverage ratio for the given photovoltaic configuration
"""
function calculate_gcr(
    panel_dimensions::Tuple{Float64, Float64},
    panel_tilt::Float64,
    row_spacing::Float64,
    intrarow_spacing::Float64,
    )

    # Calculate the area of the ground covered by the panels:
    panel_length = panel_dimensions[2]  # Assuming length is the second dimension
    panel_width = panel_dimensions[1]   # Assuming width is the first dimension
    panel_area = panel_length * panel_width
    panel_area *= cosd(panel_tilt)  # Get projected area at tilt angle

    # Calculate the total area of the ground:
    ground_area = (panel_length * cosd(panel_tilt) + row_spacing) * (panel_width + intrarow_spacing)

    # Calculate the ground coverage ratio:
    gcr = panel_area / ground_area

    return gcr
end