# Set up project-specific R configuration
# This file runs when the project is opened in RStudio

# Add project-specific libraries to search path if needed
# .libPaths(c(.libPaths(), "renv/library"))

# Project-specific settings
options(
  width = 100,
  stringsAsFactors = FALSE
)

# Load renv if available
if (file.exists("renv.lock")) {
  if (requireNamespace("renv", quietly = TRUE)) {
    renv::activate()
  }
}
