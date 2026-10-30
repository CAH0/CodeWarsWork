WITH merged AS (
  SELECT
    avail_start,
    avail_end,
    MAX(avail_end) OVER (
      ORDER BY avail_start, avail_end
      ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS prev_max_end
  FROM availability
  WHERE user_id = 777
),
grouped AS (
  SELECT
    avail_start,
    avail_end,
    SUM(CASE WHEN prev_max_end IS NULL OR avail_start > prev_max_end THEN 1 ELSE 0 END)
      OVER (ORDER BY avail_start, avail_end) AS grp
  FROM merged
),
islands AS (
  SELECT
    grp,
    MIN(avail_start) AS start_ts,
    MAX(avail_end)   AS end_ts
  FROM grouped
  GROUP BY grp
)
SELECT
  COALESCE(SUM(
    EXTRACT(EPOCH FROM (end_ts - start_ts)) / 60
  ), 0)::integer AS total_minutes
FROM islands;