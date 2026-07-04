Telco-customer-churn-sql-analysis

This is my first end-to-end SQL project, where I analyzed customer churn data for a telecom company using MySQL.
I used a real dataset of 7,043 customers and tried to find out why customers leave (churn) and which type of customers are more likely to leave.

 What I found
- Customers on month-to-month contracts leave much more often (42.7%) compared to customers with 2-year contracts (only 2.8%)
- New customers (who joined in the last 12 months) have the highest churn rate at 47.4%
- Customers paying through Electronic Check leave more often (45.3%) than customers using automatic payment methods
- Fiber optic internet customers pay more but also churn more, which was an interesting finding
- I also built my own logic to classify customers as High Risk, Medium Risk, or Low Risk based on their contract type, charges, and tenure. When I checked the actual churn rate for each group, my "High Risk" customers had a 69.5% churn rate, which showed that the logic actually worked

 SQL concepts I used in this project
- Aggregate functions (COUNT, SUM, AVG)
- GROUP BY and CASE WHEN
- Window Functions (NTILE, RANK, AVG OVER)
- CTEs (including using multiple CTEs together)

 Tools
MySQL Workbench

Dataset
Telco Customer Churn dataset from Kaggle
