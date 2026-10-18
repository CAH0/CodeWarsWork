WITH numbered AS (
    SELECT
        user_id,
        date_of_call,
        outcome,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY date_of_call) AS rn,
        ROW_NUMBER() OVER (PARTITION BY user_id, outcome ORDER BY date_of_call) AS outcome_rn
    FROM calls
),
islands AS (
    SELECT
        user_id,
        date_of_call,
        outcome,
        rn - outcome_rn AS island_id,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, rn - outcome_rn
            ORDER BY date_of_call
        ) AS position_in_island
    FROM numbered
    WHERE outcome = 'No'
)
SELECT
    user_id,
    date_of_call::text AS date_of_call
FROM islands
WHERE position_in_island = 6
ORDER BY user_id, date_of_call;