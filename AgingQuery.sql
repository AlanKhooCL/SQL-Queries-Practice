/* ----------:::  Scripts for PostgreSQL database  :::---------- */
/*We want to generate an inventory age report which would show the distribution of remaining inventory across the length of time the inventory has been sitting at the warehouse. We are trying to classify the inventory on hand across the below 4 buckets to denote the time the inventory has been lying the warehouse.

0-90 days old 
91-180 days old
181-270 days old
271 – 365 days old
*/

drop table warehouse;
create table warehouse
(
	ID						varchar(10),
	OnHandQuantity			int,
	OnHandQuantityDelta		int,
	event_type				varchar(10),
	event_datetime			timestamp
);

insert into warehouse values
('SH0013', 278,   99 ,   'OutBound', '2020-05-25 0:25'), 
('SH0012', 377,   31 ,   'InBound',  '2020-05-24 22:00'),
('SH0011', 346,   1  ,   'OutBound', '2020-05-24 15:01'),
('SH0010', 346,   1  ,   'OutBound', '2020-05-23 5:00'),
('SH009',  348,   102,   'InBound',  '2020-04-25 18:00'),
('SH008',  246,   43 ,   'InBound',  '2020-04-25 2:00'),
('SH007',  203,   2  ,   'OutBound', '2020-02-25 9:00'),
('SH006',  205,   129,   'OutBound', '2020-02-18 7:00'),
('SH005',  334,   1  ,   'OutBound', '2020-02-18 8:00'),
('SH004',  335,   27 ,   'OutBound', '2020-01-29 5:00'),
('SH003',  362,   120,   'InBound',  '2019-12-31 2:00'),
('SH002',  242,   8  ,   'OutBound', '2019-05-22 0:50'),
('SH001',  250,   250,   'InBound',  '2019-05-20 0:45');
COMMIT;

with w1 as
	(select *, extract(day from (select event_datetime from warehouse order by event_datetime desc fetch first 1 rows only) - event_datetime) as datediff 
	from warehouse),
	w90 as
	(select sum(onhandquantitydelta) as inbound_90
	from w1
	where 
		event_type='InBound' AND
		datediff<90),
	w180 as	
	(select 
		case 
			when sum(onhandquantitydelta) > (select onhandquantity from warehouse order by event_datetime desc fetch first 1 rows only) - (select inbound_90 from w90) then (select onhandquantity from warehouse order by event_datetime desc fetch first 1 rows only) - (select inbound_90 from w90)
		else
			sum(onhandquantitydelta) 
		end as inbound_180
	from w1
	where 
		event_type='InBound' AND
		datediff between 90 and 180),
	w270 as	
	(select 
		case 
			when sum(onhandquantitydelta) > (select onhandquantity from warehouse order by event_datetime desc fetch first 1 rows only) - (select inbound_90 from w90) - (select inbound_180 from w180) then (select onhandquantity from warehouse order by event_datetime desc fetch first 1 rows only) - (select inbound_90 from w90) - (select inbound_180 from w180)
		else
			sum(onhandquantitydelta) 
		end as inbound_270
	from w1
	where 
		event_type='InBound' AND
		datediff between 180 and 270),
	w365 as	
	(select 
		case 
			when sum(onhandquantitydelta) > (select onhandquantity from warehouse order by event_datetime desc fetch first 1 rows only) - (select inbound_90 from w90) - (select inbound_180 from w180) - (select inbound_270 from w270) then (select onhandquantity from warehouse order by event_datetime desc fetch first 1 rows only) - (select inbound_90 from w90) - (select inbound_180 from w180)- (select inbound_270 from w270)
		else
			sum(onhandquantitydelta) 
		end as inbound_365
	from w1
	where 
		event_type='InBound' AND
		datediff between 270 and 365)

select coalesce(inbound_90,0) as "0-90 days old", coalesce((select inbound_180 from w180),0) as "91-180 days old", coalesce((select inbound_270 from w270),0) as "181-270 days old", coalesce((select inbound_365 from w365),0) as "271 – 365 days old"
from w90
;
