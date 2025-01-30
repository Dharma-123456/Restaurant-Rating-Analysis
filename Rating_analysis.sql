𝗥𝗮𝘁𝗶𝗻𝗴𝘀 𝗔𝗻𝗮𝗹𝘆𝘀𝗶𝘀:

/*This SQL queries analyzes the ratings given by customers to restaurants. This helps to understand the customer choice & restaurants performance better.*/

--- Q27) Ratings given by customer for restaurants

 select 
 		      consumer_id,name restaurant_name,
          overall_rating,food_rating,service_rating
 from     Customer_Ratings cr
 join     restaurants r
 on       cr.Restaurant_ID=r.Restaurant_ID
 order by r.Restaurant_ID
 

--- Q28) Average ratings of each restaurant including it's cuisine type

select 
          name,cuisine,
          avg(overall_rating) overall_rating,
          avg(food_rating) food_rating,
          avg(service_rating) service_rating                                 
from      Customer_Ratings cr
join      restaurant_cuisines rc
on        cr.Restaurant_ID=rc.Restaurant_ID
join  	  restaurants r
on 	      r.Restaurant_ID=rc.Restaurant_ID
group by  name,cuisine
order by  name


--- Q29) Creating new columns for sentiment analysis

Alter TABLE Customer_Ratings add overall_sentiment varchar(50)
Alter TABLE Customer_Ratings add Food_sentiment varchar(50)
Alter TABLE Customer_Ratings add service_sentiment varchar(50)


--- Q30) Updating the new columns with the sentiments 

update Customer_Ratings
set 
	overall_sentiment=case when overall_rating=0 then 'Negative'
						             when overall_rating=1 then 'Neutral'
                         when overall_rating=2 then 'Positive'
                         end
where overall_sentiment is null

UPDATE Customer_Ratings                       
set
	food_sentiment   = case when food_rating=0 then 'Negative'
					              	when food_rating=1 then 'Neutral'
                    	    when food_rating=2 then 'Positive'
                    	    end 
where food_sentiment is null 
                   
UPDATE Customer_Ratings                       
set                     
service_sentiment= case when service_rating=0 then 'Negative'
						            when service_rating=1 then 'Neutral'
                        when service_rating=2 then 'Positive'
                        end 
where service_sentiment is null    


--- Q31) Conduct a sentimental analysis of total count of customers

with overall AS
(
 select   overall_sentiment,count(overall_sentiment) overall_count
 from 	  Customer_Ratings
 group by overall_sentiment
),
food AS
(
  select 
  		  food_sentiment,count(food_sentiment) food_count
 from 	  Customer_Ratings
 group by food_sentiment
 ),
 service AS
 ( 
   select 
   		     service_sentiment,count(service_sentiment) service_count
  from 	   Customer_Ratings
  group by service_sentiment
  )
  
select 
  	  overall_sentiment sentiment,
  	  overall_count as overall_rating,
      food_count as food_rating,
      service_count as service_rating
from  overall o
join  food f
 on   o.overall_sentiment=f.food_sentiment
join  service s
 on   s.service_sentiment=o.overall_sentiment

 
--- Q32) List of Customers visiting local or outside restaurants

select
  		   cd.Consumer_ID,
		     cd.city customer_city,
	       r.city restuarant_city,
         case when cd.city=r.City then 'Local' else 'Non_Local' end as Location_preference,
         count(case when cd.city=r.City then 'Local' else 'Non_Local' end) restaurants

from     Customer_Details cd
join     Customer_Ratings cr
on       cd.Consumer_ID=cr.Consumer_ID
join     restaurants r
on       r.Restaurant_ID=cr.Restaurant_ID
group by cd.Consumer_ID,cd.city ,
	       r.city ,case when cd.city=r.City then 'Local' else 'Non_Local' end 
order by consumer_id


--- Q33) Count of customers visiting local and outside restaurants

select
          case when cd.city=r.City then 'Local' else 'Non_Local' end as Location_preference,
          count(case when cd.city=r.City then 'Local' else 'Non_Local' end) customers_count
         
from      Customer_Details cd
join      Customer_Ratings cr
on        cd.Consumer_ID=cr.Consumer_ID
join      restaurants r
on        r.Restaurant_ID=cr.Restaurant_ID
group by  case when cd.city=r.City then 'Local' else 'Non_Local' end


--- Q34) Trend of customers visiting outside restaurants

