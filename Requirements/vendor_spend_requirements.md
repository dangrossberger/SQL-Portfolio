# Vendor Spend Reporting — Requirements Document

**Author:** Dan Grossberger  
**Date:** 2025-09-12  
**Project Scope:** Vendor Spend, Dept-Top3, Dept-MoM

---

## 1. Project Purpose
- **Vendor Spend**: Provide visibility into total spend by vendor across all departments.  
- **Dept-Top3**: Identify the Top 3 vendors per department to monitor concentration.  
- **Dept-MoM**: Track month-over-month changes in department spend, including previous month values, differences, and % change.

---

## 2. Business Requirements
- Finance needs clear reporting on which vendors dominate total spend.  
- Department managers need visibility into their top 3 vendors.  
- Analysts need to catch unusual spend trends by comparing current vs. prior months.

---

## 3. Functional Requirements
- Aggregate total spend by vendor.  
- Support filters: department, date range.  
- Order vendors overall and within departments by spend (with ranks where implemented).  
- Return Top 3 vendors per department (current implementation).  
  - *Future enhancement*: Top 3 vendors per department **per month**.  
- Compute month-over-month spend at the department level, including:  
  - `prev_spend`  
  - `spend_diff`  
  - `pct_change` (NULL if no prior month).  
- Export results to CSV with module-appropriate headers (documented in each README).

---

## 4. User Stories & Acceptance Criteria

**US-001: Top Vendors**  
As a Finance Analyst, I want to see the top vendors by spend so I can identify concentration risk.

- **AC-001.1:** Given a date range, when I run the report, then vendors appear ordered by spend descending.  
- **AC-001.2:** The output includes `vendor_id`, `vendor_name`, and `vendor_spend` (rounded).  

---

**US-002: Top 3 Vendors by Department**  
As a Department Manager, I want to see the top 3 vendors in my department so I can monitor supplier reliance.

- **AC-002.1:** Given a department, when I run the report, then exactly 3 vendors (or fewer if fewer exist) are returned.  
- **AC-002.2:** Results are ordered by spend descending, with ranks assigned using `ROW_NUMBER`.  

---

**US-003: Month-over-Month Comparison**  
As a Finance Analyst, I want to see spend compared to the prior month so I can spot unusual changes.

- **AC-003.1:** Given monthly spend data, when a previous month exists, then `prev_spend`, `spend_diff`, and `pct_change` are populated.  
- **AC-003.2:** If no previous month exists, those fields return NULL.  

---

## 5. Non-Functional Requirements
- **Performance:** Query results return in under 2 seconds on the sample dataset.  
- **Consistency:** Each module applies its defined rules consistently (tiers in Vendor Spend, ranks in Top-3, LAG in MoM).  
- **Repeatability:** Running with the same filters produces identical results.  
- **Traceability:** SQL scripts and CSV outputs include timestamps and filter metadata.

---

## 6. Process Flow
Analyst → SQL Process → Output  

Select filters (dept/date) ↓  
Aggregate vendor spend ↓  
Rank vendors (overall or per dept) ↓  
Calculate `prev_spend`, `spend_diff`, and `pct_change` ↓  
Return Top N / Top 3 results ↓  
Export to CSV

---

## 7. Out of Scope / Future Enhancements
- Threshold-based “big move” flag (e.g., `pct_change ≥ 20%`).  
- Vendor tiering (VIP/Gold/Silver) applied across full dataset, not just Top Vendors.  
- Automated dashboard integration (Power BI / Tableau).  
- Top-3 vendors per department **per month**.

---

## 8. Conclusion
This requirements document defines the scope, business rules, and acceptance criteria for the Vendor Spend reporting modules (Vendor Spend, Dept-Top3, and Dept-MoM). Together with the ERD and SQL scripts in this project, it demonstrates a complete workflow from **business needs → requirements → data model → implementation**.
