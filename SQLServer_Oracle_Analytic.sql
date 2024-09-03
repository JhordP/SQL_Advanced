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

--Shows how much child born by year.
SELECT A.*, COUNT(*) OVER (PARTITION BY A.gender, year(birthdate)) chd_yr
FROM CHILDSTAT A ORDER BY A.gender, A.birthdate;

--Separate by gender the number of each row
SELECT A.*, ROW_NUMBER() OVER (PARTITION BY A.gender ORDER BY A.firstname) RNUM
    FROM CHILDSTAT A

--LEAD AND LAG
SELECT A.firstname, A.weight,
LEAD(A.weight,1,-1) OVER (PARTITION BY A.gender ORDER BY A.weight) AS LEAD_1_WT,
LAG(A.weight,2,-1) OVER (PARTITION BY A.gender ORDER BY A.weight) AS LAG_2_WT
FROM CHILDSTAT A ORDER BY A.gender, A.weight;

--RANK/DENSE_RANK
--Rank creates a ranking, and if 2 or more are tied, it skips those rankings(1,1,3,4...); Dense Rank does not skip that (1,1,2,3...)
SELECT A.firstname, A.gender, A.height,
RANK() OVER (PARTITION BY A.gender ORDER BY A.height) AS HT_RANK,
DENSE_RANK() OVER (PARTITION BY A.gender ORDER BY A.height) AS HT_DRANK
FROM CHILDSTAT A ORDER BY A.gender, A.height;

--FIRST AND LAST VALUES
SELECT A.firstname, A.gender, A.height,
FIRST_VALUE(A.firstname) OVER (PARTITION BY A.gender ORDER BY A.weight) AS LT_CHILD,
LAST_VALUE(A.firstname) OVER (PARTITION BY A.gender ORDER BY A.weight) AS HV_CHILD --This column is incorrect, it needs a windows clause.
FROM CHILDSTAT A ORDER BY A.gender, A.weight;

-----JUST WORKS ON ORACLE-------
--shows how much distinct heights per gender.
SELECT A.*, COUNT(DISTINCT A.height) OVER (PARTITION BY A.gender) AS dist_ht FROM CHILDSTAT A
ORDER BY gender;

--You can avoid the PARTITION clause, then it will analyze within the whole table instead of partitioning it.
SELECT A.*, COUNT(*) OVER () AS dist_gnd  FROM CHILDSTAT A; 

--Gives how much proportion of weight by gender each one covers
SELECT A.*, 100*RATIO_TO_REPORT(WEIGHT) OVER (PARTITION BY A.GENDER) AS PCT_WEIGHT_byGND FROM CHILDSTAT A;

--Shows how much child born by year.
SELECT A.*, COUNT(*) OVER (PARTITION BY A.gender, EXTRACT(year from birthdate))
FROM CHILDSTAT A ORDER BY A.gender, A.birthdate;

--Comes with a list of names ordered by height for each gender (From heavy to light)
SELECT A.firstname, A.gender, A.height, A.weight,
	LISTAGG(A.firstname, ', ') WITHIN GROUP (ORDER BY A.weight DESC)
	OVER (PARTITION BY A.gender) AS Namelist
	FROM CHILDSTAT A