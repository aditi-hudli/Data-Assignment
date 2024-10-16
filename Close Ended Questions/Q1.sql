-- a view of users who are 21 and over
WITH user_above21 AS (
	SELECT *
	FROM USER_TAKEHOME
	WHERE ( (strftime('%Y', 'now') - strftime('%Y', birth_date)) > 21 
       		AND  
            (strftime('%m-%d', 'now') < strftime('%m-%d', birth_date)) 
          )
),
--a view of the transactions corresponding to the users 21 and over
transactions_above21 as (
	SELECT *
	FROM TRANSACTION_TAKEHOME
	WHERE user_id IN (SELECT id FROM user_above21) 
)
--count the brands based on receipts scanned
SELECT p.BRAND, COUNT(t.receipt_id) AS Total
FROM transactions_above21 t LEFT JOIN PRODUCTS_TAKEHOME p on t.BARCODE = p.BARCODE
WHERE t.BARCODE IS NOT NULL
GROUP BY p.BRAND
ORDER BY 2 DESC
LIMIT 5;
