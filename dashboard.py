import streamlit as st
import duckdb
import pandas as pd
import plotly.express as px

st.set_page_config(page_title="Olist Analytics", layout="wide")

conn = duckdb.connect('olist.duckdb')

st.title("📊 Olist E-Commerce Analytics – Extended")

# ============================================================================
# Customer Lifetime Value
# ============================================================================
st.header("💰 Customer Lifetime Value")

ltv = conn.execute("""
  SELECT 
    COUNT(*) as total_customers,
    ROUND(AVG(SUM(oi.price + oi.freight_value)), 2) as avg_ltv
  FROM raw_customers c
  LEFT JOIN raw_orders o ON c.customer_id = o.customer_id
  LEFT JOIN raw_order_items oi ON o.order_id = oi.order_id
  GROUP BY c.customer_id
""").fetchdf()

st.metric("Average Customer LTV", f"${ltv['avg_ltv'].mean():.2f}")

# ============================================================================
# Review Sentiment
# ============================================================================
st.header("⭐ Review Sentiment Analysis")

sentiment = conn.execute("""
  SELECT 
    CASE 
      WHEN review_score >= 4 THEN 'Positive (4-5)'
      WHEN review_score = 3 THEN 'Neutral (3)'
      ELSE 'Negative (1-2)'
    END as sentiment,
    COUNT(*) as review_count
  FROM raw_order_reviews
  GROUP BY sentiment
""").fetchdf()

fig = px.pie(sentiment, values='review_count', names='sentiment', 
             title="Review Distribution by Sentiment",
             color_discrete_map={'Positive (4-5)': '#2ecc71', 'Neutral (3)': '#f39c12', 'Negative (1-2)': '#e74c3c'})
st.plotly_chart(fig, width='stretch')

# ============================================================================
# Seller Performance
# ============================================================================
st.header("🏆 Seller Performance")

sellers = conn.execute("""
  SELECT 
    s.seller_id,
    s.seller_city,
    COUNT(DISTINCT oi.order_id) as orders_sold,
    ROUND(SUM(oi.price + oi.freight_value), 2) as total_revenue,
    ROUND(AVG(CAST(r.review_score AS FLOAT)), 2) as avg_review_score
  FROM raw_sellers s
  LEFT JOIN raw_order_items oi ON s.seller_id = oi.seller_id
  LEFT JOIN raw_order_reviews r ON oi.order_id = r.order_id
  GROUP BY s.seller_id, s.seller_city
  ORDER BY total_revenue DESC
  LIMIT 15
""").fetchdf()

fig = px.scatter(sellers, x='orders_sold', y='avg_review_score', 
                 size='total_revenue', hover_data=['seller_city'],
                 title="Sellers: Orders vs Quality (bubble = revenue)",
                 labels={'orders_sold': 'Orders', 'avg_review_score': 'Avg Rating'})
st.plotly_chart(fig, width='stretch')

# ============================================================================
# Category Performance
# ============================================================================
st.header("📦 Product Category Insights")

categories = conn.execute("""
  SELECT 
    p.product_category_name_english as category,
    COUNT(DISTINCT oi.order_id) as orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) as revenue
  FROM raw_products p
  LEFT JOIN raw_order_items oi ON p.product_id = oi.product_id
  WHERE p.product_category_name_english IS NOT NULL
  GROUP BY p.product_category_name_english
  ORDER BY revenue DESC
  LIMIT 12
""").fetchdf()

fig = px.bar(categories, x='category', y='revenue', 
             title="Top Categories by Revenue")
st.plotly_chart(fig, width='stretch')

st.divider()
st.caption("✓ Extended Analytics | LTV • Sentiment • Seller Quality • Categories")

conn.close()