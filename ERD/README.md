# Entity Relationship Diagram (ERD) — Vendor Spend Project

This diagram shows the data model used across the Vendor Spend reporting modules (*Top Vendors, Dept-Top3, and Dept-MoM*).

---

## Tables

### Vendors
- **PK:** `vendor_id`  
- **Columns:** `vendor_name`, `mbe_edge_flag`, `active_flag`

### Requests
- **PK:** `request_id`  
- **FK:** `vendor_id → Vendors.vendor_id`  
- **Columns:** `department`, `amount`, `priority`, `category`

### Line_Items
- **PK:** `line_item_id`  
- **FK:** `request_id → Requests.request_id`  
- **Columns:** `line_total`, `unit_price`, `qty`, `item_description`, `ship_date`

---

## Relationships
- One **Vendor** can have many **Requests**.  
- One **Request** can have many **Line_Items**.

---

## Notes
This ERD defines the foundation for the SQL queries and requirements documents in this project.  
It’s also represented visually in `ERD/` (diagrams.net format).
