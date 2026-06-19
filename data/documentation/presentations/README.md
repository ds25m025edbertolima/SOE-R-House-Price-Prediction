# Weekly Presentations

This folder contains all weekly presentation deliverables throughout the project.

## Structure

Each week has a dedicated folder with source files and rendered outputs:

```
presentations/
├── 01-week-1/      (13-19 May)   - Project Setup & Proposal
├── 02-week-4/      (3-9 Jun)     - 
└── 03-week-7/      (24 Jun)      - Final Presentation
```

## Weekly Deliverables

### Week 1: Project Setup & Proposal (13-19 May)
- Project objectives
- Data dictionary
- Organization & team roles
- Development plan

### Week 2: Data Integration (20-26 May)
- Data source overview
- Integration approach
- Initial exploration

### Week 3: Data Cleaning (27 May - 2 Jun)
- Cleaning procedures
- Data quality assessment
- Prepared datasets

### Week 4: EDA & Features (3-9 Jun)
- Exploratory analysis findings
- Feature engineering approach
- Visualization previews

### Week 5: Model Development (10-16 Jun)
- Baseline models
- Multiple algorithm implementations
- Cross-validation results

### Week 6: Model Evaluation & Shiny App (17-23 Jun)
- Model comparison & selection
- Shiny app prototype demo
- Feature importance analysis

### Week 7: Final Presentation (24 Jun)
- Live app demonstration
- Key findings & insights
- Business recommendations

## File Organization

For each week, organize files as:

```
XX-week-N/
├── presentation.qmd        # Source file
├── presentation.html       # Rendered HTML
├── presentation.pdf        # Rendered PDF (if needed)
└── assets/                 # Supporting images, data, etc.
    ├── chart1.png
    └── ...
```

## Creating a Presentation

1. Create `presentation.qmd` in the week folder
2. Add content using Quarto Markdown
3. Render with: `quarto render presentation.qmd`
4. Outputs will be generated as HTML/PDF

Example structure in .qmd:
```qmd
---
title: "Week X: Topic Name"
date: "2026-05-XX"
format: 
  revealjs:
    theme: default
---

## Slide 1: Introduction

Content here

## Slide 2: Key Findings

- Point 1
- Point 2
```

## Tips

- Use Reveal.js format for interactive presentations
- Include live code demos when possible
- Link to detailed documentation in main docs
- Save PDF for records
- Keep presentations concise (15-20 mins)
