-- =============================================================================
-- Zomato vs. Swiggy: Two Bets, One Industry
-- =============================================================================
-- Engine: DuckDB (or any modern SQL engine with CTE + window function support)
-- To run: install duckdb (`pip install duckdb` or download CLI), then:
--   duckdb -c ".read sql/analysis.sql"
-- DuckDB reads CSV files directly with read_csv_auto() — no ETL needed.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Setup: Create views over the raw CSVs
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW qc AS
SELECT * FROM read_csv_auto('data/quick_commerce_quarterly.csv');

CREATE OR REPLACE VIEW fd AS
SELECT * FROM read_csv_auto('data/food_delivery_quarterly.csv');


-- =============================================================================
-- LAYER 1: FOOD DELIVERY (Zomato vs Swiggy app)
-- =============================================================================

-- Q1: Food delivery state of play — Q4 FY26
SELECT
    company,
    gov_inr_cr      AS gov_cr,
    revenue_inr_cr  AS revenue_cr,
    adj_ebitda_inr_cr AS ebitda_cr,
    adj_ebitda_margin_pct_of_gov AS ebitda_margin_pct,
    mtu_millions,
    aov_inr
FROM fd
WHERE quarter = 'Q4FY26'
ORDER BY company;


-- Q2: Food delivery — has the margin gap closed?
-- This is the headline of Layer 1.
SELECT
    quarter,
    MAX(CASE WHEN company = 'Eternal' THEN adj_ebitda_margin_pct_of_gov END) AS zomato_margin,
    MAX(CASE WHEN company = 'Swiggy'  THEN adj_ebitda_margin_pct_of_gov END) AS swiggy_margin,
    ROUND(MAX(CASE WHEN company = 'Eternal' THEN adj_ebitda_margin_pct_of_gov END)
        - MAX(CASE WHEN company = 'Swiggy' THEN adj_ebitda_margin_pct_of_gov END), 2) AS gap_pp
FROM fd
GROUP BY quarter, quarter_end_date
ORDER BY quarter_end_date;


-- Q3: Food delivery GOV ratio — is one pulling ahead?
SELECT
    quarter,
    MAX(CASE WHEN company = 'Eternal' THEN gov_inr_cr END) AS zomato_gov,
    MAX(CASE WHEN company = 'Swiggy'  THEN gov_inr_cr END) AS swiggy_gov,
    ROUND(MAX(CASE WHEN company = 'Eternal' THEN gov_inr_cr END) * 1.0
        / MAX(CASE WHEN company = 'Swiggy' THEN gov_inr_cr END), 2) AS zomato_to_swiggy_ratio
FROM fd
GROUP BY quarter, quarter_end_date
ORDER BY quarter_end_date;


-- Q4: YoY growth comparison
SELECT
    company,
    quarter,
    gov_inr_cr,
    ROUND(100.0 * (gov_inr_cr - LAG(gov_inr_cr, 4)
        OVER (PARTITION BY company ORDER BY quarter_end_date))
        / NULLIF(LAG(gov_inr_cr, 4)
        OVER (PARTITION BY company ORDER BY quarter_end_date), 0), 1) AS yoy_growth_pct
FROM fd
ORDER BY company, quarter_end_date;


-- =============================================================================
-- LAYER 2: QUICK COMMERCE (Blinkit vs Instamart)
-- =============================================================================

-- Q5: Quick commerce state of play — Q4 FY26
SELECT
    company,
    segment,
    gov_inr_cr             AS gov_cr,
    revenue_inr_cr         AS revenue_cr,
    adj_ebitda_inr_cr      AS ebitda_cr,
    contribution_margin_pct AS cm_pct,
    dark_stores,
    cities,
    aov_inr,
    mtu_millions
FROM qc
WHERE quarter = 'Q4FY26'
ORDER BY company;


-- Q6: Contribution margin convergence — the QC headline finding
SELECT
    quarter,
    MAX(CASE WHEN company = 'Eternal' THEN contribution_margin_pct END) AS blinkit_cm,
    MAX(CASE WHEN company = 'Swiggy'  THEN contribution_margin_pct END) AS instamart_cm,
    ROUND(MAX(CASE WHEN company = 'Eternal' THEN contribution_margin_pct END)
        - MAX(CASE WHEN company = 'Swiggy' THEN contribution_margin_pct END), 2) AS gap_pp
FROM qc
GROUP BY quarter, quarter_end_date
ORDER BY quarter_end_date;


-- Q7: Dark store productivity — GOV per store per quarter
SELECT
    company,
    quarter,
    dark_stores,
    gov_inr_cr,
    ROUND(gov_inr_cr * 1.0 / dark_stores, 2) AS gov_per_store_cr
FROM qc
ORDER BY company, quarter_end_date;


-- =============================================================================
-- THE SYNTHESIS: How does each parent allocate B2C GOV?
-- =============================================================================

-- Q8: Total B2C GOV (food + QC) and the mix
-- This is the chart that explains everything: where did the divergence go?
WITH combined AS (
    SELECT
        f.company,
        f.quarter,
        f.quarter_end_date,
        f.gov_inr_cr AS food_gov,
        q.gov_inr_cr AS qc_gov,
        f.gov_inr_cr + q.gov_inr_cr AS total_b2c_gov
    FROM fd f
    JOIN qc q ON f.company = q.company AND f.quarter = q.quarter
)
SELECT
    company,
    quarter,
    food_gov,
    qc_gov,
    total_b2c_gov,
    ROUND(qc_gov * 100.0 / total_b2c_gov, 1) AS qc_share_pct
FROM combined
ORDER BY company, quarter_end_date;


-- Q9: When did QC pass food delivery at each company?
-- Returns the first quarter where qc_gov > food_gov
WITH combined AS (
    SELECT
        f.company,
        f.quarter,
        f.quarter_end_date,
        f.gov_inr_cr AS food_gov,
        q.gov_inr_cr AS qc_gov
    FROM fd f
    JOIN qc q ON f.company = q.company AND f.quarter = q.quarter
)
SELECT
    company,
    MIN(CASE WHEN qc_gov > food_gov THEN quarter END) AS quarter_qc_overtook_food,
    MIN(CASE WHEN qc_gov > food_gov THEN quarter_end_date END) AS date_qc_overtook_food
FROM combined
GROUP BY company;
