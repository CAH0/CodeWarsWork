SELECT f.title
FROM film f
JOIN film_actor fa1 ON fa1.film_id = f.film_id AND fa1.actor_id = 105
JOIN film_actor fa2 ON fa2.film_id = f.film_id AND fa2.actor_id = 122
ORDER BY f.title;