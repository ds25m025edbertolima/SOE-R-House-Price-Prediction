# SOE-R-House-Price-Prediction
Solution Engineering Project - House Price Prediction

## Structure

```
.
├── .Rprofile
├── .gitignore
├── README.md
├── analysis
│   ├── archive
│   └── markdown
├── data
│   ├── documentation
│   ├── handmade
│   ├── processed
│   ├── public
│   └── source
├── etl
├── shiny
├── publish
├── scratch
├── viz
├── 99-archive
└── house-price-prediction.Rproj
```

- `.Rprofile`
  - Stores environment variables for local R projects.
- `.gitignore`
  - Ignores `packrat` and R user profile temporary files.
- `README.md`
  - Project-specific readme with boilerplate for data projects.
  - Includes sourcing details and places to explain how to replicate/remake the project.
- `analysis`
  - R code that involves analysis on already-cleaned data. Code for cleaning data should go in `etl`.
    - Multiple analysis files are numbered sequentially.
    - If we are sharing the data, last analysis script is called make_dw_files.R to write_csv to public folder.
  - `analysis/archive`
    - Any analyses for story threads that are no longer being investigated are placed here for reference.
  - `analysis/markdown`
    - Any R Markdown files go here. 
    - The AP has an R Markdown template here: https://github.com/associatedpress/apstyle
- `data`
  - This is the directory used with our `datakit-data` plugin.
  - `data/documentation`
    - Documentation on data files and project documentation (.qmd files, references, data dictionaries).
  - `data/handmade`
    - Manually created data sets by reporters go here.
  - `data/processed`
    - Data that has been processed by scripts in this project and is clean and ready for analysis/Shiny app goes here.
  - `data/public`
    - Public-facing data files (i.e., final datasets we share with reporters/make accessible) go here - data files which are 'live'.
  - `data/source`
    - Original data from sources goes here.
- `etl`
  - ETL (extract, transform, load) scripts for reading in source data and cleaning and standardizing it to prepare for analysis go here.
    - Multiple etl files are numbered.
    - Joins are included in etl process.
    - Last step of ETL process is to output an RDS file to data/processed.
        - naming convention: etl_WHATEVERNAME.rds
- `shiny`
  - Shiny application code for the interactive house price prediction application.
    - Contains UI, server logic, modules, and supporting functions.
- `publish`
  - This directory holds all documents in the project that will be public facing (e.g. data.world RMarkdown files).
- `scratch`
  - This directory contains scratch materials that will not be used in the project at the end.
  - Common cases are filtered tables or quick visualizations for reporters.
  - This directory is not tracked in git.
- `viz`
  - Graphics and visualization development specific work such as web interactive code should go here.
- `99-archive`
  - Old files, generated documentation, and build artifacts that are no longer actively used.
  - This directory is not tracked in git.
  - Contains: `_book-generated/`, `html_reports-generated/`, `.quarto-cache/`, presentation files, etc.
- `house-price-prediction.Rproj`
  - This is the .Rproj file that can be used with RStudio to work within the project.
