# PayPal Data Analysis - SQL Interview Solutions
![image](https://github.com/user-attachments/assets/8b8a08b1-709b-4f99-8a45-535b707b46c9)
## Overview
This repository contains SQL queries designed to solve common PayPal data analysis problems. These queries help in understanding user transactions, detecting high-value customers, analyzing money transfers, and identifying key trends in financial data.


## SQL Solutions

### 1. Final Account Balance for Each Account
Write a SQL query to retrieve the final account balance for each account by calculating the net amount from deposits and withdrawals.

Input Table:
• transactions table:
 - transaction_id (integer)
 - account_id (integer)
 - amount (decimal)
 - transaction_type (varchar)

```sql
SELECT
    account_id,
    SUM(
        CASE
            WHEN transaction_type = 'deposits' THEN amount
            WHEN transaction_type = 'withdrawals' THEN -amount
            ELSE 0
        END
    ) AS final_balance
FROM transactions
GROUP BY 1;
```
**Objective:** Compute the final balance for each account after deposits and withdrawals.

---
### 2. Average Transaction Amount per User and Ranking
Write a SQL query to compute the average transaction amount for each user and rank the users in descending order based on their average transaction amount.

Input Table:
• transactions table:
 - transaction_id (integer)
 - user_id (integer)
 - transaction_date (date)
 - amount (decimal)
 
```sql
SELECT 
	user_id,
	AVG(amount) as average_amount,
	RANK() OVER(ORDER BY AVG(amount) DESC) AS ranks
FROM transactions
GROUP BY user_id
```
**Objective:** Compute the average transaction amount for each user and rank them in descending order.

---
### 3. Unique Two-Way Money Transfer Relationships
Write a SQL query to determine the number of unique two-way money transfer relationships, where a two-way relationship is established if a user has sent money to another user and also received money from the same user.

Input Table:
• payments table:
 - payer_id (integer)
 - recipient_id (integer)
 - amount (integer)

```sql
SELECT COUNT(*) AS two_way_transfer
FROM (
    SELECT DISTINCT
        LEAST(payer_id, recipient_id) AS user_1,
        GREATEST(payer_id, recipient_id) AS user_2
    FROM payments
    WHERE payer_id != recipient_id
) AS unique_transfers;
```
**Objective:** Count unique two-way money transfers where both users have sent and received money to/from each other.

---
### 4. Identifying High-Value Customers (Last Month)
Write a SQL query to identify users who, in the last month, have either sent payments over 1000 or received payments over 5000, excluding those flagged as fraudulent.

Input Tables:
• transactions table:
 - transaction_id (integer)
 - user_id (integer)
 - transaction_date (date)
 - transaction_type (varchar)
 - amount (decimal)
 
• users table:
 - user_id (integer)
 - username (text)
 - is_fraudulent (boolean)

```sql
SELECT DISTINCT user_id
FROM transactions
WHERE
    transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    AND transaction_date < CURDATE()
    AND (
        (transaction_type = 'sent' AND amount > 1000)
        OR (transaction_type = 'received' AND amount > 5000)
    )
    AND user_id NOT IN (
        SELECT user_id FROM users WHERE is_fraudulent = 1
    );
```
**Objective:** Identify users who made high-value transactions in the last month, excluding fraudulent users.

---
### 5. Total and Average Transaction Amount for Each User (with At Least Two Transactions)
Write a SQL query that calculates the total and average transaction amount for each user, including only those users who have made at least two transactions.

Input Tables:
• Users table:
 - user_id (integer)
 - signup_date (date)

• Transactions table:
 - transaction_id (integer)
 - user_id (integer)
 - transaction_date (date)
 - transaction_amount (decimal)

```sql
SELECT
    user_id,
    SUM(transaction_amount) AS total_transaction_amount,
    AVG(transaction_amount) AS average_transaction_amount
FROM transactions
GROUP BY user_id
HAVING COUNT(transaction_id) >= 2;
```
**Objective:** Calculate the total and average transaction amount per user, including only users with at least two transactions.

## Usage
- Execute these SQL queries in a PostgreSQL or MySQL database.
- Modify queries as needed to fit the dataset schema.
- Use these queries for financial insights, fraud detection, and customer segmentation.

## License
This project is licensed under the MIT License.

