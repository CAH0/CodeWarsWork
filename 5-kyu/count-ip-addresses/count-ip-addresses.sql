SELECT
    id,
    (
        (split_part(last,  '.', 1)::bigint * 16777216) +
        (split_part(last,  '.', 2)::bigint * 65536)    +
        (split_part(last,  '.', 3)::bigint * 256)      +
        (split_part(last,  '.', 4)::bigint)
    ) -
    (
        (split_part(first, '.', 1)::bigint * 16777216) +
        (split_part(first, '.', 2)::bigint * 65536)    +
        (split_part(first, '.', 3)::bigint * 256)      +
        (split_part(first, '.', 4)::bigint)
    ) AS ips_between
FROM ip_addresses
ORDER BY id;