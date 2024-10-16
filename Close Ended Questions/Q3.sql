/*Assumption: I am assuming the definition of generations based on this article from Pew Research 
and that people born after 2012 are Generation Alpha.*/

--create a view with the user's generation as a new column
WITH u_generations As (
	SELECT *,
    	CASE
        	WHEN strftime('%Y', u.BIRTH_DATE) BETWEEN '1928' AND '1945' THEN 'Silent Generation'
        	WHEN strftime('%Y', u.BIRTH_DATE) BETWEEN '1946' AND '1964' THEN 'Baby Boomers'
        	WHEN strftime('%Y', u.BIRTH_DATE) BETWEEN '1965' AND '1980' THEN 'Generation X'
        	WHEN strftime('%Y', u.BIRTH_DATE) BETWEEN '1981' AND '1996' THEN 'Millennials'
        	WHEN strftime('%Y', u.BIRTH_DATE) BETWEEN '1997' AND '2012' THEN 'Generation Z'
        	WHEN strftime('%Y', u.BIRTH_DATE) BETWEEN '2013' AND strftime('%Y', 'now') THEN 'Generation Alpha'
        	ELSE 'Other'  
        	-- If the birth year doesn't fall into these categories when blank or Null or typo
    	END AS generation
  	FROM USER_TAKEHOME u 
),

--map the transactions to specify which generation person has made the transaction in transaction table
t_by_gen AS (
	SELECT *
	FROM TRANSACTION_TAKEHOME t LEFT JOIN u_generations g ON t.USER_ID = g.ID 
	WHERE g.ID in (SELECT user_id from TRANSACTION_TAKEHOME)
)

/*percentage of sales is calculated based on how many transactions 
are for Health & Wellness products*/

SELECT t.generation, (SUM(t.FINAL_SALE) / (SELECT SUM(final_sale) FROM t_by_gen t LEFT JOIN PRODUCTS_TAKEHOME p ON t.BARCODE = p.BARCODE WHERE lower(p.CATEGORY_1) like '%health%wellness%'))*100 AS percentage_of_sales
FROM t_by_gen t LEFT JOIN PRODUCTS_TAKEHOME p ON t.BARCODE = p.BARCODE
WHERE lower(p.CATEGORY_1) like '%health%wellness%'
GROUP by t.generation;

