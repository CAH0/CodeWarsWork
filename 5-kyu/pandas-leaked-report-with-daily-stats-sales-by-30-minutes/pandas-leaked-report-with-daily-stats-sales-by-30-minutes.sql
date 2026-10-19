WITH bounds AS (
    SELECT
        '2023-05-08 10:00:00'::timestamp AS day_start,
        '2023-05-08 22:30:00'::timestamp AS day_end
),
slots AS (
    SELECT
        gs AS slot_start,
        gs + interval '30 minutes' AS slot_end
    FROM bounds b,
         generate_series(b.day_start, b.day_end - interval '30 minutes', interval '30 minutes') AS gs
),
day_total AS (
    SELECT COALESCE(SUM(s.amount), 0) AS total
    FROM sales s, bounds b
    WHERE s.timestamp >= b.day_start
      AND s.timestamp <  b.day_end
)
SELECT
    to_char(sl.slot_start, 'HH12:MI AM') || '-' ||
    to_char(sl.slot_end,   'HH12:MI AM')                          AS "Time",
    COUNT(s.id)::int                                              AS "Cnt",
    COALESCE(SUM(s.amount), 0)::money                             AS "Sales",
    ROUND(
        COALESCE(SUM(s.amount), 0)
        / NULLIF((SELECT total FROM day_total), 0) * 100
    , 2)                                                          AS "%Sales"
FROM slots sl
LEFT JOIN sales s
       ON s.timestamp >= sl.slot_start
      AND s.timestamp <  sl.slot_end
GROUP BY sl.slot_start, sl.slot_end
ORDER BY sl.slot_start;