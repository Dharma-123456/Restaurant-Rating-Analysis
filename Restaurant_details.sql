---Q16) Total restaurants in each state

select 
	       state,count(restaurant_id) No_of_restaurants 
from     restaurants
group by state
order by No_of_restaurants desc

  
--- Q17) Total restaurants in each city

select 
	       city,count(restaurant_id) No_of_restaurants 
from     restaurants
group by city
order by No_of_restaurants desc


--- Q18) Restaurants count by alcohol service 

select
	  	   alcohol_service,count(restaurant_id) total_restaurant
from     restaurants
GROUP by alcohol_service

  
--- Q19) Restaurants count by smoking allowed

select 
		     smoking_allowed, count(restaurant_id) total_restaurant
from     restaurants
group by smoking_allowed
order by total_restaurant desc

  
--- Q20) Alcohol & Smoking analysis

select 
		     alcohol_service,smoking_allowed,count(restaurant_id) total_restaurant
from     restaurants
group by alcohol_service,smoking_allowed

𝗥𝗲𝘀𝘁𝗮𝘂𝗿𝗮𝗻𝘁 𝗗𝗲𝘁𝗮𝗶𝗹𝘀:
  
  /*This SQL queries analyzes the restaurants & their cuisine type. This helps to understand the types of restaurants & their cuisines.*/


  
--- Q21)Restaurants count by Price

select
		     price,count(price) total_restaurant
from     restaurants
group by price
order by total_restaurant desc


--- Q22)Restaurants count by parking

select   
          parking,count(restaurant_id) total_restaurant
from      restaurants
group by  parking
order by  total_restaurant desc
  

--- Q23) Count of Restaurants by cuisines

select   
         cuisine,count(restaurant_id) total_restaurant
from     restaurant_cuisines
group by cuisine
order by total_restaurant desc
  

--- Q24) Preferred cuisines of each customer

select
		     cd.consumer_id,count(cd.consumer_id) total_cuisines,
		     string_agg(preferred_cuisine,',') cuisines
from 	   Customer_Details cd
join     Customer_Preference cp
on       cd.Consumer_ID=cp.Consumer_ID
group by cd.consumer_id
order by total_cuisines desc


--- Q25) Restaurant price analysis for each cuisine

SELECT
		     cuisine,
 		     sum(case when price='Low' then 1 else 0 end) low,
         sum(case when price='Medium' then 1 else 0 end) Medium,
         sum(case when price='High' then 1 else 0 end) High      
from	   restaurants r
join	   restaurant_cuisines rc
on 		   r.Restaurant_ID=rc.Restaurant_ID
group by cuisine
order by cuisine


--- Q26) Finding out count of each cuisine in each state

select 
		     cuisine,
         sum(case when state='Morelos' then 1 else 0 end) Morelos,
         sum(case when state='San Luis Potosi' then 1 else 0 end) San_Luis_Potosi,
         sum(case when state='Tamaulipas' then 1 else 0 end) Tamaulipas    
from     restaurants r
join 	   restaurant_cuisines rc
on 		   r.Restaurant_ID=rc.Restaurant_ID
group by cuisine


