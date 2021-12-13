--Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
drop table patient_logs;
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, to_date('02-01-2020','dd-mm-yyyy'), 100);
insert into patient_logs values (1, to_date('27-01-2020','dd-mm-yyyy'), 200);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (1, to_date('04-03-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 450);

with t1 as
	(select account_id, extract(month from date) as month , count(distinct patient_id) as count, row_number() over (partition by extract(month from date) order by count(distinct patient_id) desc) as rk	
	from patient_logs
	group by account_id,month
	order by count desc)
	
select *
from t1
where rk < 3
;