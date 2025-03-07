ayPal Data Analyst Interview Experience :
CTC - 22 LPA


Question 1: Final Account Balance
Write a SQL query to retrieve the final account balance for each account by calculating the net amount from deposits and withdrawals.

Input Table:
• transactions table:
 - transaction_id (integer)
 - account_id (integer)
 - amount (decimal)
 - transaction_type (varchar)
 
 SELECT 
	account_id,
	SUM(CASE 
			WHEN transaction_type = 'deposits' THEN amount
			WHEN transaction_type = 'withdrawals' THEN - amount
			ELSE 0
		END) AS final_balance
FROM transactions
GROUP BY account_id
	

Question 2: Average Transaction Amount per User
Write a SQL query to compute the average transaction amount for each user and rank the users in descending order based on their 
average transaction amount.

Input Table:
• transactions table:
 - transaction_id (integer)
 - user_id (integer)
 - transaction_date (date)
 - amount (decimal)
 
SELECT 
	user_id,
	AVG(amount) as average_amount,
	RANK() OVER(ORDER BY AVG(amount) DESC) AS ranks
FROM transactions
GROUP BY user_id


Question 3: Unique Money Transfer Relationships
Write a SQL query to determine the number of unique two-way money transfer relationships, where a two-way relationship is established 
if a user has sent money to another user and also received money from the same user.

Input Table:
• payments table:
 - payer_id (integer)
 - recipient_id (integer)
 - amount (integer)
 
 SELECT COUNT(*) AS two_way_transfer
	FROM (
			SELECT DISTINCT
				LEAST(a.payer_id, a.recipient_id) AS user_1
				GREATEST(b.payer_id, b.recipient_id) AS user_2)
			FROM payments AS a
			INNER JOIN payments AS b
			ON a.payer_id = b.recipient_id AND a.recipient_id = b.payer_id
		 ) AS unique_values
			
		
	

Question 4: Determining High-Value Customers
Write a SQL query to identify users who, in the last month, have either sent payments over 1000 or received payments over 5000, 
excluding those flagged as fraudulent.

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
 
 
 SELECT 
	DISTINCT user_id
FROM transactions
WHERE 
	transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) 
	AND	transaction_date < CURDATE()
	AND (
			(transaction_type = 'sent' AND amount > 1000)
			OR (transaction_type = 'received' AND amount > 5000)
		)
	AND user_id NOT IN
	(SELECT user_id FROM users WHERE is_fraudulent = 1 );




Question 5: Analyzing User Transaction Data
Write a SQL query that calculates the total and average transaction amount for each user, 
including only those users who have made at least two transactions.

Input Tables:
• Users table:
 - user_id (integer)
 - signup_date (date)

• Transactions table:
 - transaction_id (integer)
 - user_id (integer)
 - transaction_date (date)
 - transaction_amount (decimal)

SELECT
	user_id,
	SUM(transaction_amount) as total_transaction_amount,
	AVG(transaction_amount) as average_transaction_amount
FROM Transactions
GROUP BY user_id
HAVING COUNT(transaction_id) >= 2;