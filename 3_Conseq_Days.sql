-- Fetch the users who logged in consecutively 3 or more times.

drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

with t1 as
	(select *, 
		case when login_date - lag(login_date) over (partition by user_name order by login_id) = 1
			and lead(login_date) over (partition by user_name order by login_id) - login_date = 1
		then 'Yes'
		else 'No'
		end conseq
	from login_details
	order by user_name, login_id)
	
select user_name
from t1
where conseq='Yes'
;
