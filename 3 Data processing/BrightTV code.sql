--- QUERIES UNDER VIEWSHIP

SELECT * FROM `workspace`.`viewships`.`viewiship` 
limit 100;


--------CHECK HOW MANY USERID DO WE HAVE
SELECT COUNT( DISTINCT Userid) AS total_users
FROM `workspace`.`viewships`.`viewiship`;


-------WHEN WAS THE FIRST RECORD(2016-01-01)
SELECT RecordDate2 AS first_record
FROM `workspace`.`viewships`.`viewiship`
ORDER BY recorddate2 ASC
LIMIT 1;


------WHEN WAS THE LAST RECORD(2016_03_31)
SELECT RecordDate2 AS first_record
FROM `workspace`.`viewships`.`viewiship`
ORDER BY recorddate2 DESC
LIMIT 1;


----CHECK WHATCHANNEL2 DO WE HAVE
SELECT DISTINCT Channel2 
FROM `workspace`.`viewships`.`viewiship`;


-----CHECK HOW MANY CHANNELS DO WE HAVE(21)
SELECT COUNT(DISTINCT Channel2) AS total_channels
FROM `workspace`.`viewships`.`viewiship`;


-----CHECK TOTAL CHANNELS PER MONTH

 SELECT count(DISTINCT Channel2) AS total_channels,
date_format(recorddate2, 'MMMM') AS Month_name
from `workspace`.`viewships`.`viewiship`
group by month_name;


----CHECKING THE DUBLICATES
SELECT 
    userid, 
    recorddate2, 
    channel2, 
    COUNT(*) as record_count
FROM `workspace`.`viewships`.`viewiship`
GROUP BY userid, 
         recorddate2, 
         channel2
HAVING COUNT(*) > 1
ORDER BY record_count DESC;


----------ANOTHER TABLE

SELECT * 
FROM `workspace`.`user_profiles`.`user_profils`
limit 100;


-----------CHECKING WHAT KINDA OF DATA TYPE WE HAVE
describe `workspace`.`user_profiles`.`user_profils`;


---------CHECKING HOW MANY MALE WE HAVE(3918)
SELECT COUNT(*) AS total_males
FROM `workspace`.`user_profiles`.`user_profils`
WHERE gender = 'male';
 

--------CHECKING HOW MANY FEMALE WE HAVE(537)
SELECT COUNT(*) AS total_males
FROM `workspace`.`user_profiles`.`user_profils`
WHERE gender = 'female';
 

-------CHECKING HOW MANY RACE WE GOT
SELECT COUNT(DISTINCT Race) AS number_of_races
FROM `workspace`.`user_profiles`.`user_profils`;


---------CHECKING HOW MANY 

SELECT 
    Race, 
    COUNT(*) AS Total_Users,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS Percentage_of_Base
FROM `workspace`.`user_profiles`.`user_profils`
GROUP BY Race
ORDER BY Total_Users DESC;


------CHECKING HOW MANY WHITE PEOPLE WE HAVE 760 
SELECT COUNT(*) AS total_white_people 
FROM `workspace`.`user_profiles`.`user_profils`
WHERE Race = 'white';
 

                
   

    

----------------------Master Code---------------------


    SELECT 
    A.UserID,
    
    -- Combines all unique channels watched into a single row cell
    array_join(collect_set(A.Channel2), ', ') AS Channels_Watched,
    COUNT(A.Channel2) AS Total_Sessions_Logged,

    B.Province,
    COALESCE(B.Gender, 'Unknown') AS Gender,
    COALESCE(B.Race, 'Unknown') AS Race,

    CASE 
        WHEN B.Age < 20 THEN 'Teen'
        WHEN B.Age BETWEEN 20 AND 35 THEN 'Young Adult'
        WHEN B.Age BETWEEN 36 AND 55 THEN 'Mid-Age'
        WHEN B.Age > 55 THEN 'Senior'
        ELSE 'Unknown'
    END AS Age_Category,

    CASE 
        WHEN B.Province IN ('Gauteng', 'Western Cape', 'KwaZulu Natal') THEN 'Major Hub'
        WHEN B.Province IN ('Limpopo', 'Mpumalanga', 'North West') THEN 'Inland Cluster'
        WHEN B.Province IN ('Eastern Cape', 'Free State', 'Northern Cape') THEN 'Regional Cluster'
        ELSE 'Unknown'
    END AS Market_Segment

FROM `workspace`.`viewships`.`viewiship` A
LEFT JOIN `workspace`.`user_profiles`.`user_profils` B 
    ON A.USERID = B.USERID
GROUP BY 
    A.UserID, 
    B.Province, 
    B.Gender, 
    B.Race, 
    B.Age
