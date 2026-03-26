# Agrivoltaics

[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://VEZY.github.io/Agrivoltaics.jl/stable)
[![Development documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://VEZY.github.io/Agrivoltaics.jl/dev)
[![Test workflow status](https://github.com/VEZY/Agrivoltaics.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/VEZY/Agrivoltaics.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/VEZY/Agrivoltaics.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/VEZY/Agrivoltaics.jl)
[![Docs workflow Status](https://github.com/VEZY/Agrivoltaics.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/VEZY/Agrivoltaics.jl/actions/workflows/Docs.yml?query=branch%3Amain)
[![BestieTemplate](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/JuliaBesties/BestieTemplate.jl/main/docs/src/assets/badge.json)](https://github.com/JuliaBesties/BestieTemplate.jl)

This package provides tools for modeling and simulating agrivoltaic systems, which combine agriculture and solar energy production on the same land.

Its objective is to include functions for calculating the shading effects of solar panels on crops, as well as tools for optimizing the layout of solar panels to maximize both energy production and crop yield.

## Installation

You can install the package using Julia's package manager. Open the Julia REPL and run:

```julia
using Pkg
Pkg.add("Agrivoltaics")
```

## Usage

After installing the package, you can start using it by importing it in your Julia code:

```julia
using Agrivoltaics
```

## Building solar panel layouts

You can build different solar panel designs and layouts.

The package includes three different solar panel designs: `Fixed`, `TwoAxis`, and `Vertical`. Each design is parameteric, allowing you to specify the dimensions and properties of the solar panels.

```julia
# Example of creating a fixed solar panel design
fixed_panel = Fixed(panel_dimensions= (1.0,4.2), inclination=30.0)
# Example of creating a two-axis solar panel design
two_axis_panel = TwoAxis(module_dimensions=(7.0, 2.0), tracking_angle=15.0)
# Example of creating a vertical solar panel design
vertical_panel = Vertical(panel_dimensions=(1., 2.0), npanels_stacked=1)
```

Then you can instantiate the structure of the solar panel design, which will create the meshes for the panels and supports.

```julia
fixed_structure = structure(fixed_panel)
two_axis_structure = structure(two_axis_panel)
vertical_structure = structure(vertical_panel)
```

You can visualize the panels using `plantviz` from the `PlantGeom` package.

```julia
using PlantGeom
plantviz(fixed_structure.meshes)
```