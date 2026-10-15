-- Drop existing tables
DROP TABLE IF EXISTS rides;
DROP TABLE IF EXISTS drivers;
DROP TABLE IF EXISTS users;

-- USERS
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50),
    registration_date DATE,
    age INT CHECK(age >= 18),
    gender VARCHAR(20),
    location VARCHAR(150)
);

-- DRIVERS
CREATE TABLE drivers (
    driver_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    vehicle_id INT,
    rating NUMERIC(3,2) CHECK(rating BETWEEN 1 AND 5),
    total_rides INT DEFAULT 0 CHECK(total_rides >= 0),
    available BOOLEAN
);

-- RIDES
CREATE TABLE rides (
    ride_id INT PRIMARY KEY,

    user_id INT NOT NULL,

    driver_id INT NOT NULL,

    start_location VARCHAR(150),

    end_location VARCHAR(150),

    ride_start_time TIMESTAMP,

    ride_end_time TIMESTAMP,

    ride_date DATE,

    ride_hour INT,

    day_name VARCHAR(20),

    month_number INT,

    month_name VARCHAR(20),

    quarter INT,

    year INT,

    weekend_flag BOOLEAN,

    time_slot VARCHAR(30),

    distance_km NUMERIC(8,2),

    ride_duration_minutes NUMERIC(8,2),

    fare_amount NUMERIC(10,2),

    fare_per_km NUMERIC(8,2),

    trip_category VARCHAR(30)

);

-- Q1: Top 10 Drivers by Revenue and Number of Rides
select 
d.driver_id,
d.name as driver_name,
d.rating,
count(r.ride_id) as total_rides_completed,
round(sum(r.fare_amount),2) as total_revenue,
round(avg(r.fare_amount),2) as average_fare
from drivers d
join rides r 
on d.driver_id = r.driver_id
group by d.driver_id, d.name, d.rating
order by total_revenue desc, total_rides_completed desc
limit 10

-- Q2: Top 10 Customers by Lifetime Spending
SELECT
    u.user_id,
    u.name AS customer_name,
    COUNT(r.ride_id) AS total_rides,
    ROUND(SUM(r.fare_amount),2) AS total_spending,
    ROUND(AVG(r.fare_amount),2) AS average_fare
FROM users u
JOIN rides r
ON u.user_id = r.user_id
GROUP BY
u.user_id,
u.name
ORDER BY total_spending DESC
LIMIT 10;

-- Q3: Most Popular Routes
SELECT
    start_location,
    end_location,
	COUNT(*) AS total_rides,
	ROUND(SUM(fare_amount),2) AS total_revenue
FROM rides
GROUP BY
 start_location,
 end_location
ORDER BY total_rides DESC
LIMIT 10;

-- Q4: Peak Ride Demand by Time Slot
select 
time_slot,
count(*) as total_rides,
round(Sum(fare_amount),2) as total_revenue
from rides
group by time_slot
order by total_revenue desc

-- Q5: Revenue by Day of Week
select day_name,
count(*) as total_rides,
round(sum(fare_amount),2) as total_revenue
from rides
group by day_name
order by total_revenue desc

--Q6: Ride demand by Age Group
select 
case 
    when age < 25 then 'under 25'
	when age between 25 and 34 then '25-34'
	when age between 35 and 44 then '35-44'
	when age between 45 and 54 then '45-54'
	else '55+'
end as age_group,
count(r.ride_id) as total_rides,
round(sum(r.fare_amount),2) as total_revenue
from users u 
join rides r
on u.user_id = r.user_id
group by age_group
order by total_rides desc

-- Q7: Weekend vs Weekday Analysis
SELECT
CASE
    WHEN weekend_flag = TRUE THEN 'Weekend'
    ELSE 'Weekday'
END AS day_type,
COUNT(*) AS total_rides,
ROUND(SUM(fare_amount),2) AS total_revenue,
ROUND(AVG(fare_amount),2) AS average_fare
FROM rides
GROUP BY day_type
ORDER BY total_revenue DESC;

-- Q8: Top Pickup Locations
SELECT
start_location,
COUNT(*) AS total_rides,
ROUND(SUM(fare_amount),2) AS total_revene
FROM rides
GROUP BY start_location
ORDER BY total_rides DESC
LIMIT 10;

-- Q9: Trip Category Analysis
SELECT
trip_category,
COUNT(*) AS total_rides,
ROUND(AVG(distance_km),2) AS average_distance,
ROUND(AVG(ride_duration_minutes),2) AS average_duration,
ROUND(SUM(fare_amount),2) AS total_revenue
FROM rides
GROUP BY trip_category
ORDER BY total_revenue DESC;

-- Q10: Drivers with Above Average Rating
WITH average_rating AS (
SELECT AVG(rating) AS avg_rating
FROM drivers
)
SELECT
d.driver_id,
d.name,
d.rating,
d.total_rides
FROM drivers d
CROSS JOIN average_rating a
WHERE d.rating > a.avg_rating
ORDER BY d.rating DESC, d.total_rides DESC 
LIMIT 10;

-- Q11: Rank Drivers by Total Revenue
WITH driver_revenue AS (
    SELECT
        d.driver_id,
        d.name,
        COUNT(r.ride_id) AS total_rides,
        ROUND(SUM(r.fare_amount),2) AS total_revenue
    FROM drivers d
    JOIN rides r
    ON d.driver_id = r.driver_id
    GROUP BY d.driver_id, d.name
)
SELECT
driver_id,
name,
total_rides,
total_revenue,
RANK() OVER(ORDER BY total_revenue DESC) AS revenue_rank
FROM driver_revenue
LIMIT 10;

-- Q12: Top Customer in Each Location
WITH customer_spending AS (
SELECT
u.user_id,
u.name,
u.location,
ROUND(SUM(r.fare_amount),2) AS total_spending
FROM users u
JOIN rides r
ON u.user_id = r.user_id
GROUP BY
u.user_id,
u.name,
u.location
)
SELECT *
FROM (
SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY location
ORDER BY total_spending DESC
) AS rank
FROM customer_spending
) t
WHERE rank = 1;

-- Q13: Month-over-Month Revenue Comparison
WITH monthly_revenue AS (
SELECT
year,
month_number,
ROUND(SUM(fare_amount),2) AS total_revenue
FROM rides
GROUP BY
year,
month_number
)
SELECT
year,
month_number,
total_revenue,
LAG(total_revenue) OVER(
ORDER BY year, month_number
) AS previous_month_revenue,
ROUND(
total_revenue
-
LAG(total_revenue) OVER(
ORDER BY year, month_number
)
,2) AS revenue_difference
FROM monthly_revenue
ORDER BY
year,
month_number;

-- Q14: Running Total Revenue
WITH monthly_revenue AS (
SELECT
year,
month_number,
ROUND(SUM(fare_amount),2) AS monthly_revenue
FROM rides
GROUP BY
year,
month_number
)
SELECT
year,
month_number,
monthly_revenue,
SUM(monthly_revenue)
OVER(
ORDER BY year, month_number
) AS cumulative_revenue
FROM monthly_revenue;

-- Q15: Rank Pickup Locations
WITH pickup_summary AS (
SELECT
start_location,
COUNT(*) AS total_rides,
ROUND(SUM(fare_amount),2) AS total_revenue
FROM rides
GROUP BY start_location
)
SELECT
start_location,
total_rides,
total_revenue,
DENSE_RANK()
OVER(
ORDER BY total_rides DESC
) AS location_rank
FROM pickup_summary;