select 
       cd.consumer_id customer_id,
	     cd.city customer_city,
       r.city restuarant_city,
       name restaurant_name,
       concat_ws('-',cd.City,r.city) direction
      
from   customer_details cd
join   Customer_Ratings cr
on     cd.Consumer_ID=cr.Consumer_ID
join   restaurants r
on     r.Restaurant_ID=cr.Restaurant_ID
where  (case when cd.city=r.City then 'Local' else 'Non_Local' end)='Non_Local'


--- Q35) Count of direction trend from above query


select 
		     direction,count(direction) total_customers
FROM
(
select  
         cd.consumer_id customer_id,
	       cd.city customer_city,
         r.city restuarant_city,
         name restaurant_name,
         concat_ws('-',cd.City,r.city) direction
from     customer_details cd
join     Customer_Ratings cr
on       cd.Consumer_ID=cr.Consumer_ID
join     restaurants r
on       r.Restaurant_ID=cr.Restaurant_ID
where    (case when cd.city=r.City then 'Local' else 'Non_Local' end)='Non_Local'
)  cte
group by direction       


--- Q36) Cuisine preferences vs cuisine consumed


select 
	        cd.consumer_id,
          r.Name restaurant_name,
          cuisine consumed_cuisine,
          string_agg(preferred_cuisine,',') cuisine_preferred
from      customer_ratings cr
join      customer_details cd
on   	    cr.Consumer_ID=cd.Consumer_ID
join	    restaurants r
on  	    cr.Restaurant_ID=r.Restaurant_ID
join 	    restaurant_cuisines rc
on  	    cr.Restaurant_ID=rc.Restaurant_ID
join      Customer_Preference cp
on        cp.Consumer_ID=cd.Consumer_ID
group by  cd.consumer_id,r.Name,cuisine
order by  consumer_id,consumed_cuisine


--- Q37) Best restaurants for each cuisines by different ratings


with x as  
( SELECT
	       r.name,cuisine,
         round(avg(food_rating),2) food_rating,
 	       round(avg(service_rating),2) service_rating,
 	       round(avg(overall_rating),2) overall_rating	  
from     restaurants r
join     restaurant_cuisines rc
on       r.Restaurant_ID=rc.Restaurant_ID
join     customer_ratings cr
on       cr.Restaurant_ID=r.Restaurant_ID
group by r.name,cuisine
)

select distinct cuisine,
  	   first_value(name) over(partition by cuisine order by overall_rating desc) best_overall,
  	   first_value(name) over(partition by cuisine order by food_rating desc) best_food,
  	   first_value(name) over(partition by cuisine order by service_rating desc) best_service
from   x
order by cuisine


--- Q38)  restaurants for each cuisines by different ratings


with x as  
( 
SELECT
	       r.name,cuisine,
         round(avg(food_rating),2) food_rating,
 	       round(avg(service_rating),2) service_rating,
 	       round(avg(overall_rating),2) overall_rating	  
from     restaurants r
join     restaurant_cuisines rc
on       r.Restaurant_ID=rc.Restaurant_ID
join     customer_ratings cr
on       cr.Restaurant_ID=r.Restaurant_ID
group by r.name,cuisine
)

select distinct cuisine,
  	   first_value(name) over(partition by cuisine order by overall_rating ) bad_overall,
  	   first_value(name) over(partition by cuisine order by food_rating ) bad_food,
  	   first_value(name) over(partition by cuisine order by service_rating ) bad_service
  
from   x
order by cuisine



--- Q39) Best cuisines by different ratings

with cte AS
(
SELECT
	       r.name,cuisine,
         round(avg(food_rating),2) food_rating,
 	       round(avg(service_rating),2) service_rating,
 	       round(avg(overall_rating),2) overall_rating	
from     restaurants r
join     restaurant_cuisines rc
on       r.Restaurant_ID=rc.Restaurant_ID
join     customer_ratings cr
on       cr.Restaurant_ID=r.Restaurant_ID
group by r.name,cuisine
)
select top 1
       first_value(cuisine) over( order by overall_rating desc) best_overall,
  	   first_value(cuisine) over( order by food_rating desc) best_food,
  	   first_value(cuisine) over( order by service_rating desc) best_service
from   cte



--- Q40) Total customers with highest ratings in all different criteria
 
 select 
      count(consumer_id) total_customers            
from  Customer_Ratings
where overall_rating=2
and   food_rating=2
and   service_rating=2;

