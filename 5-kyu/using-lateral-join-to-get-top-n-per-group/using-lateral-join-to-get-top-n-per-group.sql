-- Replace with your SQL query
​
select
  c.id as category_id,
  c.category as category,
  p.title,
  p.views,
  p.id as post_id 
FROM categories c
LEFT JOIN LATERAL (
  SELECT id, title, views
  FROM posts
  WHERE category_id = c.id
  ORDER BY views DESC, id ASC
  LIMIT 2
) p ON true
ORDER BY c.category ASC, p.views DESC, p.id ASC;
​