# JCars Logistics - Power BI Business Intelligence Solution

From raw, messy sales data to an interactive Power BI solution for management decision-making.

---

## 1. Project Objective

JCars Logistics imports, sells, and delivers vehicles to customers across regions in Kenya. This project transforms a raw, uncleaned flat dataset of sales and operational records into a reliable, interactive Power BI solution that helps management understand:

- Sales and revenue performance
- Costs and profitability
- Vehicle, branch, and sales representative performance
- Sales channels and lead sources
- Payment, delivery, and logistics performance
- Returns, cancellations, and customer experience
- Performance trends over time
- Unusual transactions or business areas needing investigation

## 2. Dataset & Grain

- **Source:** a single raw flat file, 32 columns, 277 rows (276 usable order records after cleanup)
- **Grain:** one row = one vehicle sales order (an `Order Id`)
- The dataset blends four categories of information on each row: order/transaction details, customer details, vehicle details, and location/branch details - later separated into a star schema (see Section 6)

## 3. Data Quality Audit - Key Issues Identified

A full audit uncovered well over the required 10 significant issues. Highlights:

| # | Issue | How It Was Handled |
|---|---|---|
| 1 | `Order Id` used inconsistent prefixes (LC, LCL-, ORD, etc.), some blank/`N/A`, and several duplicated IDs across unrelated rows | Rebuilt entirely via an incremental index starting at 1000, prefixed `ORD-`; result: 276 unique, distinct order IDs |
| 2 | `Order Date` / `Delivery Date` mixed locales, Excel serial numbers, invalid dates (`2026-13-04`, `31/02/2026`), text like `"not sure"`, and error strings (`#DATE!`) | Custom M function: nullify junk markers → convert serial numbers → try-parse across multiple date formats/cultures → fallback to null for anything unparseable |
| 3 | `Customer Name` had inconsistent casing, empty strings, and `N/A` values | Proper-cased; blanks/`N/A` set to null |
| 4 | `Customer Type` had many spelling/case variants (`corp`, `CORP`, `CORPORATE`) | Standardized into a fixed category set (Government, Car Dealer, NGO/Non-Profit, Corporate, Individual, Company, Unknown); `Retail` mapped to `Individual` |
| 5 | `Customer Age` contained text, `0`, negative values, and suspicious outliers (`121` × 3 rows, `-5` × 3 rows) | Converted to numeric; implausible/impossible ages (0, negative, 121) treated as invalid and nullified rather than guessed |
| 6 | `Region`/`County`/`City` had misspellings, abbreviations, and inconsistent casing (`nrb`, `westen`, short county names) | Standardized against actual Kenyan regions/counties; some values inferred using cross-column evidence (e.g., `Mks` → Machakos, confirmed by the adjacent city "Athi River") |
| 7 | `Branch` mixed yards, HQs, city names, and abbreviations (64 raw variants) | Consolidated to 8 distinct branches after cross-checking Sales Rep assignments to confirm yards/branches/HQs referred to the same physical location |
| 8 | `Sales Rep` names had case issues, a recurring "1 instead of I" typo (e.g., `At1eno`), double-spaced names, and 10 single-name entries that duplicated existing two-name reps | Standardized casing/spelling, collapsed duplicate names, and matched single-name entries back to their two-name counterparts - reduced to 10 distinct reps |
| 9 | Five monetary columns (Unit Selling Price, Unit Cost, Discount, Delivery Fee, Logistics Cost) and Revenue Recorded arrived as text, mixing currencies (KES, USD, EUR, ZAR), symbols (`Ksh`, `$`, `R`), and magnitude suffixes (`M`, `K`) | Currency detected and stripped, magnitude multipliers applied, non-KES values converted to KES using fixed exchange rates (see Section 4) |
| 10 | `Discount` values exceeded 100% in several rows (e.g., `1.2` → 120%) | Treated as unrealistic for a standard discount field; nullified rather than guessed at intended meaning, to avoid silently injecting incorrect values |
| 11 | `Customer Rating` and `Review Count` contained out-of-range values (ratings outside 1–5, negative review counts), word-numbers, and placeholder text | Bounded to valid ranges (1–5 for ratings, ≥0 for review counts); invalid values nullified |
| 12 | `Vehicle Year` had spelled-out years, typos (`202A`), and implausible values (`1899`, `2032`) | Corrected where strong cross-column evidence existed (e.g., an Isuzu N-Series year inferred from its known production years); nullified where no reliable evidence existed rather than guessing |

## 4. Currency Standardization

The dataset mixed KES, USD, EUR, and ZAR values across monetary columns, identified by prefixes/symbols (`Ksh`, `KES`, `$`, `USD`, `€`, `EUR`, `R`, `ZAR`) and by magnitude suffixes (`K`, `M`).

**Rule applied:** any monetary value with no explicit currency indicator (including ambiguous symbols like `?`) was assumed to be **KES**, per the assessment brief. All other currencies were converted to KES using a single, consistent set of exchange rates for the entire project:

