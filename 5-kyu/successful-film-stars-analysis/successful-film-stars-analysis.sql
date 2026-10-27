WITH qualifying_films AS (
    -- Films that were rented 7 or more times
    SELECT f.film_id
    FROM film f
    INNER JOIN inventory i ON f.film_id = i.film_id
    INNER JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id
    HAVING COUNT(r.rental_id) >= 7
),
disqualified_actors AS (
    -- Actors who have appeared in at least one film that doesn't qualify
    -- (either rented < 7 times OR has no rentals at all)
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id NOT IN (SELECT film_id FROM qualifying_films)
),
actor_film_counts AS (
    -- Count unique films for actors who are NOT disqualified
    SELECT 
        fa.actor_id,
        COUNT(DISTINCT fa.film_id) AS film_count
    FROM film_actor fa
    WHERE fa.actor_id NOT IN (SELECT actor_id FROM disqualified_actors)
    GROUP BY fa.actor_id
    HAVING COUNT(DISTINCT fa.film_id) >= 20
)
SELECT 
    a.actor_id,
    a.first_name || ' ' || a.last_name AS full_name,
    afc.film_count
FROM actor a
INNER JOIN actor_film_counts afc ON a.actor_id = afc.actor_id
ORDER BY afc.film_count DESC, a.actor_id ASC;