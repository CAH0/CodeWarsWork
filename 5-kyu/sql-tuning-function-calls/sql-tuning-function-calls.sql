with tab as (
  select 
    e.department_id,
    1 + pctIncrease(e.department_id) as kf
  from employees   e
  GROUP BY e.department_id
)
SELECT  
      e.employee_id,
       e.first_name,
       e.last_name,
       d.department_name,
       e.salary AS old_salary,
       e.salary * t.kf as new_salary
FROM employees   e
join departments d using(department_id)
join tab as t using(department_id)
ORDER BY (1);