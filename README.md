# Toronto Maple Leafs Analytics

## Overview
All analysis scripts live in `final_project.rmd`, covering:

- Seven‑Spoke Radars: compares six centers across metrics
- 5×5 xG Rink Plot: shows forwards’ goal probabilities
- Defense Summary: GT table of defensemen stats
- Loss‑% Tier List: opponent tier list by loss percentage
- Forward Goal Probability Map: heatmap of forwards’ xG

## For Professor

- **Infographic:** [Leafs101.pdf](Leafs101.pdf) — high-level overview of key metrics.  
- **In-Depth Report:** [Into_the_Leafs'_Verse.pdf](Into_the_Leafs'_Verse.pdf) - Final Project: Into the Leafs’ Verse* — comprehensive analysis and methodology.  
- **Presentation Video:** [YouTube Deep Dive](https://youtu.be/g2mUgGrDnyY) — narrated walkthrough of findings.  
- **Rcode:** [final_project.rmd](final_project.rmd) — R Markdown file with all code

## Installation
Install required R packages once:

```r
install.packages(c(
  "readr","dplyr","scales","ggplot2","ggradar",
  "patchwork","RColorBrewer","purrr","viridis","sportyR",
  "gt","gtExtras","glue","png","rsvg","grDevices","tidyr"
))
```

## Usage
Render the single R Markdown file:

```bash
Rscript -e "rmarkdown::render('final_project.rmd')"
```

This will produce all plots and tables as PNGs in your working directory.

## Files
| File                 | Description                                      |
|----------------------|--------------------------------------------------|
| `final_project.rmd`  | R Markdown with all analysis and visuals         |
| `seven_spoke_radars.png`      | Radial comparison plots                    |
| `leafs_xg_rink_plot.png`      | 5×5 xG surface + forwards’ goals plot   |
| `maple_leafs_defense_table.png` | Defense summary GT table                  |
| `loss_pct_tier_list.png`      | Leafs loss‑% tier list                     |
| `leafs_goal_prob_forwards.png` | Forward goal probability heatmap           |

## Contributing
Feel free to open issues or pull requests.

## License
MIT © 2025

