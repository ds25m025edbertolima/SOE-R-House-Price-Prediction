# Project Documentation

This folder contains all project documentation, data dictionaries, and reference materials.

## Contents

### Project Documents (.qmd files)
- `01-project-objective.qmd` - Project goals and objectives
- `02-data-source-description.qmd` - Data source overview
- `03-project-organization.qmd` - Project structure and organization
- `04-development-plan.qmd` - Development methodology and plan
- `05-project-schedule-and-workpackages.qmd` - Timeline and work packages
- `06-data-subsetting-cleaning.qmd` - Data cleaning procedures
- `07-data-dictionary-appendix.qmd` - Detailed data column definitions
- `index.qmd` - Documentation index

### Data Dictionaries & Descriptions
- `PIERCE_COUNTY_DATA_DICTIONARY.qmd` - Pierce County assessor data column definitions
- `DATA_SOURCE_DESCRIPTION.md` - Data source information and disclaimers
- `00-eml-rd-data-description.pdf` - EML/RD data description document

### References
- `references.bib` - Bibliography file for citations
- `references.qmd` - References page

### Diagrams
Located in `diagrams/` subfolder:
- `er-diagram.png` - Entity relationship diagram
- `gantt.png` - Project Gantt chart
- `db_schema.jpeg` - Database schema
- `HousePricingTimeline.png` - Pricing timeline diagram
- `tasks.png` - Task breakdown
- `workflow.png` - Workflow diagram

## Building Documentation

To render these Quarto documents:

```bash
quarto render data/documentation/index.qmd
```

This will generate HTML documentation from the source .qmd files.

## Adding New Documentation

1. Create a `.qmd` file in this folder
2. Follow the existing naming convention (##-topic-name.qmd)
3. Add references to `index.qmd` if it's a main document
4. Run `quarto render` to build

## Related Folders

- `data/source/` - Raw source data files
- `data/processed/` - Cleaned data ready for analysis/Shiny app
- `etl/` - Data pipeline scripts that create processed data
