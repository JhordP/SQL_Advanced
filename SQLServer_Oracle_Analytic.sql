/*
SYNTAX: function() OVER (PARTITION BY col1, col2,...)
*/

------------------------------------------------------------------------
--AGGREGATE (COUNT)
SELECT A.*, B.quantity
FROM CHILDSTAT A INNER JOIN CHILDSTAT_COUNT_BY_GENDER B
ON A.gender = B.gender;

SELECT gender, COUNT(gender) quantity INTO CHILDSTAT_COUNT_BY_GENDER FROM CHILDSTAT GROUP BY gender
SELECT * FROM CHILDSTAT_COUNT_BY_GENDER;

SELECT SUM(weight) AS sum_weight, gender FROM CHILDSTAT GROUP BY gender
--VS
--ANALYTIC (COUNT)
SELECT A.*, COUNT(*) OVER (PARTITION BY A.gender) AS quantity  FROM CHILDSTAT A;

--Sums by weight accumulating by gender
SELECT A.gender, A.firstname, A.weight, 
SUM(A.weight) OVER (PARTITION BY A.gender ORDER BY A.weight) AS sum_weight
FROM CHILDSTAT A ORDER BY A.gender, A.weight;

--Takes the max height and attach it to everybody by its gender (?)
SELECT A.*, MAX(A.height) OVER (PARTITION BY A.gender) AS mx_ht FROM CHILDSTAT A

SELECT A.*, COUNT(*) OVER (PARTITION BY A.gender, year(birthdate))
FROM CHILDSTAT A ORDER BY A.gender, A.birthdate;

-----JUST WORKS ON ORACLE-------
--shows how much distinct heights per gender.
SELECT A.*, COUNT(DISTINCT A.height) OVER (PARTITION BY A.gender) AS dist_ht FROM CHILDSTAT A
ORDER BY gender;

--You can avoid the PARTITION clause, then it will analyze within the whole table instead of partitioning it.
SELECT A.*, COUNT(*) OVER () AS dist_gnd  FROM CHILDSTAT A; 

--Gives how much proportion of weight by gender each one covers
SELECT A.*, 100*RATIO_TO_REPORT(WEIGHT) OVER (PARTITION BY A.GENDER) AS PCT_WEIGHT_byGND FROM CHILDSTAT A;

SELECT A.*, COUNT(*) OVER (PARTITION BY A.gender, EXTRACT(year from birthdate))
FROM CHILDSTAT A ORDER BY A.gender, A.birthdate;