# House Price Prediction - Analysis Workflow

This document describes the complete workflow for the house price prediction project, showing how the EDA, linear regression analysis, and prediction app are integrated.

## Project Structure

```
SOE-R-House-Price-Prediction/
├── data/
│   ├── source/              # Original raw data files
│   ├── prepared/            # Cleaned and prepared datasets
│   └── documentation/       # Data dictionary and documentation
├── eda/
│   ├── eda.qmd             # Exploratory Data Analysis
│   └── (outputs from EDA)
├── analysis/
│   ├── 01-linear-regression-analysis.qmd   # Linear Regression Models
│   └── (model outputs)
├── models/                  # Trained models for deployment
│   ├── linear_regression_model.rds
│   └── model_metadata.rds
├── shiny/
│   └── app.R               # Prediction app (future)
├── viz/                     # Visualizations
└── ANALYSIS_WORKFLOW.md    # This file
```

## Complete Workflow

### Phase 1: Exploratory Data Analysis (EDA)

**File:** `eda/eda.qmd`

**Purpose:** Load raw data, clean, prepare, and engineer features.

**Key Steps:**
1. Load multiple data source tables (sale, appraisal, improvement, etc.)
2. Perform data quality checks (missing values, duplicates, outliers)
3. Feature selection and engineering
4. Filter to residential properties with valid sale prices
5. Create derived features (price per sqft, quality score, interactions, location clusters)
6. Final feature selection focused on app-usable inputs

**Output:** `app_model_df` (254,000+ observations with 19 features)

**Key Features in app_model_df:**
- **Target:** `sale_price`
- **Time:** `sale_year`
- **Location:** `latitude`, `longitude`, `location_cluster`
- **Size:** `square_feet`, `land_net_square_feet`, `total_size_score`
- **Quality:** `quality_score`
- **Rooms:** `bathrooms`, `bedrooms`, `bathrooms_per_1000_sqft`, `bedrooms_per_1000_sqft`
- **Age:** `year_built`
- **Amenities:** Boolean features (garage, deck, pool, waterfront, finished space)
- **Interactions:** size × quality, bathrooms × quality, etc.

**To run EDA:**
```r
# In RStudio: Open eda/eda.qmd and click "Render" or:
quarto::quarto_render("eda/eda.qmd")
```

---

### Phase 2: Linear Regression Analysis

**File:** `analysis/01-linear-regression-analysis.qmd`

**Purpose:** Build and evaluate linear regression models for house price prediction.

**Workflow:**
1. Load prepared data from EDA (`app_model_df`)
2. Identify feature types (numeric, categorical, boolean)
3. Build multiple model specifications:
   - **Full Model:** All features
   - **Simplified Model:** Only statistically significant features (p < 0.05)
   - **Core Model:** Key features for simplicity and interpretability
4. Compare models using R², Adjusted R², AIC, BIC, RMSE
5. Test linear regression assumptions:
   - Linearity
   - Homoscedasticity (Breusch-Pagan test)
   - Normality of residuals (Q-Q plots)
   - Independence (Durbin-Watson test)
   - No multicollinearity (VIF analysis)
6. Perform diagnostics (residual plots, influential points)
7. Interpret coefficients and feature importance
8. Evaluate out-of-sample performance
9. Select best model

**Expected Output:**
- Model comparison table
- Diagnostic plots
- Assumption test results
- Coefficient interpretation
- Best model for deployment

**To run Linear Regression Analysis:**
```r
# In RStudio: Open analysis/01-linear-regression-analysis.qmd and click "Render" or:
quarto::quarto_render("analysis/01-linear-regression-analysis.qmd")
```

**Key Outputs:**
- `best_model`: The selected linear regression model object
- `best_model_name`: Name of the selected model
- Visualization plots showing relationships and diagnostics
- Performance metrics and comparison tables

---

### Phase 3: Export Model for Prediction App

**Within:** `analysis/01-linear-regression-analysis.qmd` (Section 11.3)

**Purpose:** Save the trained model for use in the Shiny prediction app.

**Code included in analysis document:**
```r
# Automatic model export (at end of analysis)
model_export_path <- "models/linear_regression_model.rds"
saveRDS(best_model, model_export_path)
saveRDS(model_metadata, "models/model_metadata.rds")
```

**Outputs:**
- `models/linear_regression_model.rds` - Trained model object
- `models/model_metadata.rds` - Model performance metrics and metadata

---

### Phase 4: Prediction App (Future)

**File:** `shiny/app.R` (to be created)

**Purpose:** Interactive web application for house price predictions.

**How it will work:**
1. Load the trained model: `readRDS("../models/linear_regression_model.rds")`
2. Accept user inputs (property characteristics)
3. Create prediction data frame with same features as training data
4. Use `predict()` to generate price estimate
5. Display results with confidence intervals

**Example usage in app:**
```r
# Load model
model <- readRDS("../models/linear_regression_model.rds")

# Create new property data
new_property <- data.frame(
  sale_year = 2025,
  square_feet = 2500,
  bathrooms = 2.5,
  bedrooms = 4,
  latitude = 47.45,
  longitude = -122.30,
  # ... other features ...
)

# Predict
predicted_price <- predict(model, newdata = new_property)
```

---

## Running the Complete Analysis

### Option A: Run Each Phase Separately

```r
# 1. Run EDA
quarto::quarto_render("eda/eda.qmd")

# 2. Run Linear Regression Analysis
quarto::quarto_render("analysis/01-linear-regression-analysis.qmd")

# Model is automatically saved to models/ folder
```

### Option B: Run Everything in Sequence

```r
# Load and run all analyses
source("scripts/run_complete_analysis.R")  # (Create this script)
```

