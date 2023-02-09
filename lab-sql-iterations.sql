-- Write a query to find what is the total business done by each store.
select store_id, sum(amount)
from sakila.staff join sakila.payment using (staff_id)
group by store_id;

-- Convert the previous query into a stored procedure.
DELIMITER //
create procedure tot_business_by_store ()
begin
select store_id, sum(amount)
from sakila.staff join sakila.payment using (staff_id)
group by store_id;
end // 
DELIMITER ;

call tot_business_by_store;

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
DELIMITER //
create procedure tot_business_by_store2 (in x int)
begin
select store_id, sum(amount)
from sakila.staff join sakila.payment using (staff_id)
where store_id = x;
end //
DELIMITER ;

call tot_business_by_store2 (1);
call tot_business_by_store2 (2);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.
DELIMITER //
create procedure tot_business_by_store3 (in x int, out total_sales_value float)
begin
select sum(amount) into total_sales_value
from sakila.staff join sakila.payment using (staff_id)
where store_id = x;
end //
DELIMITER ;

call tot_business_by_store3(1, @total_sales_value1);
select @total_sales_value1;

call tot_business_by_store3(2, @total_sales_value2);
select @total_sales_value2;

-- I was not obtaining satisfactory results declaring the variable within the stored procedure (w/ declare statement). Instead, in this case, I used the output parameter (out total_sales_value float) that allows to pass a value from the stored procedure back to the calling program.
-- Therefore, when the select statements are used (for @total_sales_value1 or @total_sales_value2), they return the total business done for the corresponding store (store_id = 1 or store_id = 2). 

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
DELIMITER //
create procedure tot_business_by_store4 (in x int, out total_sales_value float, out flag varchar(20))
begin
select sum(amount) into total_sales_value
from sakila.staff join sakila.payment using (staff_id)
where store_id = x;

if total_sales_value > 30000 then
set flag = 'green_flag';
else
set flag = 'red_flag';
end if;

end //
DELIMITER ;

call tot_business_by_store4(1, @total_sales_value_1, @flag);
select @total_sales_value_1, @flag;

call tot_business_by_store4(2, @total_sales_value_2, @flag);
select @total_sales_value_2, @flag;

-- Another way to do it, showing store_id in the output but without storing the results.
DELIMITER //
create procedure tot_business_by_store5 (in x int)
begin
select store_id, sum(amount), case
when sum(amount) > 30000 then 'green_flag'
else 'red_flag' end as flag
from sakila.staff join sakila.payment using (staff_id)
where store_id = x;
end //
DELIMITER ;

call tot_business_by_store5 (1);
call tot_business_by_store5 (2);