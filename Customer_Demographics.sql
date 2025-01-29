--- Title :-        Restaurant Ratings Analysis
--- Created by :-   Dharmateja
--- Tool Used :-    MS SQL Server

/*
𝗜𝗻𝘁𝗿𝗼𝗱𝘂𝗰𝘁𝗶𝗼𝗻:
► In this project, we will be analyzing restaurant ratings data to gain insights into the performance of various restaurants.
► We will use SQL to extract, transform and analyze the data.
► The insights gained from this analysis will be used to understand the factors that influence a restaurant's rating and make recommendations for improvement.
► We will examine the relationship between different variables such as the location, cuisine and price range of the restaurants and their ratings.
► We will also do sentiment analysis to analyze most favorable restaurants of customers

𝗙𝗶𝗹𝗲𝗻𝗮𝗺𝗲: 𝗖𝘂𝘀𝘁𝗼𝗺𝗲𝗿 𝗗𝗲𝗺𝗼𝗴𝗿𝗮𝗽𝗵𝗶𝗰𝘀 𝗔𝗻𝗮𝗹𝘆𝘀𝗶𝘀

This SQL queries analyzes the customers & their cuisines preferences. This helps to understand the types of customers & their preferences.
*/


---Q1 Total customers in each state 

select 
      state,count(consumer_id) Total_customers
from 	 Customer_Details
group by state
order by Total_customers desc

	
---Q2 Total customers in each city

select city ,count(consumer_id) Total_customers
from Customer_Details
group by city 
order by Total_customers desc

	
--- Q3) Budget level of customers

select budget,count(budget)Total_customers
from Customer_Details
where budget is not null and budget!=' '
group by budget
order by Total_customers desc

	
--- Q4) Total Smokers by Occupation

select occupation,count(consumer_id) Total_smokers
from Customer_Details
where smoker='Yes'
group by occupation
	

--- Q5) Drinking level of students

select drink_level,count(drink_level) students_count
from Customer_Details
where occupation='student'
group by drink_level

	
--- Q6) Transportation methods of customers

select transportation_method,count(consumer_id) Total_Customers
from Customer_Details
where  transportation_method!=''
group by transportation_method
order by total_customers desc
	

--- Q7) Adding Age Bucket Column 

Alter table Customer_Details
add age_category varchar(50)
	

--- Q8) Updating the age_category column with case when condition
update Customer_Details
set age_category=case when age>60 then '61-above'
					when age>40 then '41-60'
                    when age>25 then '26-40'
                    when age>=18 then '18-25'
                    end
     where age_category is null

	
 --- Q9) Total customers in each age_category
 
 select age_category,count(consumer_id) Total_customers
 from Customer_Details
 group by age_category
order by total_customers DESC

	
--- Q10) Total customers count & smokers count in each age percent 

select age_category,count(consumer_id) total_customers,
       sum(case when smoker='Yes' then 1 else 0 end) smokers_count
from Customer_Details
group by age_category
order by age_category


--- Q11) Top 10 preferred cuisines

select
	 top 10 preferred_cuisine,count(consumer_id) cuisine_count
from 	 Customer_Preference
group by preferred_cuisine
order by cuisine_count desc
	

--- Q12) Preferred cuisines of each customer

select consumer_id,
	   count(preferred_cuisine) cuisine_count,
       string_agg(preferred_cuisine,',') cuisines
from   Customer_Preference
group by consumer_id
order by cuisine_count desc


--- Q13) Customer Budget analysis for each cuisine

select preferred_cuisine,
	sum(case when budget='low' then 1 else 0 end) low_budget,
	sum(case when budget='Medium' then 1 else 0 end) Medium_budget,
	sum(case when budget='High' then 1 else 0 end) High_budget

from 	Customer_Details cd
join 	Customer_Preference cp
on   	cd.Consumer_ID=cp.Consumer_ID
join 	restaurant_cuisines rc
on   	rc.Cuisine=cp.Preferred_Cuisine
group by preferred_cuisine


--- Q14) Finding out count of each cuisine in each state

select 
	 state,cuisine,count(cuisine) total_cuisines
from 	 restaurants r
join 	 restaurant_cuisines rc
on  	 r.Restaurant_ID=rc.Restaurant_ID
group by state,cuisine
order by total_cuisines desc


--- Q15) Finding out count of each cuisine in each age bucket

select
   preferred_cuisine,
       sum(case when age_category='18-25' then 1 else 0 end) '18-25',
       sum(case when age_category='26-40' then 1 else 0 end) '26-40',
       sum(case when age_category='41-60' then 1 else 0 end) '41-60',
       sum(case when age_category='61-above' then 1 else 0 end) '61+'   

from 	 Customer_Details cd
join 	 Customer_Preference cp
on 	 cd.Consumer_ID=cp.Consumer_ID
group by preferred_cuisine
order by preferred_cuisine


