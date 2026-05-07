library(readr)
library(DBI)
library(RPostgres)
library(dplyr)

# --- Load environment variables ---
load_env <- function(file = ".env") {
  if (!file.exists(file)) {
    stop("Environment file not found: ", file)
  }
  lines <- readLines(file)
  for (line in lines) {
    line <- trimws(line)
    if (nzchar(line) && !startsWith(line, "#")) {
      parts <- strsplit(line, "=", fixed = TRUE)[[1]]
      if (length(parts) == 2) {
        key <- trimws(parts[1])
        value <- trimws(parts[2])
        Sys.setenv(key = value)
      }
    }
  }
}

load_env("../.env")

# --- Supabase connection ---
con <- dbConnect(
  RPostgres::Postgres(),
  host     = Sys.getenv("DB_HOST"),
  port     = as.integer(Sys.getenv("DB_PORT")),
  dbname   = Sys.getenv("DB_NAME"),
  user     = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD")
)

dbIsValid(con)

### APPRAISAL ACCOUNT
appraisal_account_data <- read_delim("raw_data/appraisal_account.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
appraisal_account_cols <- c("parcel_no", "appraisal_account_type", "business_name",
                            "value_area_id", "land_economic_area", "buildings", 
                            "group_account_no", "land_gross_acres", "lanf_net_acres",
                            "lang_gross_squarefeet", "land_net_squarefeet", "land_gross_frontfeet",
                            "land_width", "land_depth", "submerged_area_squarefeet",
                            "appraisal_date", "waterfront_type", "view_quality", 
                            "utility_electric", "utility_sewer", "utility_water",
                            "street_type", "latitude", "longitude"
                            )
colnames(appraisal_account_data) <- appraisal_account_cols

appraisal_account_data <- appraisal_account_data %>%
  mutate(
    appraisal_date         = as.Date(appraisal_date, format = "%m/%d/%y"),
    group_account_no       = as.character(group_account_no),
    buildings              = as.integer(buildings),
    land_width             = as.integer(land_width),
    land_depth             = as.integer(land_depth),
    submerged_area_squarefeet = as.integer(submerged_area_squarefeet)
  )



str(appraisal_account_data)
dbWriteTable(con, "APPRAISAL_ACCOUNT", appraisal_account_data, overwrite = TRUE, row.names = FALSE)

### IMPROVEMENT
improvement_data <- read_delim("raw_data/improvement.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
improvement_cols <- c("parcel_no", "building_id", "property_type",
                      "neighborhood", "neighborhood_extension", "squarefeet",
                      "net_squarefeet", "percent_complete", "condition",
                      "quality", "primary_occupancy_code", "primary_occupany_description",
                      "mobile_home_serial_no", "mobile_home_total_length", "mobile_home_make",
                      "attic_finished_squarefeet", "basement_squarefeet", "basement_finished_squarefeet",
                      "carport_squarefeet", "balcony_squarefeet", "porch_squarefeet",
                      "attached_garage_squarefeet", "detached_garage_squarefeet", "fireplaces",
                      "basement_garage_door")
colnames(improvement_data) <- improvement_cols
improvement_data <- improvement_data %>%
  mutate(
    building_id            = as.character(building_id),
    squarefeet             = as.integer(squarefeet),
    net_squarefeet         = as.integer(net_squarefeet),
    primary_occupancy_code = as.integer(primary_occupancy_code),
    mobile_home_total_length = as.integer(mobile_home_total_length),
    attic_finished_squarefeet = as.integer(attic_finished_squarefeet),
    basement_squarefeet    = as.integer(basement_squarefeet),
    basement_finished_squarefeet = as.integer(attic_finished_squarefeet),
    carport_squarefeet     = as.integer(carport_squarefeet),
    balcony_squarefeet     = as.integer(balcony_squarefeet),
    porch_squarefeet       = as.integer(porch_squarefeet),
    attached_garage_squarefeet = as.integer(attached_garage_squarefeet),
    detached_garage_squarefeet = as.integer(detached_garage_squarefeet),
    fireplaces             = as.integer(fireplaces),
    basement_garage_door   = as.integer(basement_garage_door)
    
    
  )


str(improvement_data)
dbWriteTable(con, "IMPROVEMENT", improvement_data, overwrite = TRUE, row.names = FALSE)



### IMPROVEMENT BUILT_AS
improvement_builtas_data <- read_delim("raw_data/improvement_builtas.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
improvement_builtas_cols <- c("parcel_no", "building_id", "builtas_no", 
                              "builtas_id", "builtas_description", "builtas_squarefeet", 
                              "hvac", "hvac_description", "exterior", 
                              "interior", "stories", "story_height", 
                              "sprinkler_squarefeet", "roof_cover", "bedrooms", 
                              "bathrooms", "units", "class_code", 
                              "class_description", "year_built", "year_remodeled", 
                              "adjusted_year_built", "physical_age", "builtas_length", 
                              "builtas_width", "mobile_home_model")
colnames(improvement_builtas_data) <- improvement_builtas_cols

improvement_builtas_data <- improvement_builtas_data %>%
  mutate(
    building_id         = as.character(building_id),
    builtas_no          = as.integer(builtas_no),
    builtas_id          = as.integer(builtas_id),
    builtas_squarefeet  = as.integer(builtas_squarefeet),
    story_height        = as.integer(story_height),
    sprinkler_squarefeet = as.integer(sprinkler_squarefeet),
    bedrooms            = as.integer(bedrooms),
    units           = as.integer(units),
    year_built      = as.integer(year_built),
    year_remodeled  = as.integer(year_remodeled),
    adjusted_year_built = as.integer(adjusted_year_built),
    physical_age    = as.integer(physical_age),
    builtas_length  = as.integer(builtas_length),
    builtas_width   = as.integer(builtas_width)
  )
improvement_builtas_data <- improvement_builtas_data %>% select(-hvac)
improvement_builtas_data <- improvement_builtas_data %>%
  filter(stories < 2019,
         bedrooms < 2004,
         bathrooms < 205,
         year_built > 0
)
str(improvement_builtas_data)
dbWriteTable(con, "IMPROVEMENT_BUILT_AS", improvement_builtas_data, overwrite = TRUE, row.names = FALSE)


### IMPROVEMENT DETAIL
improvement_detail_data <- read_delim("raw_data/improvement_detail.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
improvement_detail_cols <- c("parcel_no", "building_id", "detail_type",
                             "detail_description", "units")
colnames(improvement_detail_data) <- improvement_detail_cols
str(improvement_detail_data)
improvement_detail_data <- improvement_detail_data %>%
  mutate(
    building_id = as.character(building_id)
  )
improvement_detail_data <- improvement_detail_data %>%
  filter(
    units >= 0
  )
improvement_detail_data <- improvement_detail_data %>%
  mutate(across(where(is.character), 
                ~ iconv(., to = "UTF-8", sub = "")))  # sub="" removes bad chars
str(improvement_detail_data)
dbWriteTable(con, "IMPROVEMENT_DETAIL", improvement_detail_data, overwrite = TRUE, row.names = FALSE)

### LAND ATTRIBUTE
land_attribute_data <- read_delim("raw_data/land_attribute.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
land_attribute_cols <- c("parcel_no", "attribute", "attribute_description")
colnames(land_attribute_data) <- land_attribute_cols
str(land_attribute_data)
dbWriteTable(con, "LAND_ATTRIBUTE", land_attribute_data, overwrite = TRUE, row.names = FALSE)


### SALE
sale_data <- read_delim("raw_data/sale.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
sale_cols <- c("etn", "parcel_count", "parcel_no",
               "sale_date", "sale_price", "deed_type",
               "grantor", "grantee", "valid_invalid",
               "confirmed_unconfirmed", "exclude_reason", "improved_vacant",
               "appraisal_account_type")
colnames(sale_data) <- sale_cols
sale_data <- sale_data %>%
  mutate(
    parcel_count = as.integer(parcel_count),
    sale_date = as.Date(sale_date, format = "%m/%d/%y"),
    valid_invalid = as.integer(valid_invalid),
    confirmed_unconfirmed = as.integer(confirmed_unconfirmed),
    improved_vacant = as.integer(improved_vacant)
  )
str(sale_data)
sale_data <- sale_data %>%
  mutate(across(where(is.character), 
                ~ iconv(., to = "UTF-8", sub = "")))
dbWriteTable(con, "SALE", sale_data, overwrite = TRUE, row.names = FALSE)

### SEG MERGE
seg_merge_data <- read_delim("raw_data/seg_merge.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
seg_merge_cols <- c("merge_no", "parent_child_indicator", "parcel_no",
                    "continued_indicator", "completed_date", "tax_year")
colnames(seg_merge_data) <- seg_merge_cols
seg_merge_data <- seg_merge_data %>%
  mutate(
    tax_year = as.integer(tax_year)
  )
str(seg_merge_data)
dbWriteTable(con, "SEG_MERGE", seg_merge_data, overwrite = TRUE, row.names = FALSE)


### TAX ACCOUNT
tax_account_data <- read_delim("raw_data/tax_account.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
tax_account_cols <- c("parcel_no", "account_type", "property_type",
                      "site_address", "use_code", "use_description",
                      "tax_year_prior", "tax_code_area_prior_year", "exemption_type_prior_year",
                      "current_use_code_prior_year", "land_value_prior_year", "improvement_value_prior_year",
                      "total_market_value_prior_year", "taxable_value_prior_year", "tax_year_current",
                      "tax_code_area_current_year", "exemption_type_current_year", "current_use_code_current_year",
                      "land_value_current_year", "improvement_value_current_year", "total_market_value_current_year",
                      "taxable_value_current_year", "range", "township",
                      "section", "quarter_section", "subdivision_name", 
                      "located_on_parcel", "")
colnames(tax_account_data) <- tax_account_cols
tax_account_data <- tax_account_data %>%
  mutate(
    tax_year_prior = as.integer(tax_year_prior),
    land_value_prior_year = as.integer(land_value_prior_year),
    improvement_value_prior_year = as.integer(improvement_value_prior_year),
    total_market_value_prior_year = as.integer(total_market_value_prior_year),
    taxable_value_prior_year = as.integer(taxable_value_prior_year),
    tax_year_current = as.integer(tax_year_current),
    land_value_current_year = as.integer(land_value_current_year),
    improvement_value_current_year = as.integer(land_value_current_year),
    total_market_value_current_year = as.integer(total_market_value_current_year),
    taxable_value_current_year = as.integer(taxable_value_current_year)
  )
str(tax_account_data)
dbWriteTable(con, "TAX_ACCOUNT", tax_account_data, overwrite = TRUE, row.names = FALSE)


### TAX DESCRIPTION
tax_description_data <- read_delim("raw_data/tax_description.txt", delim = "|", trim_ws = TRUE, col_names = FALSE)
tax_description_cols <- c("parcel_no", "line_no", "tax_description_line")
colnames(tax_description_data) <- tax_description_cols
tax_description_data <- tax_description_data %>%
  mutate(
    line_no = as.integer(line_no)
  )
str(tax_description_data)
dbWriteTable(con, "TAX_DESCRIPTION", tax_description_data, overwrite = TRUE, row.names = FALSE)



dbDisconnect(con)