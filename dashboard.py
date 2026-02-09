import streamlit as st
import duckdb
import pandas as pd
import plotly.express as px

st.set_page_config(page_title="Olist Analytics", layout="wide")

conn = duckdb.connect('olist.duckdb')

st.title("📊 Olist E-Commerce Analytics")

# Customer Metrics
st.header("💰 Customer Metrics")

total_customers = conn.execute("SELECT COUNT(DISTINCT customer_id) FROM raw_customers").fetchone()[0]
total_orders = conn.execute("SELECT COUNT(*) FROM raw_orders").fetchone()[0]
avg_order_value = conn.execute("SELECT ROUND(AVG(price + freight_value), 2) FROM raw_order_items").fetchone()[0]

col1, col2, col3 = st.columns(3)
with col1:
  st.metric("Total Customers", f"{total_customers:,.0f}")
with col2:
  st.metric("Total Orders", f"{total_orders:,.0f}")
with col3:
  st.metric("Avg Order Value", f"${avg_order_value}")

# Review Sentiment
st.header("⭐ Review Sentiment")

sentiment = conn.execute("""
  SELECT 
    CASE 
      WHEN review_score >= 4 THEN 'Positive'
      WHEN review_score = 3 THEN 'Neutral'
      ELSE 'Negative'
    END as sentiment,
    COUNT(*) as count
  FROM raw_order_reviews
  GROUP BY sentiment
""").fetchdf()

fig = px.pie(sentiment, values='count', names='sentiment', title="Reviews by Sentiment")
st.plotly_chart(fig, width='stretch')

# Top Sellers
st.header("🏆 Top Sellers by Revenue")

sellers = conn.execute("""
  SELECT 
    s.seller_id,
    COUNT(DISTINCT oi.order_id) as orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) as revenue
  FROM raw_sellers s
  LEFT JOIN raw_order_items oi ON s.seller_id = oi.seller_id
  GROUP BY s.seller_id
  ORDER BY revenue DESC
  LIMIT 10
""").fetchdf()

fig = px.bar(sellers, x='seller_id', y='revenue', title="Top 10 Sellers by Revenue")
st.plotly_chart(fig, width='stretch')

# Categories
st.header("📦 Top Product Categories")

categories = conn.execute("""
  SELECT 
    p.product_category_name_english,
    COUNT(DISTINCT oi.order_id) as orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) as revenue
  FROM raw_products p
  LEFT JOIN raw_order_items oi ON p.product_id = oi.product_id
  WHERE p.product_category_name_english IS NOT NULL
  GROUP BY p.product_category_name_english
  ORDER BY revenue DESC
  LIMIT 10
""").fetchdf()

fig = px.bar(categories, x='product_category_name_english', y='revenue', title="Top 10 Categories by Revenue")
st.plotly_chart(fig, width='stretch')

# Orders by Status
st.header("📈 Orders by Status")

status = conn.execute("""
  SELECT 
    order_status,
    COUNT(*) as count
  FROM raw_orders
  GROUP BY order_status
  ORDER BY count DESC
""").fetchdf()

fig = px.bar(status, x='order_status', y='count', title="Orders by Fulfillment Status")
st.plotly_chart(fig, width='stretch')

st.divider()
st.caption("✓ Olist E-Commerce Analytics Dashboard | dbt + DuckDB + Streamlit")

conn.close()