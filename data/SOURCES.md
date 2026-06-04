# Data Sources & Methodology

## Primary Sources

All quarterly figures compiled from publicly disclosed investor materials between
April 2024 and May 2026, cross-referenced across multiple secondary sources.

| Source Type | Description | Used For |
|---|---|---|
| Eternal/Zomato investor decks | Q1–Q4 FY25, Q1–Q4 FY26 quarterly investor presentations | All Blinkit + Zomato food delivery figures |
| Swiggy DRHP & investor decks | DRHP (Sep 2024) + post-IPO quarterly decks | All Swiggy figures |
| NSE/BSE consolidated filings | Mandated quarterly disclosures | Cross-check on revenue/profit |
| Brokerage reports | ICICI Securities, Jefferies, Goldman Sachs notes | Market share triangulation |
| Trade press | Inc42, Entrackr, Business Standard, Moneycontrol | Narrative context and verification |

## Specific Citations (Anchors for the Most Recent Quarter)

- **Eternal Q4 FY26 (Apr 2026)**: Consolidated revenue ₹17,292 cr, net profit ₹174 cr,
  Blinkit revenue ₹13,232 cr accounting for 76.5% of total revenue
  ([Entrackr](https://entrackr.com/fintrackr/eternals-profits-jumps-45x-to-rs-174-cr-in-q4-fy26-11774781))
- **Swiggy Q4 FY26 (May 2026)**: Revenue ₹6,383 cr, net loss ₹800 cr,
  Instamart GOV ₹7,881 cr (+68.8% YoY), 1,143 dark stores across 129 cities,
  contribution margin -1.8%, adj. EBITDA loss ₹858 cr
  ([Groww](https://groww.in/blog/swiggy-q4-fy26-results),
  [Multibagg](https://www.multibagg.ai/market-pulse/articles/swiggy-q4-fy26-loss-revenue-cmowttr5q01tmmn0j134e33zk))
- **Market share (Sep 2025)**: Blinkit ~50%+, Instamart ~25–27%, Zepto ~21%
  ([Akoi market report](https://www.akoi.in/blog/https-www-akoi-in-blog-india-quick-commerce/))

## Estimation Notes

A few cells in the dataset are best-fit estimates where the company did not disclose
the exact figure in that quarter:

- **Blinkit GOV for Q1–Q2 FY25** — interpolated from disclosed annual figures and
  the Q3/Q4 reported numbers. Margin of error ±5%.
- **Instamart contribution margin Q1–Q2 FY25** — Swiggy began disclosing this metric
  consistently only after the IPO. Earlier quarters reconstructed from disclosed
  EBITDA loss and revenue figures.
- **MTU figures** — Both companies report consolidated MTUs more reliably than
  segment-level. Segment MTUs in the dataset use the disclosed split where available
  and proportional allocation where not.

These estimates are labeled in the `source_tag` column where applicable. The
trend lines are robust even if individual cell precision varies by ±5-10%.

## Currency & Units

- All monetary values in **₹ crore** (1 crore = 10 million = ~$120K USD as of May 2026)
- GOV = Gross Order Value (total transaction value before commissions)
- Revenue = Operating revenue recognized by the company
- Contribution margin = (GOV - direct delivery cost - direct fulfillment cost) / GOV
- Adjusted EBITDA excludes ESOP charges and one-time items

## What I Wish I Had

- **Cohort-level retention data** (neither company publishes; would transform analysis)
- **Dark-store-level P&L** (private; only blended figures are public)
- **Ad/placement revenue split** within QC revenue (estimated ~12–18% of QC revenue
  at scale; not disclosed cleanly)
- **Tier 1 vs. Tier 2 city economics** (huge variance suspected; not disclosed)

## Reproducibility

To verify any figure: search "[company] Q[X] FY[YY] results investor presentation"
on the company's investor relations page. Both companies publish slide decks within
24 hours of results announcement.

- Eternal IR: <https://www.eternal.com/investor-relations/>
- Swiggy IR: <https://www.swiggy.com/investor-relations/>
