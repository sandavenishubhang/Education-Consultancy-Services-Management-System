-- which year generated highest revenue
-- this query is generate total amount of money earned by the firm is descending order
select year(bill_date) as year, sum(bill_amount) as total_revenue
from bill
group by  year(bill_date)
order by  total_revenue desc;

-- total number of applications all programs have in descending order, all universities combined
with temp as (select program_id, count(application_id) as total_applications
              from application
              group by program_id)
select distinct t.program_id, p.program_name, t.total_applications
from temp t, program p 
where t.program_id = p.program_id
order by t.total_applications desc;

-- -- total number of applications all universities have in descending order
with temp as (select university_id, count(application_id) as total_applications
              from application
              group by university_id)
select distinct t.university_id, u.university_name, t.total_applications
from temp t, university u 
where t.university_id = u.university_id
order by t.total_applications desc;

-- this query is used to find out to which country most number of students are applying 
-- (which country has the highest appllications)
with temp as (select university_id, count(application_id) as total_applications
              from application
              group by university_id)
select distinct u.country, sum(t.total_applications) as total
from temp t, university u 
where t.university_id = u.university_id
group by u.country
order by total desc;

-- total number of applications for each university

WITH TEMP AS (SELECT UNIVERSITY_ID, COUNT(APPLICATION_ID) AS TOTAL_APPLICATIONS
FROM APPLICATION
GROUP BY UNIVERSITY_ID)
SELECT DISTINCT T.UNIVERSITY_ID, U.UNIVERSITY_NAME, T.TOTAL_APPLICATIONS
FROM TEMP T, UNIVERSITY U
WHERE T.UNIVERSITY_ID = U.UNIVERSITY_ID
ORDER BY T.TOTAL_APPLICATIONS DESC;

-- This query is used to calculate the acceptance percentage for each university in ascending order
with temp_admitted as ( select university_id, count(authorize_decision) as total_admitted
						from application
                        where authorize_decision = "admitted"
                        group by university_id),
temp_rejected as ( select university_id, count(authorize_decision) as total_rejected
				   from application
                   where authorize_decision = "rejected"
                   group by university_id)
select u.university_id, u.university_name, 
	   (ta.total_admitted/(tr.total_rejected + ta.total_admitted))*100 as percentage
from university u, temp_admitted ta, temp_rejected tr
where u.university_id = ta.university_id and u.university_id = tr.university_id
order by percentage;

-- average number of applications submitted by each student each year

with temp as (select student_user_id, count(application_id) as total, year(start_date) as year
		      from application
              group by student_user_id, year(start_date))
select year, avg(total) as average
from temp
group by year;

-- acceptance percentage for each program
with temp_admitted as ( select program_id, count(authorize_decision) as total_admitted
						from application
                        where authorize_decision = "admitted"
                        group by program_id),
temp_rejected as ( select program_id, count(authorize_decision) as total_rejected
				   from application
                   where authorize_decision = "rejected"
                   group by program_id)
select distinct p.program_id, p.program_name, 
	   (ta.total_admitted/(tr.total_rejected + ta.total_admitted))*100 as percentage
from program p, temp_admitted ta, temp_rejected tr
where p.program_id = ta.program_id and p.program_id = tr.program_id
order by percentage;

-- total number of employees in each department

select d.department_name, ue.department_id, count(ue.user_id)
from user_employee ue, department d
where  ue.department_id = d.department_id
group by ue.department_id;

-- total number of fairs organised by each university

with temp as (select university_id, count(*) as total
              from fairs
              group by university_id)
select t.university_id, u.university_name, t.total
from temp t, university u
where t.university_id = u.university_id
order by t.total desc;

-- the query to get top 3 programs with 
-- highest number of applications and their university names 
with temp as (select u.university_name, p.program_name, 
					 count(a.application_id) as total_applications
              from application a, program p, university u
              where a.university_id = u.university_id 
					and a.university_id = p.university_id 
	                and p.program_id = a.program_id 
			  group by a.university_id,  a.program_id)
select t1.university_name, t1.program_name, t1.total_applications
from temp t1
where 3 > (SELECT COUNT(*)
			   FROM TEMP t2 
               WHERE t1.total_applications < t2.total_applications)
order by t1.total_applications desc;

