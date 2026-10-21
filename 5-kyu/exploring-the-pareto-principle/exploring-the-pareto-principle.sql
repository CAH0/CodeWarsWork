WITH customer_rentals AS (
    SELECT
        customer_id,
        COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
),
total_customers AS (
    SELECT COUNT(*) AS cnt FROM customer_rentals
),
top_n AS (
    SELECT CEIL(tc.cnt * 0.20)::integer AS n
    FROM total_customers tc
),
ranked AS (
    SELECT
        cr.customer_id,
        cr.rental_count,
        ROW_NUMBER() OVER (ORDER BY cr.rental_count DESC) AS rn
    FROM customer_rentals cr
),
top_20 AS (
    SELECT
        SUM(r.rental_count) AS top_rentals,
        COUNT(*)            AS top_customer_count
    FROM ranked r
    CROSS JOIN top_n
    WHERE r.rn <= top_n.n
),
totals AS (
    SELECT SUM(rental_count) AS total_rentals
    FROM customer_rentals
)
SELECT
    t.top_rentals::integer                                AS "top_20%_rentals_count",
    tot.total_rentals::integer                            AS "total_rentals_count",
    ROUND(t.top_rentals * 100.0 / tot.total_rentals, 2)   AS "percentage_of_top_20%"
FROM top_20 t
CROSS JOIN totals tot;