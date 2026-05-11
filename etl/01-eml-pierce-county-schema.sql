-- Pierce County Assessor-Treasurer Data Mart Schema
-- SQL DDL (Data Definition Language) for property assessment and appraisal data
-- Compatible with PostgreSQL, MySQL, SQL Server

-- ============================================================================
-- TAX ACCOUNT TABLE
-- Tracks current tax and assessment account information for each property
-- ============================================================================

CREATE TABLE tax_account (
    parcel_number VARCHAR(10) PRIMARY KEY,
    account_type VARCHAR(5) NOT NULL,
    property_type VARCHAR(5),
    site_address VARCHAR(50),
    use_code VARCHAR(5),
    use_description VARCHAR(50),
    tax_year_prior INTEGER,
    tax_code_area_prior_year VARCHAR(10),
    exemption_type_prior_year VARCHAR(40),
    current_use_code_prior_year VARCHAR(5),
    land_value_prior_year INTEGER,
    improvement_value_prior_year INTEGER,
    total_market_value_prior_year INTEGER,
    taxable_value_prior_year INTEGER,
    tax_year_current INTEGER,
    tax_code_area_current_year VARCHAR(10),
    exemption_type_current_year VARCHAR(40),
    current_use_code_current_year VARCHAR(5),
    land_value_current_year INTEGER,
    improvement_value_current_year INTEGER,
    total_market_value_current_year INTEGER,
    taxable_value_current_year INTEGER,
    range_code VARCHAR(10),
    township VARCHAR(10),
    section_code VARCHAR(20),
    quarter_section VARCHAR(20),
    subdivision_name VARCHAR(50),
    located_on_parcel VARCHAR(10),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tax_account_account_type ON tax_account(account_type);
CREATE INDEX idx_tax_account_property_type ON tax_account(property_type);
CREATE INDEX idx_tax_account_use_code ON tax_account(use_code);

-- ============================================================================
-- APPRAISAL ACCOUNT TABLE
-- Detailed property appraisal data with characteristics and valuations
-- ============================================================================

CREATE TABLE appraisal_account (
    parcel_number VARCHAR(10) PRIMARY KEY,
    appraisal_account_type VARCHAR(15) NOT NULL,
    business_name VARCHAR(50),
    value_area_id VARCHAR(10),
    land_economic_area VARCHAR(30),
    buildings INTEGER,
    group_account_number VARCHAR(30),
    land_gross_acres DECIMAL(15,4),
    land_net_acres DECIMAL(15,4),
    land_gross_square_feet DECIMAL(15,4),
    land_net_square_feet DECIMAL(15,4),
    land_gross_front_feet DECIMAL(15,4),
    land_width INTEGER,
    land_depth INTEGER,
    submerged_area_square_feet INTEGER,
    appraisal_date DATE,
    waterfront_type VARCHAR(30),
    view_quality VARCHAR(30),
    utility_electric VARCHAR(30),
    utility_sewer VARCHAR(30),
    utility_water VARCHAR(30),
    street_type VARCHAR(30),
    latitude DECIMAL(10,5),
    longitude DECIMAL(10,5),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parcel_number) REFERENCES tax_account(parcel_number) ON DELETE CASCADE
);

CREATE INDEX idx_appraisal_account_type ON appraisal_account(appraisal_account_type);
CREATE INDEX idx_appraisal_account_gps ON appraisal_account(latitude, longitude);
CREATE INDEX idx_appraisal_account_waterfront ON appraisal_account(waterfront_type);

-- ============================================================================
-- IMPROVEMENT TABLE
-- Detailed building improvement data linked to appraisal accounts
-- ============================================================================

CREATE TABLE improvement (
    parcel_number VARCHAR(10) NOT NULL,
    building_id VARCHAR(5) NOT NULL,
    property_type VARCHAR(15),
    neighborhood VARCHAR(10),
    neighborhood_extension VARCHAR(10),
    square_feet INTEGER,
    net_square_feet INTEGER,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (parcel_number, building_id),
    FOREIGN KEY (parcel_number) REFERENCES appraisal_account(parcel_number) ON DELETE CASCADE
);

CREATE INDEX idx_improvement_property_type ON improvement(property_type);
CREATE INDEX idx_improvement_neighborhood ON improvement(neighborhood);

