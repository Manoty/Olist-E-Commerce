import duckdb

conn = duckdb.connect('olist.duckdb')

# Check if raw tables exist
tables = conn.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'main'").fetchall()
print("Raw tables:", [t[0] for t in tables])

# Test a simple query
orders = conn.execute("SELECT COUNT(*) FROM raw_orders").fetchone()[0]
print(f"Orders count: {orders}")

conn.close()