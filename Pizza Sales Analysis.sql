create database pizza_sales;
use pizza_sales;
desc `order_details`;
desc `orders`;
desc `pizza_types`;
desc`pizzas`;

-- Retrieve the total number of orders placed.
select count(order_id) from orders;



ALTER TABLE `pizza_sales`.`orders` 
CHANGE COLUMN `order_id` `order_id` INT NOT NULL ,
CHANGE COLUMN `date` `date` TEXT NOT NULL ,
CHANGE COLUMN `time` `time` TEXT NOT NULL ,
ADD PRIMARY KEY (`order_id`);
;

 
ALTER TABLE `pizza_sales`.`order_details` 
CHANGE COLUMN `order_details_id` `order_details_id` INT NOT NULL ,
CHANGE COLUMN `order_id` `order_id` INT NOT NULL ,
CHANGE COLUMN `pizza_id` `pizza_id` TEXT NOT NULL ,
CHANGE COLUMN `quantity` `quantity` INT NOT NULL ,
ADD PRIMARY KEY (`order_details_id`);

-- Calculate the total revenue generated from pizza sales.
select sum(`order_details`.`quantity`*`pizzas`.`price`) as total_Revenue
from `order_details` join `pizzas` on
`pizzas`.`pizza_id`=`order_details`.`pizza_id`;

 
 
 -- Identify the highest-priced pizza.
 select `pizza_types`.`name`,`pizzas`.`price` from `pizza_types`
 join `pizzas` on `pizza_types`.`pizza_type_id`=`pizzas`.`pizza_type_id`
 order by `pizzas`.`price` desc limit 1;
 
 -- Identify the most common pizza size ordered.
 SELECT `pizzas`.`size`,COUNT(`order_details`.`order_details_id`) AS No_of_order
FROM `pizzas` JOIN
`order_details` ON `pizzas`.`pizza_id` = `order_details`.`pizza_id`
GROUP BY `pizzas`.`size`
ORDER BY No_of_order DESC
LIMIT 1;
 
 -- List the top 5 most ordered pizza types along with their quantities.

 select `pizza_types`.`name`,sum(`order_details`.`quantity`) as Quantity
 from `pizza_types` join `pizzas`
 on `pizza_types`.`pizza_type_id`=`pizzas`.`pizza_type_id`
 join `order_details` 
 on `order_details`.`pizza_id`=`pizzas`.`pizza_id`
 group by `pizza_types`.`name` order by Quantity desc limit 5;
 
 
 -- Join the necessary tables to find the total quantity of each pizza category ordered.
 select `pizza_types`.`category`, 
sum(`order_details`.`quantity`) as Total_Quantity from  `pizza_types`
join `pizzas` on `pizza_types`.`pizza_type_id`=`pizzas`.`pizza_type_id`
join `order_details` on `pizzas`.`pizza_id`=`order_details`.`pizza_id`
group by `pizza_types`.`category`;

-- Determine the distribution of orders by hour of the day.
 select hour(`time`), count(`orders`.`order_id`) from `orders`
group by hour(`time`);

-- Join relevant tables to find the category-wise distribution of pizzas.
select `category`,count(`name`) from `pizza_types`
group by `category`;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(Avg_Order_Quantity) from (SELECT `date`,sum(`order_details`.`quantity`)
 as Avg_Order_Quantity FROM `orders`
JOIN `order_details` ON `orders`.`order_id` = `order_details`.`order_id`
GROUP BY `date`)as order_Quantity;



-- Determine the top 3 most ordered pizza types based on revenue.
select `pizza_types`.`name`,sum(`pizzas`.`price`*`order_details`.`quantity`) Revenue
from `pizza_types` join `pizzas` on `pizzas`.`pizza_type_id`=`pizza_types`.`pizza_type_id`
join `order_details`on `pizzas`.`pizza_id`=`order_details`.`pizza_id`
group by `pizza_types`.`name` order by Revenue desc limit 3;

 
-- Calculate the percentage contribution of each pizza type to total revenue. 
 
 select `pizza_types`.`category`,round(sum(`pizzas`.`price`*`order_details`.`quantity`)
 / (select(sum(`order_details`.`quantity`*`pizzas`.`price`))
from `order_details` join `pizzas` on
`pizzas`.`pizza_id`=`order_details`.`pizza_id`)*100,2) as Revenue
from `pizza_types` join `pizzas` on `pizzas`.`pizza_type_id`=`pizza_types`.`pizza_type_id`
join `order_details`on `pizzas`.`pizza_id`=`order_details`.`pizza_id`
group by `pizza_types`.`category` order by Revenue;


-- Analyze the cumulative revenue generated over time.

select `date`,round(sum(revenue) over(order by `date`),2) as cumulative_revenue 
from (select `orders`.`date`,sum(`order_details`.`quantity`*`pizzas`.`price`) as revenue from
`order_details` join `pizzas` on `order_details`.`pizza_id`=`pizzas`.`pizza_id`
join `orders` on `orders`.`order_id`=`order_details`.`order_id`
group by `orders`.`date`) as sales;