| Currency | Rate to KES |
|---|---|
| USD | 129.50 |
| EUR | 135.50 |
| ZAR | 7.10 |

## 5. Data Cleaning & Preparation (Power Query)

All transformations were built in Power Query M, using dedicated custom functions per column (dates, names, categories, monetary values, discount, ratings, etc.) rather than ad hoc one-off replacements. Key techniques used:

- `try...otherwise` parsing chains for messy dates and numbers
- Custom cleaning functions per column, each handling nulls, placeholders (`N/A`, `-`, `#VALUE!`), and format variants
- **Performance fix:** repeated `Table.ReplaceValue` steps (which re-scan and re-materialize the whole table each time) were replaced with a single `Table.TransformColumns` call per column - significantly reducing the number of applied steps and query evaluation time
- Raw values preserved alongside cleaned ones (e.g., `Order Date (Raw)`, `Discount (Raw)`) for auditability

## 6. Data Model

The raw flat table was restructured into a **star schema**:

- **Fact_Sales** - one row per order, holding measures and foreign keys
- **Dim_Vehicle** - Car Make, Car Model, Vehicle Type, Vehicle Year, Fuel Type, Transmission, Color
- **Dim_Customer** - Customer Name, Customer Type, Customer Age
- **Dim_Branch** - Region, County, City, Branch
- **Dim_SalesRep** - Sales Rep
- **Dim_Date** - a DAX calculated date table (`CALENDAR()` + `ADDCOLUMNS()`), marked as the official Date Table, supporting time intelligence

**Relationships:** all dimension tables relate to `Fact_Sales` as 1:* (single direction). `Dim_Date[Date]` relates to both `Fact_Sales[Order Date]` (active) and `Fact_Sales[Delivery Date]` (inactive, activated in specific measures via `USERELATIONSHIP()`).

Fields like Lead Source, Payment Method, Payment Status, Delivery Status, Returned, Customer Rating, and Review Count were deliberately kept in `Fact_Sales` rather than split into extra dimensions, since they describe the transaction itself rather than a reusable business entity.

## 7. Key DAX Measures

| Measure | Purpose |
|---|---|
| `Total Revenue (Recorded)` | Revenue as recorded in the source data |
| `Total Revenue (Calculated)` | Revenue independently derived from units × price × (1 − discount), for validation |
| `Revenue Variance` / `Revenue Variance %` | Cross-check between recorded and calculated revenue |
| `Total Cost`, `Gross Profit`, `Gross Profit Margin %` | Core profitability |
| `Total Units Sold`, `Total Orders`, `Avg Order Value`, `Avg Discount %` | Volume metrics |
| `Revenue LY`, `Revenue YoY %` | Time-over-time comparison |
| `Avg Delivery Days`, `Logistics Cost % of Revenue` | Delivery/logistics efficiency |
| `Return Rate`, `Cancellation Rate` | Risk/operational health |
| `Branch Revenue Rank`, `Revenue % of Total` | Ranking and contribution analysis |
| `Avg Customer Rating` | Customer experience |

## 8. Data Validation

`Revenue Variance` deliberately compares the recorded revenue figure against an independently calculated one (units × price × (1 − discount)), so discrepancies are surfaced rather than assumed away. 

Other validation checks performed:
- Row counts confirmed unchanged after all merges (no accidental fan-out/duplication)
- Dimension key columns checked for 100% valid / 0% error / 0% empty after each merge

## 9. Executive Dashboard (Page 1)

A single-page overview answering **"How is JCars Logistics performing?"**, organized into five zones:

1. **Title & Slicers** - Year, Region, Branch
2. **KPI Cards** - Total Revenue, Total Units Sold, Gross Profit, Gross Profit Margin %, Total Orders
3. **Revenue Trend** - monthly line chart (chronologically sorted via a hidden `YearMonthSort` column)
4. **Comparison Bars** - Top 10 Branches and Top 10 Car Makes by revenue
5. **Geography & Risk** - revenue by region map, payment status breakdown by value, and a conditionally-formatted Return Rate indicator (red ≥ 5%, green below)

## 10. Assumptions & Business Rules Summary

- Monetary values with no currency indicator are assumed to be KES
- Discounts above 100% are treated as data errors and nullified, not guessed at
- Customer identity is approximated using Name + Type + Age (no true Customer ID exists in the source data) - a known limitation
- Vehicle identity (`Dim_Vehicle`) represents a specification (make + model + year + trim), not a physical VIN


## 11. Repository Structure

```
├── JCars_Analysis.pbix              # Final Power BI file
├── data/
│   └── jcars_raw_dataset.csv        # Original dataset used
├── screenshots/
│   ├── model-view.png
│   ├── executive-dashboard.png
│   └── ...
└── README.md
```

## 12. Tools Used

Power BI Desktop · Power Query (M) · DAX

---

**Author:** `Denis Ndiritu`
**Cohort/Track:** `9, Data Science`
**Dev.to Article:** `https://dev.to/sir_masha_g/from-raw-data-to-business-decisions-building-a-power-bi-solution-for-jcars-logistics-3d8h`