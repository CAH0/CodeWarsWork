-- Replace with your SQL query
​
select
  created_at::date as date,
  count(*),
  (sum(count(*)) over(ORDER BY created_at::date))::int  as total
from posts
group by created_at::date
order by created_at::date
​