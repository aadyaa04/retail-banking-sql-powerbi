Retail Banking Performance Dashboard  

Overview  
This project analyzes retail banking customer and transaction data using SQL and Power BI.  
The goal is to extract insights on CASA balances, churn, customer retention, and deposit/withdrawal trends to support business decision-making.  

Dataset  
Two tables were created in SQLite:  

customer  
  - `customer_id` (Primary Key)  
  - `age`, `gender`, `branch_id`  
  - `account_type` (savings/current)  
  - `account_open_date`, `current_balance`  
  - `channel`, `churn_flag`  

transaction  
  - `transaction_id` (Primary Key)  
  - `customer_id` (Foreign Key)  
  - `transaction_date`  
  - `transaction_type` (deposit/withdrawal)  
  - `amount`  

Dataset size:  
- Customers: 2000 
- Transactions: 50,000+ 

---

SQL Analysis  
Some example queries:  

1. Customer Count

SELECT COUNT(*) AS total_customers FROM customer;

2. Transaction Count
SELECT COUNT(*) AS total_transactions FROM transaction;

3.Churn %
SELECT 
    ROUND( (SUM(CASE WHEN churn_flag = 1 THEN 1 ELSE 0 END) * 1.0) / COUNT(*), 2) AS churn_rate
FROM customer;

4.Deposits Vs withdrawal
SELECT 
    strftime('%Y-%m', transaction_date) AS month,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_deposits,
    ABS(SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END)) AS total_withdrawals
FROM transaction
GROUP BY month
ORDER BY month;

Full queries available in /sql/retail_analysis_queries.sql.

Power BI Dashboard
Key Metrics (Cards)

Total CASA Balance = 65M

Churn % = 1%

Average Balance = 32.6K

Active Customers = 2000

Retention % (Monthly) = 61%

Visuals

Top 10 Branches by CASA Balance

Bar chart of savings vs current balance by branch.

Sorted descending, top 10 branches shown.

Deposits vs Withdrawals Over Time

Line & column chart with Month-Year on X-axis.

Deposits shown in green, Withdrawals in blue.

Retention Analysis

Matrix showing monthly retention rate.

Conditional formatting heatmap.

Cohort Analysis (Advanced)

Rows: Customer cohort month (based on account_open_date).

Columns: Activity month (based on transaction_date).

Values: Active customer counts (retention heatmap).

Sample screenshots
<img width="1125" height="633" alt="image" src="https://github.com/user-attachments/assets/5db490af-a933-4203-bdf4-a92ce9c20f95" />

Tools Used

SQLite (for database creation)

SQL (for data querying)

Power BI (for dashboard visualization)

GitHub (for version control and portfolio)

How to Use

Clone this repo:
git clone https://github.com/<your-username>/retail-banking-sql-powerbi.git

Open the database:

File: data/demo.db

Run queries from sql/retail_analysis_queries.sql.

Open the Power BI dashboard:

File: dashboard/RetailBankingDashboard.pbix.

Key Insights

CASA balance is concentrated in a few top branches.

Customer churn is low (~1%), but retention stabilizes at ~60%.

Deposits steadily outpace withdrawals → healthy banking behavior.

Cohort analysis shows improving customer retention in newer cohorts.

License

MIT License — free to use and share.




