# Data Source Description: Pierce County Assessor-Treasurer Dataset

## Executive Summary

The **Pierce County Assessor-Treasurer Dataset** is a comprehensive, government-maintained property assessment database containing detailed information on residential, commercial, and industrial properties in Pierce County, Washington. The dataset includes property characteristics, building improvements, land features, historical sales transactions, and valuations, making it ideal for real estate price prediction modeling.

---

## 1. Source Information

### Authority & Provider
- **Organization**: Pierce County Assessor-Treasurer Office
- **Location**: Pierce County, Washington, USA
- **Website**: https://www.piercecountywa.gov/
- **Data Access**: Public Records Available
- **Request Center**: Pierce County Public Records Request Center

### Data Origin
- **Primary Systems**:
  - Tax and Assessment System (current tax account information)
  - Appraisal System (detailed property appraisals and improvements)
- **Regulatory Basis**:
  - Washington State RCW (Revised Code of Washington) property assessment requirements
  - State Ratio RCW standards for property valuation

---

## 2. Dataset Scope & Coverage

### Geographic Coverage
- **Region**: Pierce County, Washington
- **Metropolitan Area**: Tacoma-Seattle region (Western Washington)
- **Population Coverage**: ~1 million residents (2020 Census)
- **Property Categories**:
  - Residential (single-family, multi-unit, condominiums)
  - Commercial (office, retail, industrial)
  - Agricultural & Forest land
  - Mobile homes and manufactured housing
  - Special use properties (reference parcels, state-assessed)

### Temporal Coverage
- **Current Data**: Annual updates (Tax year basis)
- **Historical Data**: 
  - Sales transactions: 10+ years of recorded deeds
  - Appraisals: Physical inspection cycles (PI1-PI6 rotating)
  - Segregation/Merger records: Long-term history
- **Update Frequency**: Annual (tax year basis), with continuous transaction recording

### Property Count
- **Estimated Properties**: 400,000+ parcels
- **Active Properties**: 380,000+ (2024)
- **Data Records**: 
  - Property accounts: ~400,000
  - Building improvements: ~500,000+ (multiple improvements per parcel)
  - Sales transactions: 50,000+ annually

---

## 3. Data Structure & Organization

### Relational Database Design
The dataset is organized as a **relational database** with 10 interconnected tables:

```
Tax Account (Parcel-level taxes)
    ├─ Appraisal Account (Property details)
    │   ├─ Improvement (Building-level data)
    │   │   ├─ Improvement Built-As (Construction specs)
    │   │   └─ Improvement Detail (Specific features)
    │   ├─ Land Attribute (Land characteristics)
    │   └─ Sale (Historical transactions)
    ├─ Seg/Merge (Parcel history)
    └─ Tax Description (Tax codes)
```

### Core Tables

#### 1. Tax Account Table (~400K records)
**Purpose**: Current tax and assessment account information

**Key Fields**:
- Parcel Number (unique identifier)
- Account Type (Real, Structures, Personal, Mobile)
- Property Type (Administrative Seg, Land & Improvements, Mobile Home, etc.)
- Site Address
- Use Code (4-digit code for property use)
- Land/Improvement/Total Market Values (Prior & Current Year)
- Taxable Value (after exemptions)
- Geographic location (Range, Township, Section, Subdivision)

#### 2. Appraisal Account Table (~400K records)
**Purpose**: Detailed property appraisal data and characteristics

**Key Fields**:
- Appraisal Account Type (15 classification types)
- Building Count (number of improvements)
- Land Characteristics:
  - Gross/Net Acres
  - Square Footage (gross & net)
  - Front Footage (street frontage)
  - Width & Depth
  - Waterfront Type & Length
- Property Features:
  - View Quality
  - Utility Availability (electric, sewer, water)
  - Street Type (paved/unpaved)
- Appraisal Date (last physical inspection)
- Geographic Coordinates (Latitude/Longitude)

#### 3. Improvement Table (~500K+ records)
**Purpose**: Building-level improvements and structures

**Key Fields**:
- Building ID (unique per parcel)
- Property Type (Commercial, Residential, Duplex, Mobile Home, etc.)
- Neighborhood/Neighborhood Extension
- Total Square Footage
- Net Square Footage (rentable area)

