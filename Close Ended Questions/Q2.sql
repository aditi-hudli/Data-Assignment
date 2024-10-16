/*Assumption: I am assuming that the column in final_sale in table TRANSACTIONS is inclusive of the quantity. 
This assumption will apply to all answers henceforth*/
-- a view of users who have been signed up for at least 6 months
WITH user_month6 AS (
	SELECT *
	FROM USER_TAKEHOME
	WHERE ( (strftime('%Y', 'now') - strftime('%Y', created_date) >= 1 )
       		OR  
            (strftime('%m', 'now') - strftime('%m', created_date) >= 6 ) 
          )
),
--a view of transactions of people who have had their account for 6 months 
transactions_month6 AS (
	SELECT *
	FROM TRANSACTION_TAKEHOME
	WHERE user_id IN (SELECT id from user_month6)
)

/*Assuming top sales as the dollar amount of sales of each brand*/

SELECT p.BRAND, SUM(t.FINAL_SALE) AS Total
FROM transactions_month6 t LEFT JOIN PRODUCTS_TAKEHOME p on t.BARCODE = p.BARCODE
WHERE t.BARCODE IS NOT NULL AND p.BRAND is not NULL AND p.BRAND is NOT ''
GROUP BY p.BRAND
ORDER BY Total DESC
LIMIT 5;
