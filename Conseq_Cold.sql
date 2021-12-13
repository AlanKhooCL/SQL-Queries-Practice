-- Fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

drop table weather;
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
delete from weather;
insert into weather values
(1, 'London', -1, to_date('2021-01-01','yyyy-mm-dd')),
(2, 'London', -2, to_date('2021-01-02','yyyy-mm-dd')),
(3, 'London', 4, to_date('2021-01-03','yyyy-mm-dd')),
(4, 'London', 1, to_date('2021-01-04','yyyy-mm-dd')),
(5, 'London', -2, to_date('2021-01-05','yyyy-mm-dd')),
(6, 'London', -5, to_date('2021-01-06','yyyy-mm-dd')),
(7, 'London', -7, to_date('2021-01-07','yyyy-mm-dd')),
(8, 'London', 5, to_date('2021-01-08','yyyy-mm-dd'));

with t1 as
	(select *,
		case when temperature < 0
			and lag(temperature) over (order by id) < 0
			and lead(temperature) over (order by id) <0
		then 'Yes'
		else 'No'
		end conseq
	from weather),
	t2 as
	(select *, 
		case when lag(conseq) over (order by id) = 'Yes'
		then 'Yes'
		else 'No'
		end result
	from t1)
select *
from t2
where result = 'Yes'
;