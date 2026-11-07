WITH customer_rentals AS (
    SELECT DISTINCT
        DATE(rental_date) AS rental_day
    FROM rental
    WHERE customer_id = 1
),
grouped_rentals AS (
    SELECT 
        rental_day,
        rental_day - (ROW_NUMBER() OVER (ORDER BY rental_day) * INTERVAL '1 day') AS group_id
    FROM customer_rentals
),
group_sizes AS (
    SELECT 
        rental_day,
        group_id,
        COUNT(*) OVER (PARTITION BY group_id) AS consecutive_days
    FROM grouped_rentals
)
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    gs.rental_day AS date_rental_occurred,
    gs.consecutive_days
FROM group_sizes gs
CROSS JOIN customer c
WHERE c.customer_id = 1
ORDER BY gs.rental_day;