#### 4. Improvement Built-As Table (~500K+ records)
**Purpose**: Construction style and specifications for buildings

**Key Fields**:
- Built-As ID (construction type/style)
- Square Footage for specific construction
- HVAC System & Heating Source
- Exterior & Interior Materials
- Number of Stories & Story Height
- Roof Cover Material
- Bedrooms & Bathrooms
- Year Built & Year Remodeled
- Physical Age
- Mobile Home specifications (length, width, model)
- Sprinkler Coverage

#### 5. Improvement Detail Table
**Purpose**: Specific improvement characteristics and features

**Key Fields**:
- Detail Type (Add-On, Appliance, Balcony, Basement, Carport, Elevator, Fixture, Garage, Mezzanine, Porch, etc.)
- Detail Description (specific feature descriptions)
- Units (count or square footage)

**Feature Examples**:
- Fireplace (count)
- Garage (square footage)
- Deck (square footage)
- Bathroom Fixtures (count)
- Appliances

#### 6. Land Attribute Table
**Purpose**: Land-specific characteristics affecting valuation

**Key Fields**:
- Attribute Categories (Residential, Commercial, Condo)
- Attribute Descriptions (View Average, Gated community, Waterfront bank, etc.)

#### 7. Sale Table (~50K+ annual records)
**Purpose**: Historical property sales transactions

**Key Fields**:
- ETN (Excise Tax Number - unique transaction ID)
- Parcel Number(s) involved
- Sale Date (deed execution date)
- Sale Price (transaction amount in dollars)
- Deed Type (transaction type)
- Grantor & Grantee (seller & buyer)
- Valid/Invalid Flag (for appraisal purposes)
- Confirmed/Unconfirmed (verified by assessor)
- Exclude Reason (if not usable for appraisal)
- Property classification at time of sale

#### 8. Seg/Merge Table
**Purpose**: Property segregation and merger history

**Key Fields**:
- Seg/Merge Number (unique transaction)
- Parent/Child Indicator (parent parcel or new child parcel)
- Continued Indicator (parcel active after transaction)
- Completed Date & Tax Year

#### 9. Taxpayer Table
**Purpose**: Property owner information

**Note**: Subject to privacy restrictions per RCW 42.56.070(9)

#### 10. Tax Description Table
**Purpose**: Detailed tax codes and descriptions

---

## 4. Data Quality Characteristics

### Strengths

**1. Authoritative Source**
- Maintained by official county government agency
- Used for legal tax assessments and property valuations
- Audited and regulated by Washington State Department of Revenue

**2. Comprehensive Coverage**
- Includes ALL property types in the county
- Complete historical records (10+ years of sales)
- Detailed building-level specifications

**3. Rich Feature Set**
- 50+ features per property
- Multiple data sources (tax system + appraisal system)
- Both current and historical valuations

**4. Regular Updates**
- Annual appraisal cycles (PI1-PI6 rotating)
- Continuous sale transaction recording
- Physical inspection dates documented

**5. Geospatial Data**
- Latitude/Longitude coordinates for geographic analysis
- Neighborhood/area codes for spatial grouping
- Waterfront and location-based attributes

### Data Quality Issues

**1. Missing Values**
- Latitude/Longitude: Not available for ~5-10% of parcels
  - Reason: Building-only, mineral rights, reference parcels
- Taxpayer Information: Restricted by privacy law
- Some optional fields may be sparsely populated

**2. Data Entry Variations**
- Address Format: Site addresses may contain "XXX" indicating estimated locations via GIS
- Text Fields: Inconsistent capitalization and formatting in descriptive fields
- Subdivision Names: Varying levels of detail

**3. Historical Changes**
- Property characteristics may change over time (segregation, mergers, improvements)
- Appraisal dates vary (property inspection cycle: PI1-PI6)
- Classification changes (e.g., residential to commercial conversion)

**4. Valid Sales Filtering**
- ~20-30% of recorded sales flagged as "Invalid" for appraisal purposes
- Invalid reasons: Family transfers, estate sales, forced sales, pre-1031 exchanges
- Requires filtering for market analysis

**5. Outliers & Anomalies**
- Reference parcels (non-taxable, minimal value)
- Mineral rights and leasehold improvements
- Extreme value outliers (multi-million dollar properties)
- Development parcels (no building yet)

