SQL Mini-Project Datasets
Files:
- vendors.csv
- requests.csv
- line_items.csv

Suggested schema (SQLite):

CREATE TABLE vendors (
  vendor_id INTEGER PRIMARY KEY,
  vendor_name TEXT,
  mbe_edge_flag INTEGER,
  active_flag INTEGER,
  category_specialty TEXT
);

CREATE TABLE requests (
  request_id INTEGER PRIMARY KEY,
  department TEXT,
  category TEXT,
  request_date TEXT,
  needed_by_date TEXT,
  amount REAL,
  priority TEXT,
  status TEXT,
  vendor_id INTEGER,
  FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);

CREATE TABLE line_items (
  line_id INTEGER PRIMARY KEY,
  request_id INTEGER,
  item_desc TEXT,
  item_category TEXT,
  qty INTEGER,
  unit_price REAL,
  line_total REAL,
  ship_date TEXT,
  FOREIGN KEY (request_id) REFERENCES requests(request_id)
);

SQLite import (from sqlite3 shell):
.mode csv
.import vendors.csv vendors
.import requests.csv requests
.import line_items.csv line_items

Helpful indexes:
CREATE INDEX idx_requests_dept_date ON requests(department, request_date);
CREATE INDEX idx_lineitems_req ON line_items(request_id);

