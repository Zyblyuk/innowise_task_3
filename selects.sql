-- SELECT 1
SELECT t1.name, COUNT(t2.film_id) as count
    FROM film_category as t2
    INNER JOIN category as t1 ON t1.category_id = t2.category_id
    GROUP BY t1.category_id
    ORDER BY count DESC;


-- SELECT 2
SELECT t3.first_name, t3.last_name, t1.actor_id, SUM(t2.count) as sum
    FROM film_actor as t1
    INNER JOIN (
        SELECT film_id, COUNT(inventory_id)
        FROM inventory
        GROUP BY film_id
    ) as t2 ON t1.film_id = t2.film_id
    INNER JOIN actor as t3 ON t3.actor_id = t1.actor_id
    GROUP BY t1.actor_id, t3.actor_id
    ORDER BY sum DESC LIMIT 10;


-- SELECT 3
SELECT t3.name, SUM(t4.rental_rate) as prise
    FROM inventory AS t1
    INNER JOIN film_category as t2 ON t1.film_id=t2.film_id
    INNER JOIN category as t3 ON t2.category_id=t3.category_id
    INNER JOIN film as t4 ON t4.film_id=t1.film_id
    GROUP BY t3.name
    ORDER BY prise DESC LIMIT 1;


-- SELECT 4
SELECT t1.title FROM film AS t1
    INNER JOIN (
        SELECT film_id FROM film
            EXCEPT
        SELECT film_id FROM inventory) as t2
    ON t1.film_id = t2.film_id;


-- SELECT 5
SELECT  t2.first_name, t2.last_name, t1.actor_id FROM
    (SELECT t1.actor_id, COUNT(t1.actor_id) as c
        FROM film_actor as t1
        INNER JOIN (
            SELECT film_id
            FROM film_category
            WHERE category_id = 3) AS t2
        ON t1.film_id = t2.film_id
        GROUP BY t1.actor_id
        ORDER BY c DESC
    ) as t1
INNER JOIN actor as t2 ON t2.actor_id = t1.actor_id
WHERE t1.c in
    (SELECT count.c FROM
        (SELECT t1.actor_id, COUNT(t1.actor_id) as c
        FROM film_actor as t1
        INNER JOIN (
            SELECT film_id
            FROM film_category
            WHERE category_id = 3) AS t2
        ON t1.film_id = t2.film_id
        GROUP BY t1.actor_id
        ORDER BY c DESC) AS count
    GROUP BY count.c
    ORDER BY c DESC
    LIMIT 3);


-- SELECT 6
SELECT list.city, SUM(list.active) as active, COUNT(*)-SUM(list.active) as not_active
    FROM
    (
        SELECT t3.city, t1.active
        FROM customer as t1
        INNER JOIN address as t2 ON t1.address_id=t2.address_id
        INNER JOIN city as t3 ON t2.city_id=t3.city_id
    ) as list
    GROUP BY list.city
    ORDER BY not_active DESC;


-- SELECT 7
SELECT t4.city, SUM(t1.return_date-t1.rental_date) AS rental_sum
    FROM rental as t1
    INNER JOIN customer as t2 ON t1.customer_id=t2.customer_id
    INNER JOIN address as t3 ON t2.address_id=t3.address_id
    INNER JOIN city as t4 ON t3.city_id=t4.city_id
    WHERE SUBSTRING(t4.city, 1, 1)='a'
    GROUP BY t4.city

UNION

SELECT t4.city, SUM(t1.return_date-t1.rental_date) AS rental_sum
    FROM rental as t1
    INNER JOIN customer as t2 ON t1.customer_id=t2.customer_id
    INNER JOIN address as t3 ON t2.address_id=t3.address_id
    INNER JOIN city as t4 ON t3.city_id=t4.city_id
    WHERE not strpos(city, '-')=0
    GROUP BY t4.city;
