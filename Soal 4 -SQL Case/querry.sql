-- All of the data from productRevenue and productRefundAmount just contains 0
-- The aggregation can't sorted, because of 0 value from productRevenue and productRefundAmount

-- Create Database 'test'
CREATE DATABASE test;

-- Use 'test' Database
USE test;

-- Create 'ecommerce' table
CREATE TABLE ecommerce (
    channelGrouping VARCHAR(255),
    country VARCHAR(255),
    fullVisitorId VARCHAR(255),
    timeOnSite FLOAT,
    pageviews FLOAT,
    sessionQualityDim FLOAT,
    v2ProductName VARCHAR(255),
    productRevenue FLOAT,
    productQuantity FLOAT,
    productRefundAmount FLOAT
);

-- Show all columns from the table
SELECT * FROM ecommerce;

-- Test Case 1: Channel Analysis
SELECT channelGrouping, country, SUM(productRevenue) AS totalRevenue
FROM ecommerce
GROUP BY channelGrouping, country
ORDER BY totalRevenue DESC
LIMIT 10;

-- Test Case 2: User Behavior Analysis
SELECT 
    e.fullVisitorId,
    AVG(e.timeOnSite) AS avgTimeOnSite,
    AVG(e.pageviews) AS avgPageviews,
    AVG(e.sessionQualityDim) AS avgSessionQuality
FROM 
    ecommerce e
GROUP BY 
    e.fullVisitorId
HAVING 
    AVG(e.timeOnSite) > (SELECT AVG(timeOnSite) FROM ecommerce) -- Looking for Visitors who have Average Time on Site
    AND AVG(e.pageviews) < (SELECT AVG(pageviews) FROM ecommerce); -- Looking for Visitors who have Average Time on Page Views

-- Test Case 3: Product Performance
SELECT
    v2ProductName,
    SUM(productRevenue) AS totalRevenue,
    SUM(productQuantity) AS totalQuantitySold,
    SUM(productRefundAmount) AS totalRefundAmount,
    SUM(productRevenue) - SUM(productRefundAmount) AS netRevenue, 
    CASE
        WHEN SUM(productRefundAmount) > 0.1 * SUM(productRevenue) THEN 'Flagged'
        ELSE 'Not Flagged'
    END AS refundFlag
FROM 
    ecommerce e
GROUP BY 
    v2ProductName
ORDER BY 
    netRevenue DESC;