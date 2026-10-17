/*  SQL  */
​
select 
  t.id,
  t.heads,
  t.arms,
  b.legs,
  b.tails,
  case 
    when (heads > arms or tails > legs) then 'BEAST'
    else 'WEIRDO' 
  end as species
from top_half as t
join bottom_half as b using(id)
ORDER BY species