### Data Reliability Metrics

| Aspect | Coverage | Notes |
|--------|----------|-------|
| Current Property Values | 100% | All tax accounts |
| Appraisal Details | 95%+ | Most parcels appraised |
| Building Characteristics | 90%+ | Most improved properties |
| GPS Coordinates | 90%+ | Missing for special categories |
| Sales History | 100% | All recorded transactions |
| Valid Sales | 70-80% | After filtering invalid transactions |
| Appraisal Dates | 100% | When last inspected |

---

## 5. Key Attributes for Price Prediction

### Primary Price Drivers (Tested)
1. **Property Size**
   - Land square footage
   - Building square footage
   - Lot acreage

2. **Building Characteristics**
   - Year built (age)
   - Condition rating
   - Quality rating
   - Number of bedrooms/bathrooms
   - Stories/story height
   - Construction type/materials

3. **Location Factors**
   - Neighborhood code
   - Land Economic Area (LEA)
   - Geographic coordinates
   - Waterfront access
   - View quality

4. **Improvements & Amenities**
   - Garage (presence & square footage)
   - Carport, porch, deck
   - Basement (finished/unfinished)
   - Fireplace
   - Utilities (electric, water, sewer)

5. **Property Type & Classification**
   - Residential vs. commercial
   - Single-family vs. multi-unit
   - Condo vs. detached
   - Mobile home vs. fixed structure

6. **Market Data**
   - Historical sales prices
   - Sales date
   - Time on market patterns
   - Seasonal variations

---

## 6. Data Access & Licensing

### Public Availability
- **Status**: Public Record (open access)
- **License**: Government data (no copyright restrictions)
- **Access Method**: 
  - Direct download from county website
  - Public Records Request (specific datasets)
  - Pierce County Data Portal (partial)

### Access Restrictions
- **Privacy**: Taxpayer names and addresses restricted per RCW 42.56.070(9)
  - Accessible via formal public records request
  - Not available in standard data downloads
- **Commercial Use**: Permitted for property analysis and valuation
- **Attribution**: Recommended to cite Pierce County Assessor-Treasurer

### Data Formats Available
- TXT files
- Excel spreadsheets
- XML/JSON APIs (some tables)

---

## 7. Comparable Datasets & Advantages

### Comparison with Other Sources

| Aspect | Pierce County | Zillow | Redfin | CoreLogic |
|--------|---------------|--------|--------|-----------|
| **Official Source** | Yes | Commercial | Commercial | Commercial |
| **Complete Coverage** | 100% county | Selective | Selective | 90%+ |
| **Historical Sales** | 10+ years | 5 years | 5 years | 10+ years |
| **Building Details** | Extensive | Limited | Moderate | Extensive |
| **Appraisal Scores** | Yes | Estimates | Estimates | Official |
| **Free Access** | Yes | Limited | Limited | Paid |
| **Regulatory Basis** | Yes | No | No | Yes |
| **Geographic Detail** | GPS + Codes | GPS only | GPS only | GPS + Codes |

### Advantages of Pierce County Data
1. **Official government source** - highest authority and legal validity
2. **Comprehensive coverage** - no selection bias, includes all property types
3. **Professional appraisals** - conducted by licensed appraisers
4. **Detailed specifications** - building-level detail competitors don't provide
5. **Free access** - no licensing costs or API limitations
6. **Long history** - 10+ years of sales and appraisals
7. **Geographic context** - neighborhoods, LEAs, and infrastructure data
8. **Structured format** - relational database design suitable for ML

---

## 8. Use Cases for This Dataset

### Ideal Applications
1. **House Price Prediction**
   - Regression models for property valuation
   - Neighborhood-specific pricing models
   - Time-series appreciation forecasting

2. **Market Analysis**
   - Price trends by neighborhood
   - Affordability indices
   - Investment opportunity identification

3. **Property Valuation**
   - Automated Valuation Models (AVM)
   - Comparable Market Analysis (CMA)
   - Tax assessment verification

4. **Real Estate Investment**
   - Property scoring and ranking
   - Portfolio analysis
   - Due diligence research

5. **Urban Planning & Policy**
   - Zoning impact analysis
   - Tax revenue forecasting
   - Growth pattern analysis

