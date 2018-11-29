-- 1

SELECT DISTINCT dept_name
FROM instructor;

-- 2

SELECT dept_name
FROM instructor;

-- 3

SELECT *
FROM instructor;

-- 4

SELECT ID,
       name,
       dept_name,
       round(salary/12) monthly_wage
FROM instructor;

-- 5

SELECT name
FROM instructor
WHERE salary > 80000
  AND dept_name='Comp. Sci.';

-- 6

SELECT *
FROM teaches,
     instructor;

-- 7

SELECT DISTINCT name,
                course_id
FROM teaches
LEFT JOIN instructor ON teaches.id = instructor.id;

-- 8

SELECT DISTINCT course.course_id,
                semester,
                YEAR,
                title
FROM course
LEFT JOIN teaches ON course.course_id = teaches.course_id
WHERE dept_name='Comp. Sci.';

-- 9

SELECT *
FROM teaches
NATURAL JOIN instructor;

-- 10

SELECT name,
       course_id
FROM teaches
NATURAL JOIN instructor;

-- 11

SELECT ID,
       name,
       round(salary/12) monthly_salary
FROM instructor;

-- 12

SELECT name
FROM instructor
WHERE salary >
    (SELECT salary
     FROM instructor
     WHERE name = 'Katz');

-- 13

SELECT name
FROM instructor
WHERE name LIKE '%ai%';

-- 14

SELECT name
FROM instructor
WHERE name LIKE '%ai\%%';
 
-- 15
SELECT name
FROM instructor
WHERE name LIKE '%ai\%%' OR length(name) = 3 ;
-- 16

SELECT name
FROM instructor
ORDER BY name;

-- 17

SELECT name
FROM instructor
ORDER BY name DESC;

-- 18

SELECT name,
       dept_name
FROM instructor
ORDER BY name,
         dept_name;

-- 19

SELECT name
FROM instructor
WHERE salary BETWEEN 90000 AND 100000;

-- 20

SELECT name,
       title
FROM instructor
LEFT JOIN teaches ON instructor.ID = teaches.ID
LEFT JOIN course ON teaches.course_id = course.course_id
WHERE course.dept_name='Biology';

-- 21

SELECT course.course_id,
       title
FROM teaches
LEFT JOIN course ON teaches.course_id = course.course_id
WHERE semester ='Fall'
  AND YEAR=2009;

-- 22

SELECT course.course_id,
       title
FROM teaches
LEFT JOIN course ON teaches.course_id = course.course_id
WHERE (semester ='Fall'
       AND YEAR=2009)
  OR (semester ='Spring'
      AND YEAR=2010)
HAVING count(*) > 1;