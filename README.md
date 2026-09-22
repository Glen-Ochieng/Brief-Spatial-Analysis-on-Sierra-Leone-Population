# Sierra Leone Population Analysis: 2020–2025

This project examines population trends and geographic population distribution across Sierra Leone’s administrative districts from 2020 to 2025. The analysis combines population estimates with district-level spatial data to show how Sierra Leone’s population changed over time and where the largest population concentrations are located.

## Key Findings

- Sierra Leone’s total population increased from approximately **7.77 million in 2020** to **8.58 million in 2025**.
- This represents an overall population increase of approximately **10.4%** over the six-year period.
- The **Northern Region** recorded the largest population among Sierra Leone’s regions.
- **Western Area Urban, Kenema, and Bo** were among the most populous districts and together accounted for approximately **15% of the total population**.
- The accompanying maps illustrate how population distribution varied across districts and changed between 2020 and 2025.

## Analysis Overview

The analysis involved:

1. Importing Sierra Leone district boundary data from a GeoPackage file.
2. Importing district-level population data for 2020–2025.
3. Cleaning missing administrative district names and correcting population entries.
4. Removing duplicate district-year observations.
5. Converting variables to their appropriate data types.
6. Joining population estimates to district-level spatial boundaries.
7. Creating charts and maps to examine population growth and geographic distribution.

## Tools and Technologies

The analysis was conducted in **R** using the following packages:

- `tidyverse` for data manipulation and visualization
- `sf` for working with spatial data
- `ggspatial` for spatial visualization and map presentation
- `ggplot2` for charts and graphics

## Repository Contents

```text
.
├── GlenOchiengSubmission.Rmd
├── GlenOchiengSubmission.pdf
├── sle_pop_2020_2025.csv
└── who_shapefile_sle_adm2_latest.gpkg