-- ============================================================================
-- IMPROVEMENT BUILT-AS TABLE
-- Detailed specifications for building construction styles and features
-- ============================================================================

CREATE TABLE improvement_builtas (
    parcel_number VARCHAR(10) NOT NULL,
    building_id VARCHAR(5) NOT NULL,
    builtas_number INTEGER NOT NULL,
    builtas_id INTEGER,
    builtas_description VARCHAR(255),
    builtas_square_feet INTEGER,
    hvac INTEGER,
    hvac_description VARCHAR(30),
    exterior VARCHAR(25),
    interior VARCHAR(15),
    stories DECIMAL(13,2),
    story_height INTEGER,
    sprinkler_square_feet INTEGER,
    roof_cover VARCHAR(20),
    bedrooms INTEGER,
    bathrooms DECIMAL(7,2),
    units INTEGER,
    class_code VARCHAR(20),
    class_description VARCHAR(50),
    year_built INTEGER,
    year_remodeled INTEGER,
    adjusted_year_built INTEGER,
    physical_age INTEGER,
    builtas_length INTEGER,
    builtas_width INTEGER,
    mobile_home_model VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (parcel_number, building_id, builtas_number),
    FOREIGN KEY (parcel_number, building_id) REFERENCES improvement(parcel_number, building_id) ON DELETE CASCADE
);

CREATE INDEX idx_builtas_year_built ON improvement_builtas(year_built);
CREATE INDEX idx_builtas_property_type ON improvement_builtas(class_code);

-- ============================================================================
-- IMPROVEMENT DETAIL TABLE
-- Additional specific improvement characteristics and features
-- ============================================================================

CREATE TABLE improvement_detail (
    parcel_number VARCHAR(10) NOT NULL,
    building_id VARCHAR(5) NOT NULL,
    detail_type VARCHAR(10) NOT NULL,
    detail_description VARCHAR(50),
    units DECIMAL(15,4),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (parcel_number, building_id, detail_type),
    FOREIGN KEY (parcel_number, building_id) REFERENCES improvement(parcel_number, building_id) ON DELETE CASCADE
);

CREATE INDEX idx_improvement_detail_type ON improvement_detail(detail_type);

-- ============================================================================
-- LAND ATTRIBUTE TABLE
-- Land-specific attributes and characteristics affecting valuation
-- ============================================================================

CREATE TABLE land_attribute (
    parcel_number VARCHAR(10) NOT NULL,
    attribute VARCHAR(30) NOT NULL,
    attribute_description VARCHAR(30),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (parcel_number, attribute),
    FOREIGN KEY (parcel_number) REFERENCES appraisal_account(parcel_number) ON DELETE CASCADE
);

CREATE INDEX idx_land_attribute_type ON land_attribute(attribute);

-- ============================================================================
-- SALE TABLE
-- Historical property sales transaction data
-- ============================================================================

CREATE TABLE sale (
    etn VARCHAR(11) PRIMARY KEY,
    parcel_count INTEGER,
    parcel_number VARCHAR(10) NOT NULL,
    sale_date DATE NOT NULL,
    sale_price DECIMAL(15,2),
    deed_type VARCHAR(40),
    grantor VARCHAR(80),
    grantee VARCHAR(80),
    valid_invalid VARCHAR(7),
    confirmed_unconfirmed VARCHAR(11),
    exclude_reason VARCHAR(30),
    improved_vacant VARCHAR(8),
    appraisal_account_type VARCHAR(15),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parcel_number) REFERENCES tax_account(parcel_number) ON DELETE CASCADE
);

CREATE INDEX idx_sale_parcel_number ON sale(parcel_number);
CREATE INDEX idx_sale_date ON sale(sale_date);
CREATE INDEX idx_sale_price ON sale(sale_price);
CREATE INDEX idx_sale_valid_invalid ON sale(valid_invalid);

-- ============================================================================
-- SEG MERGE TABLE
-- Property segregation and merger transaction history
-- ============================================================================

CREATE TABLE seg_merge (
    segmerge_number VARCHAR(12) PRIMARY KEY,
    parent_child_indicator VARCHAR(1) NOT NULL,
    parcel_number VARCHAR(10) NOT NULL,
    continued_indicator VARCHAR(1),
    completed_date DATE,
    tax_year VARCHAR(4),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parcel_number) REFERENCES tax_account(parcel_number) ON DELETE CASCADE
);

