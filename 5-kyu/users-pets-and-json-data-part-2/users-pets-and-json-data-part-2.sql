WITH pet_data AS (
    SELECT 
        u.id AS user_id,
        u.info->>'name' AS user_name,
        UPPER(LEFT(pet->>'name', 1)) AS first_letter
    FROM 
        users u
        CROSS JOIN LATERAL jsonb_array_elements(u.info->'pets') AS pet
    WHERE 
        pet->>'name' IS NOT NULL
        AND pet->>'name' != ''
),
distinct_user_letters AS (
    SELECT DISTINCT
        first_letter,
        user_id,
        user_name
    FROM 
        pet_data
),
pet_counts AS (
    SELECT 
        first_letter,
        COUNT(*) AS pet_count
    FROM 
        pet_data
    GROUP BY 
        first_letter
),
user_aggregation AS (
    SELECT 
        first_letter,
        STRING_AGG(user_name, ', ' ORDER BY user_id) AS user_names
    FROM 
        distinct_user_letters
    GROUP BY 
        first_letter
)
SELECT 
    pc.first_letter,
    pc.pet_count,
    ua.user_names
FROM 
    pet_counts pc
    JOIN user_aggregation ua ON pc.first_letter = ua.first_letter
ORDER BY 
    pc.pet_count DESC,
    pc.first_letter ASC;