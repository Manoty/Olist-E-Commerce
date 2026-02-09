"""
Olist E-Commerce Dataset Load
Loads pre-downloaded CSVs into DuckDB
"""

import os
import duckdb

# Set up paths
data_dir = "./data/raw"  # Where your CSV files are
os.makedirs(data_dir, exist_ok=True)

# Initialize DuckDB connection
conn = duckdb.connect("olist.duckdb")

print("=" * 60)
print("OLIST E-COMMERCE DATA LOAD")
print("=" * 60)

# Map CSV files to table names
csv_files = {
    "olist_customers_dataset.csv": "raw_customers",
    "olist_orders_dataset.csv": "raw_orders",
    "olist_order_items_dataset.csv": "raw_order_items",
    "olist_order_payments_dataset.csv": "raw_order_payments",
    "olist_order_reviews_dataset.csv": "raw_order_reviews",
    "olist_products_dataset.csv": "raw_products",
    "olist_sellers_dataset.csv": "raw_sellers",
    "olist_geolocation_dataset.csv": "raw_geolocation",
    "product_category_name_translation.csv": "raw_product_category_translation",
}

print("\nLoading CSV files into DuckDB...")

for csv_file, table_name in csv_files.items():
    csv_path = os.path.join(data_dir, csv_file)
    if os.path.exists(csv_path):
        print(f"  Loading {csv_file} → {table_name}")
        conn.execute(f"CREATE TABLE IF NOT EXISTS {table_name} AS SELECT * FROM read_csv_auto('{csv_path}')")
        row_count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
        print(f"    ✓ {row_count} rows loaded")
    else:
        print(f"  ⚠ {csv_file} not found at {csv_path}")

print("\nVerifying tables...")
tables = conn.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'main' ORDER BY table_name").fetchall()
print(f"Tables created: {len(tables)}")
for table in tables:
    row_count = conn.execute(f"SELECT COUNT(*) FROM {table[0]}").fetchone()[0]
    print(f"  • {table[0]}: {row_count} rows")

print("\n" + "=" * 60)
print("✓ Data load complete. DuckDB ready at: olist.duckdb")
print("=" * 60)

conn.close()