CREATE INDEX idx_seg_merge_parcel ON seg_merge(parcel_number);
CREATE INDEX idx_seg_merge_parent_child ON seg_merge(parent_child_indicator);
CREATE INDEX idx_seg_merge_date ON seg_merge(completed_date);

-- ============================================================================
-- TAXPAYER TABLE
-- Property owner information (subject to privacy restrictions)
-- NOTE: RCW 42.56.070(9) may restrict the release of taxpayer names
-- and mailing addresses in certain circumstances
-- ============================================================================

CREATE TABLE taxpayer (
    parcel_number VARCHAR(10) PRIMARY KEY,
    taxpayer_name VARCHAR(150),
    mailing_address VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    phone_number VARCHAR(15),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parcel_number) REFERENCES tax_account(parcel_number) ON DELETE CASCADE
);

CREATE INDEX idx_taxpayer_name ON taxpayer(taxpayer_name);

-- ============================================================================
-- TAX DESCRIPTION TABLE
-- Detailed tax coding and descriptions for parcels
-- ============================================================================

CREATE TABLE tax_description (
    parcel_number VARCHAR(10) NOT NULL,
    line_number INTEGER NOT NULL,
    tax_description_line VARCHAR(200),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (parcel_number, line_number),
    FOREIGN KEY (parcel_number) REFERENCES tax_account(parcel_number) ON DELETE CASCADE
);

-- ============================================================================
-- MATERIALIZED VIEWS FOR COMMON QUERIES
-- ============================================================================

-- Property Overview (combines key data from multiple tables)
CREATE VIEW property_overview AS
SELECT
    ta.parcel_number,
    ta.property_type,
    ta.site_address,
    ta.use_description,
    aa.appraisal_account_type,
    aa.buildings,
    aa.land_net_acres,
    aa.land_net_square_feet,
    aa.latitude,
    aa.longitude,
    ta.land_value_current_year,
    ta.improvement_value_current_year,
    ta.total_market_value_current_year,
    ta.taxable_value_current_year,
    aa.appraisal_date
FROM tax_account ta
LEFT JOIN appraisal_account aa ON ta.parcel_number = aa.parcel_number;

-- Residential Properties with Improvements
CREATE VIEW residential_properties AS
SELECT
    im.parcel_number,
    im.building_id,
    im.property_type,
    im.neighborhood,
    im.square_feet,
    imb.year_built,
    imb.year_remodeled,
    imb.physical_age,
    imb.bedrooms,
    imb.bathrooms,
    imb.stories,
    ta.total_market_value_current_year,
    ta.taxable_value_current_year
FROM improvement im
LEFT JOIN improvement_builtas imb ON im.parcel_number = imb.parcel_number
    AND im.building_id = imb.building_id
LEFT JOIN tax_account ta ON im.parcel_number = ta.parcel_number
WHERE im.property_type = 'Residential'
    OR ta.property_type LIKE '%RES%';

-- Sales History with Property Details
CREATE VIEW sales_history AS
SELECT
    s.etn,
    s.parcel_number,
    s.sale_date,
    s.sale_price,
    s.deed_type,
    s.valid_invalid,
    ta.site_address,
    ta.property_type,
    aa.appraisal_account_type,
    aa.buildings,
    im.square_feet,
    imb.bedrooms,
    imb.bathrooms,
    imb.year_built
FROM sale s
LEFT JOIN tax_account ta ON s.parcel_number = ta.parcel_number
LEFT JOIN appraisal_account aa ON s.parcel_number = aa.parcel_number
LEFT JOIN improvement im ON s.parcel_number = im.parcel_number
LEFT JOIN improvement_builtas imb ON im.parcel_number = imb.parcel_number
    AND im.building_id = imb.building_id;

-- Property Valuation Summary
CREATE VIEW property_valuation AS
SELECT
    ta.parcel_number,
    ta.site_address,
    ta.tax_year_current,
    ta.land_value_current_year,
    ta.improvement_value_current_year,
    ta.total_market_value_current_year,
    ta.taxable_value_current_year,
    (ta.total_market_value_current_year - ta.taxable_value_current_year)
        AS exemption_amount,
    aa.land_net_square_feet,
    (CASE
        WHEN aa.land_net_square_feet > 0
        THEN ta.total_market_value_current_year / aa.land_net_square_feet
        ELSE NULL
    END) AS price_per_sqft
