/*CREATE TABLE CHILDSTAT ( 
firstname varchar(30) 
,gender char 
,birthdate date 
,height float 
,weight float 
)
SELECT * FROM CHILDSTAT ORDER BY GENDER, FIRSTNAME
*/
--INSERT INTO CHILDSTAT(firstname, gender, birthdate, height, weight) VALUES 
--('Lauren', 'F', '10-JUN-00', 54, 876) 
--('Rosemary', 'F', '08-MAY-00', 35, 123) 
--('Albert', 'M', '02-AUG-00', 45, 150) 
--('Buddy', 'M', '02-OCT-98', 45, 189) 
--('Farquar', 'M', '05-NOV-98', 76, 198) 
--('Simon', 'M', '03-JAN-99', 87, 256) 
--('Tommy', 'M', '11-DEC-98', 78, 167)

CREATE TABLE CHILDSTAT_COUNT_BY_GENDER AS 
SELECT gender, COUNT(gender) quantity FROM CHILDSTAT GROUP BY gender

SELECT * FROM CHILDSTAT_COUNT_BY_GENDER

------------------------------------------------------------------------
--AGGREGATE (COUNT)
SELECT A.*, B.quantity
FROM CHILDSTAT A INNER JOIN CHILDSTAT_COUNT_BY_GENDER B
ON A.gender = B.gender;
--VS
--ANALYTIC (COUNT)
SELECT A.*, COUNT(*) OVER (PARTITION BY A.gender) AS quantity  FROM CHILDSTAT A
