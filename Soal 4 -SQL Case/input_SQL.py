import pandas as pd
import mysql.connector

df = pd.read_csv('data-to-insights.ecommerce.all_sessions-sql.csv', usecols=['channelGrouping', 'country', 'fullVisitorId', 'timeOnSite', 'pageviews', 'sessionQualityDim', 'v2ProductName', 'productRevenue', 'productQuantity', 'productRefundAmount'])

conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='Ex4mpl3@2022#',
    database='test'
)

cursor = conn.cursor()

for _, row in df.iterrows():
    cursor.execute("""
    INSERT INTO ecommerce (channelGrouping, country, fullVisitorId, timeOnSite, pageviews, sessionQualityDim, v2ProductName, productRevenue, productQuantity, productRefundAmount)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (row['channelGrouping'], row['country'], row['fullVisitorId'], row['timeOnSite'], row['pageviews'], row['sessionQualityDim'], row['v2ProductName'], row['productRevenue'], row['productQuantity'], row['productRefundAmount']))

conn.commit()
cursor.close()
conn.close()