### Option C: Interactive Development

1. Open `eda/eda.qmd` in RStudio
2. Click "Run Document" or use `Ctrl+Shift+Enter`
3. Wait for EDA to complete (creates `app_model_df`)
4. Open `analysis/01-linear-regression-analysis.qmd`
5. Click "Run Document"
6. Wait for analysis to complete (creates model files)
7. Check `models/` folder for saved model

---

## Data Flow Diagram

```
eda/eda.qmd
    ↓
    ├─ Load raw data (sale.txt, improvement.txt, etc.)
    ├─ Clean & prepare features
    ├─ Engineer derived features
    │
    ↓
    app_model_df (254,000+ rows × 19 features)
    │
    ↓
analysis/01-linear-regression-analysis.qmd
    │
    ├─ Load app_model_df
    ├─ Build Model 1: Full Model
    ├─ Build Model 2: Simplified Model
    ├─ Build Model 3: Core Features Model
    ├─ Compare & Select Best Model
    ├─ Test Assumptions
    ├─ Generate Diagnostics
    │
    ↓
    best_model + metadata
    │
    ├─ SavedAs: models/linear_regression_model.rds
    └─ SavedAs: models/model_metadata.rds
        │
        ↓
    shiny/app.R (future deployment)
        │
        ├─ Load model
        ├─ Accept user inputs
        ├─ Generate predictions
        └─ Display results
```

---

## Key Variables and Their Roles

### EDA Output Features

| Feature Category | Features | EDA Section |
|-----------------|----------|------------|
| **Target** | `sale_price` | 21.1 |
| **Time** | `sale_year` | 21.2 |
| **Location** | `latitude`, `longitude`, `location_cluster` | 22.7 |
| **Size** | `square_feet`, `land_net_square_feet`, `total_size_score` | 22.3 |
| **Quality** | `quality_score` | 22.4 |
| **Rooms** | `bathrooms`, `bedrooms`, `bathrooms_per_1000_sqft`, `bedrooms_per_1000_sqft` | 22.5 |
| **Age** | `year_built` | 21.3.1 |
| **Amenities** | `has_garage_or_carport_detail`, `has_deck_or_porch_detail`, `has_finished_space_detail`, `has_pool_or_spa_detail`, `has_waterfront_detail` | 21.5 |
| **Interactions** | `square_feet_quality_interaction`, `bathrooms_quality_interaction`, `finished_space_size_interaction`, `waterfront_land_interaction` | 22.6 |

### Linear Regression Analysis Outputs

| Output | Type | Location | Purpose |
|--------|------|----------|---------|
| `model_full` | R object | Memory | Baseline model with all features |
| `model_simplified` | R object | Memory | Best model with significant features |
| `best_model` | R object | Memory | Selected model for deployment |
| `best_model_name` | Character | Memory | Name of selected model |
| Diagnostic plots | Visualizations | HTML report | Assumption testing |
| Coefficient table | Data frame | HTML report | Feature interpretation |
| Saved model | RDS file | `models/linear_regression_model.rds` | For Shiny app |
| Model metadata | RDS file | `models/model_metadata.rds` | Reference info |

---

## Important Notes

### Feature Naming Conventions

When building the prediction app, ensure that:
1. Feature names match exactly with EDA output
2. Boolean features must be TRUE/FALSE or 0/1
3. Categorical features (if any) must use the same encoding as EDA
4. Numeric features should be scaled/normalized consistently

### Missing Values

The EDA handles all missing values before creating `app_model_df`. The linear regression model expects:
- **No missing values** in any features
- All numeric features should be numeric type
- All boolean features should be logical type

### Model Assumptions

The linear regression model assumes:
1. **Linearity:** Relationships between features and price are linear
2. **Independence:** Observations are independent
3. **Homoscedasticity:** Constant variance across predictions
4. **Normality:** Residuals are approximately normally distributed
5. **No multicollinearity:** Features are not highly correlated

If assumptions are violated, consider:
- Log transformations of the target variable
- Polynomial features for non-linear relationships
- Regularization methods (Ridge/Lasso)
- Alternative models (tree-based, GAM, etc.)

### Performance Expectations

Based on EDA findings:
- **Expected R²:** Moderate to good (0.60-0.85)
- **Most important features:** sale_year, square_feet, quality_score, bathrooms, neighborhood/location
- **Weaker features:** Individual amenities (unless combined)

---

## Troubleshooting

### If EDA won't run:
- Check that all data files exist in `data/source/`
- Verify column names match the source file specifications
- Check for sufficient disk space and RAM

### If Linear Regression Analysis fails:
- Ensure `app_model_df` is available in the environment
- Check that all expected columns exist
- Verify no missing values in critical features

### If model export fails:
- Create `models/` directory manually if needed
- Check write permissions in the project directory
- Verify RDS package is installed

---

## Next Steps

1. **Complete the EDA** - Run `eda/eda.qmd` to completion
2. **Run Linear Regression** - Execute `analysis/01-linear-regression-analysis.qmd`
3. **Verify Model Export** - Check that files appear in `models/` folder
4. **Build Shiny App** - Create `shiny/app.R` using the exported model
5. **Test Predictions** - Validate app with known properties
6. **Deploy** - Host the Shiny app for users

---

## References

- **EDA Document:** `eda/eda.qmd`
- **Linear Regression Analysis:** `analysis/01-linear-regression-analysis.qmd`
- **Quarto Documentation:** https://quarto.org/
- **R Linear Regression:** https://stat.ethz.ch/R-manual/R-devel/library/stats/html/lm.html
- **Shiny Documentation:** https://shiny.rstudio.com/