FROM tax_account ta
LEFT JOIN appraisal_account aa ON ta.parcel_number = aa.parcel_number;

-- ============================================================================
-- ANALYTICAL QUERIES / STORED PROCEDURES
-- ============================================================================

-- Get properties with recent sales and current valuations
-- SELECT * FROM sales_history
-- WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
-- AND valid_invalid = 'Valid'
-- ORDER BY sale_date DESC;

-- Get average price per square foot by neighborhood
-- SELECT
--     im.neighborhood,
--     COUNT(*) as property_count,
--     ROUND(AVG(pv.price_per_sqft), 2) as avg_price_per_sqft,
--     ROUND(AVG(pv.total_market_value_current_year), 0) as avg_property_value
-- FROM property_valuation pv
-- LEFT JOIN improvement im ON pv.parcel_number = im.parcel_number
-- GROUP BY im.neighborhood
-- ORDER BY avg_price_per_sqft DESC;

-- Get properties with highest appreciation
-- WITH sale_history_ranked AS (
--     SELECT
--         parcel_number,
--         sale_date,
--         sale_price,
--         ROW_NUMBER() OVER (PARTITION BY parcel_number ORDER BY sale_date DESC) as rn
--     FROM sale
--     WHERE valid_invalid = 'Valid'
-- )
-- SELECT
--     ta.parcel_number,
--     ta.site_address,
--     shp.sale_date as previous_sale_date,
--     shp.sale_price as previous_sale_price,
--     pv.sale_date as recent_sale_date,
--     pv.sale_price as recent_sale_price,
--     (pv.sale_price - shp.sale_price) as appreciation_amount,
--     ROUND(((pv.sale_price - shp.sale_price) / shp.sale_price * 100), 2) as appreciation_percent
-- FROM sale_history_ranked shp
-- LEFT JOIN sales_history pv ON shp.parcel_number = pv.parcel_number
--     AND shp.rn = 1;

-- ============================================================================
-- CONSTRAINTS AND INDEXES
-- ============================================================================

-- Ensure valid data entry
ALTER TABLE tax_account
    ADD CONSTRAINT chk_tax_account_account_type
    CHECK (account_type IN ('REAL', 'STRUC', 'PERS', 'MOBIL'));

ALTER TABLE appraisal_account
    ADD CONSTRAINT chk_appraisal_account_buildings
    CHECK (buildings >= 0);

ALTER TABLE improvement
    ADD CONSTRAINT chk_improvement_square_feet
    CHECK (square_feet >= 0 AND net_square_feet >= 0);

ALTER TABLE improvement_builtas
    ADD CONSTRAINT chk_builtas_square_feet
    CHECK (builtas_square_feet >= 0);

ALTER TABLE appraisal_account
    ADD CONSTRAINT chk_appraisal_coordinates
    CHECK (latitude BETWEEN -90 AND 90 AND longitude BETWEEN -180 AND 180);

ALTER TABLE sale
    ADD CONSTRAINT chk_sale_price
    CHECK (sale_price >= 0);

ALTER TABLE sale
    ADD CONSTRAINT chk_sale_valid_invalid
    CHECK (valid_invalid IN ('Valid', 'Invalid', ''));

-- ============================================================================
-- PERFORMANCE INDEXES
-- ============================================================================

CREATE INDEX idx_property_current_value ON tax_account(total_market_value_current_year DESC);
CREATE INDEX idx_property_prior_value ON tax_account(total_market_value_prior_year DESC);
CREATE INDEX idx_improvement_square_feet ON improvement(square_feet DESC);
CREATE INDEX idx_sale_price ON sale(sale_price DESC);
CREATE INDEX idx_sale_validity ON sale(valid_invalid, sale_date DESC);
CREATE INDEX idx_appraisal_account_buildings ON appraisal_account(buildings);
CREATE INDEX idx_improvement_builtas_year ON improvement_builtas(year_built DESC);
CREATE INDEX idx_parcel_geographic ON appraisal_account(latitude, longitude);

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