--  create a view to see average gpa of admitted students for each program
CREATE VIEW AVG_GPA AS
SELECT U.UNIVERSITY_NAME, P.PROGRAM_NAME, AVG(US.GPA) AS AVERAGE_GPA
FROM APPLICATION A, UNIVERSITY U, USER_STUDENT US, PROGRAM P
WHERE A.UNIVERSITY_ID = U.UNIVERSITY_ID AND A.STUDENT_USER_ID = US.USER_ID
      AND A.PROGRAM_ID = P.PROGRAM_ID AND A.UNIVERSITY_ID = P.UNIVERSITY_ID
      AND A.authorize_decision = "admitted"
GROUP BY A.UNIVERSITY_ID, A.PROGRAM_ID;
-- THe query to get the top 3 programs and their university names
-- which have the highest average GPA SCORE of admitted students
select AG.university_name, AG.PROGRAM_NAME, AG.AVERAGE_GPA
from AVG_GPA AG
where 3 > (SELECT COUNT(*)
			   FROM AVG_GPA AG2 
               WHERE AG.AVERAGE_GPA < AG2.AVERAGE_GPA)
order by AG.AVERAGE_GPA desc;


-- THe query to get the top 3 programs and their university names
-- CREATING A VIEW TO CALCULATE AVERAGE GRE SCORE OF ADMITTED STUDENTS FOR ALL PROGRAMS
CREATE VIEW AVG_GRE AS
SELECT U.UNIVERSITY_NAME, P.PROGRAM_NAME, AVG(US.GRE) AS AVERAGE_GRE
FROM APPLICATION A, UNIVERSITY U, USER_STUDENT US, PROGRAM P
WHERE A.UNIVERSITY_ID = U.UNIVERSITY_ID AND A.STUDENT_USER_ID = US.USER_ID
      AND A.PROGRAM_ID = P.PROGRAM_ID AND A.UNIVERSITY_ID = P.UNIVERSITY_ID
      AND A.authorize_decision = "admitted"
GROUP BY A.UNIVERSITY_ID, A.PROGRAM_ID;
-- THe query to get the top 3 programs and their university names
-- which have the highest average GRE SCORE of admitted students
select AG.university_name, AG.PROGRAM_NAME, AG.AVERAGE_GRE
from AVG_GRE AG
where 3 > (SELECT COUNT(*)
			   FROM AVG_GRE AG2 
               WHERE AG.AVERAGE_GRE < AG2.AVERAGE_GRE)
order by AG.AVERAGE_GRE desc;

-- USED IN PRESENTATION

-- CREATE VIEW TO SHOW TOTAL NUMBER OF ADMITTED AND REJECTED STUDENTS FOR EACH PROGRAM
CREATE VIEW ADMIT_REJECT AS
SELECT program_id, university_id, 
	   COUNT(IF(AUTHORIZE_DECISION = 'ADMITTED', 1, NULL)) AS TOTAL_ADMIT,
       COUNT(IF(AUTHORIZE_DECISION = 'REJECTED', 1, NULL)) AS TOTAL_REJECT
FROM application
group by program_id, university_id;
-- TOP 5 PROGRAMS WITH THE LOWEST ACCEPTANCE PERCENTAGE
SELECT U.UNIVERSITY_NAME, PROGRAM_NAME, 
       (TOTAL_ADMIT/(TOTAL_ADMIT+TOTAL_REJECT))*100 AS PERCENTAGE
FROM ADMIT_REJECT AR, PROGRAM P, university U
WHERE AR.program_id = P.program_id AND AR.university_id = P.university_id 
	  AND U.university_id = P.university_id
ORDER BY PERCENTAGE LIMIT 5;

-- CREATE VIEW TO FIND THE TOTAL NUMBER OF APPLICATION RECEIVED FOR EACH PROGRAM
CREATE VIEW NUMBER_OF_APPLICATIONS AS
select u.university_name, p.program_name, count(a.application_id) as total_applications
from application a, program p, university u
where a.university_id = u.university_id and a.university_id = p.university_id 
	  and p.program_id = a.program_id 
group by a.university_id,  a.program_id;
-- the query to get top 3 programs with 
-- highest number of applications and their university names 
select NOA.university_name, NOA.program_name, NOA.total_applications
from NUMBER_OF_APPLICATIONS NOA
where 3 > (SELECT COUNT(*)
			   FROM NUMBER_OF_APPLICATIONS NOA2 
               WHERE NOA.total_applications < NOA2.total_applications)
order by NOA.total_applications desc;