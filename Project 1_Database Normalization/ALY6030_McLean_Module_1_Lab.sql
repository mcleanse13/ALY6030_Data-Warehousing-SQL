
create database module1lab;

use module1lab;
#4
select * from sacramento
where beds >= 2
and baths >=2;

#5
SELECT * from sacramento
where type = 'Condo'
order by sq__ft desc;

#6 and #7
select zip,avg(price) as average_price
from sacramento
group by zip
order by average_price;

#8

select city,min(baths) as min_baths,max(baths) as max_baths,count(*) as count_of_records
from sacramento
where beds = 2
group by city
having count_of_records >= 2;