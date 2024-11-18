/* Task 2.0
Середній за весь період конверт користувачів з тріального періоду 
в успішно сплачений другий платіж для користувачів, 
які мають підписку tenwords_1w_9.99_offer. 

Для кожного користувача групуємо транзакції, сортуємо їх за датою оплати 
та нумеруємо транзакції за часом їх здійснення. Підраховуємо кількість користувачів, 
які здійснили перший і другий успішні платежі (обидва без повернення). 
Розраховуємо конверсію як відсоток користувачів, які здійснили 
другий платіж відносно тих, хто зробив перший платіж.
*/
WITH numbered_transactions AS (
    SELECT
		user_id, 
		product_id, 
		refunded, 
		purchase_date,
		ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY purchase_date) AS transaction_number
	FROM transactions
	WHERE product_id = 'tenwords_1w_9.99_offer'
)
SELECT
	ROUND((COUNT(DISTINCT CASE 
							WHEN transaction_number = 1 AND refunded = FALSE 
							AND user_id IN (SELECT user_id FROM numbered_transactions 
											WHERE transaction_number = 2 AND refunded = FALSE) 
							THEN user_id END) * 1.0 
					/ COUNT(DISTINCT CASE WHEN transaction_number = 1 THEN user_id END)) * 100, 2
	) AS conversion_rate
FROM numbered_transactions;


/* Task 2.1
Нумерація транзакції у таблиці відносно користувача за часом 
створення транзакції (purchase_date).

Групуємо дані за user_id, сортуємо за датою оплати, 
нуммеруємо транзакції за часом за допомогою ROW_NUMBER().
*/
SELECT
	user_id, 
	product_id, 
	refunded, 
	purchase_date, 
	country_code, 
	media_source,
	ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY purchase_date ASC) AS transaction_number
FROM transactions;


/* Task 2.2
Запит, який поверне user_id тих користувачів, в яких перша транзакція 
(transaction_number = 1) має refunded=False, а друга - refunded=True.

Групуємо дані за user_id, нумеруємо транзакції за часом і знаходимо тих юзерів,
у яких в першій транзакції refunded = FALSE, а user_id входить в число тих, 
у кого в другій транзакції refunded = TRUE.
*/
WITH numbered_transactions AS (
    SELECT 
        user_id, 
		product_id, 
		refunded, 
		purchase_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY purchase_date ASC) AS transaction_number
    FROM transactions
)
SELECT 
	user_id
FROM numbered_transactions
WHERE
	transaction_number = 1 AND refunded = FALSE
    AND user_id IN (
        SELECT 
			user_id
        FROM numbered_transactions
        WHERE transaction_number = 2 AND refunded = TRUE
    );
