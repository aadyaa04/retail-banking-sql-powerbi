select count(*) from customer;
select count(*) from transactions;
-- total CASA Balance 
SELECT SUM(current_balance) AS total_casa_balance
FROM customer
WHERE account_type IN ('savings','current')
  AND customer_id <> 'customer_id';
  -- CASA Balance by branch
SELECT branch_id,
       COUNT(*) AS num_accounts,
       SUM(current_balance) AS branch_casa_balance,
       AVG(current_balance) AS avg_balance
FROM customer
WHERE customer_id <> 'customer_id'
GROUP BY branch_id
ORDER BY branch_casa_balance DESC
LIMIT 10;
-- Monthly deposits and withdrawals 
SELECT substr(transaction_date, 1, 7) AS month,
       SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_deposits,
       SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_withdrawals
FROM transactions
WHERE transaction_id <> 'transaction_id'
GROUP BY month
ORDER BY month;
-- Top 10 customers by balance 
SELECT customer_id, branch_id, current_balance
FROM customer
WHERE customer_id <> 'customer_id'
ORDER BY current_balance DESC
LIMIT 10;
-- churn % (customers with no activity in last 180 days)
SELECT ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_percentage
FROM customer
WHERE customer_id <> 'customer_id';
-- Monthly active customers and retention 
WITH monthly_active AS (
    SELECT customer_id,
           substr(transaction_date, 1, 7) AS month
    FROM transactions
    WHERE transaction_id <> 'transaction_id'
    GROUP BY customer_id, month
)
SELECT m1.month,
       COUNT(DISTINCT m1.customer_id) AS active_customers,
       COUNT(DISTINCT m2.customer_id) AS retained_from_prev_month,
       ROUND(100.0 * COUNT(DISTINCT m2.customer_id) 
             / NULLIF(COUNT(DISTINCT m1.customer_id), 0), 2) AS retention_rate_pct
FROM monthly_active m1
LEFT JOIN monthly_active m2
  ON m2.customer_id = m1.customer_id
 AND date(m2.month || '-01') = date(m1.month || '-01', '-1 month')
GROUP BY m1.month
ORDER BY m1.month;
-- Cohort retention ( by account opening month)
WITH cohorts AS (
  SELECT customer_id,
         substr(account_open_date, 1, 7) AS cohort_month
  FROM customer
  WHERE customer_id <> 'customer_id'
),
activity AS (
  SELECT customer_id,
         substr(transaction_date, 1, 7) AS activity_month
  FROM transactions
  WHERE transaction_id <> 'transaction_id'
)
SELECT c.cohort_month,
       a.activity_month,
       COUNT(DISTINCT a.customer_id) AS active_customers
FROM cohorts c
LEFT JOIN activity a ON a.customer_id = c.customer_id
GROUP BY c.cohort_month, a.activity_month
ORDER BY c.cohort_month, a.activity_month;


