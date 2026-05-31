# Shiny App - Pierce County House Price Prediction

This folder contains the interactive Shiny application for the house price prediction project.

## Structure

```
shiny/
├── app.R              # Main application file (entry point)
├── README.md          # This file
├── ui/                # UI components (optional, for modular design)
├── server/            # Server logic (optional, for modular design)
└── modules/           # Shiny modules for reusable components
```

## Getting Started

### Requirements
- R 4.0+
- Shiny
- ggplot2
- dplyr

### Running the App

```R
library(shiny)
runApp("./shiny")
```

Or from the project root:
```R
runApp("./shiny")
```

## Development Notes

1. **Load Data**: Update the data loading section in `app.R` to read from `data/processed/`
2. **UI Design**: Add interactive inputs for price prediction parameters
3. **Visualizations**: Use `ggplot2` for creating publication-quality plots
4. **Modules**: As complexity grows, split UI/Server into modular components

## Related Folders

- `data/processed/` - Clean data ready for the Shiny app
- `etl/` - Data pipeline scripts that prepare data for the app
- `data/documentation/` - Project documentation and data dictionaries
