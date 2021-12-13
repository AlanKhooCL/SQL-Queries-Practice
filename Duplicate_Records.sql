--Write a SQL query to fetch all the duplicate records from a table.
drop table users;
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');
COMMIT;

with t1 as
	(select user_name, email, count(*) 
	from users
	group by user_name, email)
select u.user_id, u.user_name, u.email
from users u
	inner join t1
		on u.user_name=t1.user_name
group by u.user_id, u.user_name, u.email, t1.count
having t1.count >1
;