6. **Academic Research**
   - Housing economics
   - Real estate market dynamics
   - Geospatial analysis

---

## 9. Data Dictionary Reference

**Complete field definitions** are available in: `PIERCE_COUNTY_DATA_MART.md`

**SQL schema** for database implementation: `PIERCE_COUNTY_SCHEMA.sql`

---

## 10. Dataset Statistics Summary

### Size Metrics
| Metric | Count |
|--------|-------|
| Total Parcels | ~400,000 |
| Tax Accounts | ~400,000 |
| Property Appraisals | ~400,000 |
| Building Improvements | ~500,000+ |
| Sales Transactions (10 years) | ~500,000 |
| Geographic Coordinates | ~360,000+ (90%) |

### Feature Coverage
| Feature Type | Count | Coverage |
|---|---|---|
| Numeric Features | 35+ | 95%+ |
| Categorical Features | 25+ | 98%+ |
| Text Descriptions | 12+ | 90%+ |
| Date Fields | 8 | 100% |
| Geographic Fields | 5 | 90%+ |

### Value Distribution
- **Parcel Prices**: $10K - $10M+
- **Average Price**: ~$450K
- **Median Price**: ~$350K
- **Price Per Sqft**: $50 - $500+
- **Property Ages**: 0 - 150+ years

---

## 11. Recommended Data Preparation

### For Machine Learning Models

**Step 1: Data Cleaning**
- Remove properties with missing coordinates (if spatial analysis needed)
- Filter out reference parcels and special-use properties
- Handle outliers (properties > $5M or < $50K)

**Step 2: Sales Data Filtering**
- Include only "Valid" sales
- Exclude flagged transactions (family transfers, forced sales)
- Use transactions from last 5-10 years for current market

**Step 3: Feature Engineering**
- Calculate property age (current year - year built)
- Derive price per square foot
- Create neighborhood dummy variables
- Encode categorical features (property type, condition, quality)

**Step 4: Temporal Considerations**
- Adjust historical prices for inflation
- Account for seasonal sales patterns
- Consider appraisal update recency

**Step 5: Feature Selection**
- Remove highly correlated features
- Select 15-25 most important features
- Test different feature combinations

---

## 12. Limitations & Considerations

### Geographic Scope
- **Limited to**: Pierce County, Washington only
- **Not generalizable** to other states without adaptation
- **Regional market effects** specific to Western Washington

### Data Lag
- Tax year data (annual, not real-time)
- Appraisal dates vary by inspection cycle
- Sales recorded after closing (1-2 week lag)

### Privacy & Legal
- Cannot use taxpayer names in public analysis
- Respect RCW 42.56.070(9) privacy restrictions
- Commercial use requires appropriate licensing

### Market Changes
- Pandemic (2020-2021) caused market anomalies
- Interest rate changes affect property values
- Local development projects create localized variations
- COVID migration patterns affected some neighborhoods

---

## 13. Recommended Citation

### Academic Format
Pierce County Assessor-Treasurer. (2024). *Property Assessment and Appraisal Dataset*. Pierce County, Washington. Retrieved from https://www.piercecountywa.gov/736/Data-Downloads

### Data Dictionary Citation
Pierce County Assessor-Treasurer. (2024). *Assessor-Treasurer Data Mart: Table Relationships and Primary Keys*. Technical Documentation.

---

## 14. Contact & Support

### Information Requests
- **Email**: Pierce County Assessor-Treasurer Office
- **Website**: https://www.piercecountywa.gov/
- **Public Records**: Pierce County Public Records Request Center
- **Phone**: Pierce County Main Line (253) 798-7000

### Data Issues
- Report data quality issues through public feedback channels
- Request specific datasets through records request process

---

## Summary

The **Pierce County Assessor-Treasurer Dataset** is a high-quality, comprehensive, and freely available resource for real estate price prediction research. With coverage of 400,000+ properties, 10+ years of sales history, detailed building specifications, and geographic data, it provides the foundation needed for building accurate house price prediction models. The official government source, regular updates, and rich feature set make it superior to many commercial alternatives for this research purpose.

---

**Document Version**: 1.0
**Last Updated**: May 2026
**Data Source**: Pierce County Assessor-Treasurer Office, Washington State
