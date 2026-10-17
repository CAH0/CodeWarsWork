-- add your query here!
select
  name,
  count(d.detail) filter (where d.detail = 'good') as good,
  count(d.detail) filter (where d.detail = 'ok') as ok,
  count(d.detail) filter (where d.detail = 'bad') as bad 
from products as p
join details as d on p.id = d.product_id
group by name
order by name 