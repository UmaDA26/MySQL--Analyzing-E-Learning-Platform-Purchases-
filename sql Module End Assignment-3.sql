DROP DATABASE IF EXISTS Online_Course_DB;
CREATE DATABASE Online_Course_DB;
USE Online_Course_DB;

-- Learners Table
CREATE TABLE learners (
    learner_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL
);

-- Courses table
CREATE TABLE courses (
course_id INT PRIMARY KEY AUTO_INCREMENT,
course_name VARCHAR(70) NOT NULL,
category VARCHAR(50) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL
);

-- purchase table
CREATE TABLE purchases(
purchase_id INT PRIMARY KEY AUTO_INCREMENT,
 learner_id INT,
 course_id INT,
 quantity INT NOT NULL,
 purchase_date DATE NOT NULL,
 FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
 FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
 
 INSERT INTO learners (full_name, country)
VALUES
('Uma Senya ', 'India'),
('Arun Kumar', 'India'),
('Sarah Johnson', 'USA'),
('David Smith', 'UK'),
('Meera Patel', 'India');

INSERT INTO courses (course_name, category, unit_price)
VALUES
('Python for Data Analysis', 'Beginner', 2500.00),
('SQL for Beginners', 'Beginner', 1800.00),
('Power BI Dashboard', 'Intermediate', 3000.00),
('Excel for Data Analysis', 'Beginner', 1500.00),
('Machine Learning Basics', 'Advanced', 4000.00);

INSERT INTO purchases (learner_id, course_id, quantity, purchase_date)
VALUES
(1, 1, 1, '2026-01-10'),
(1, 3, 1, '2026-02-15'),
(2, 2, 2, '2026-01-20'),
(3, 5, 1, '2026-03-05'),
(4, 4, 3, '2026-02-10'),
(5, 1, 1, '2026-03-15'),
(3, 3, 2, '2026-04-01'),
(2, 5, 1, '2026-04-10');

-- inner join
SELECT
    l.full_name AS Learner_Name,
    c.course_name AS Course_Name,
    c.category AS Category,
    p.quantity AS Quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS Total_Amount,
    p.purchase_date AS Purchase_Date

FROM purchases p
INNER JOIN learners l
    ON p.learner_id = l.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id

ORDER BY (p.quantity * c.unit_price) DESC;

-- left join
SELECT
    l.full_name AS Learner_Name,
    c.course_name AS Course_Name,
    c.category AS Category,
    p.quantity AS Quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS Total_Amount,
    p.purchase_date AS Purchase_Date

FROM learners l
LEFT JOIN purchases p
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id

ORDER BY (p.quantity * c.unit_price) DESC;

-- right join
SELECT
    l.full_name AS Learner_Name,
    c.course_name AS Course_Name,
    c.category AS Category,
    p.quantity AS Quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS Total_Amount,
    p.purchase_date AS Purchase_Date

FROM purchases p
RIGHT JOIN courses c
    ON p.course_id = c.course_id
LEFT JOIN learners l
    ON p.learner_id = l.learner_id

ORDER BY (p.quantity * c.unit_price) DESC;

-- 3. Core Analytical Queries 

-- Q1. Display each learner’s total spending with their country.

SELECT 
    l.full_name AS Learner_Name,
    l.country AS Country,
    SUM(p.quantity * c.unit_price) AS Total_Spending
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
ORDER BY Total_Spending DESC;

-- Q2. Find the top 3 most purchased courses by quantity

SELECT 
    c.course_name AS Course_Name,
    SUM(p.quantity) AS Total_Quantity
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name
ORDER BY Total_Quantity DESC
LIMIT 3;

-- Q3. Show each category's total revenue and number of unique learners
SELECT 
    c.category AS Category,
    SUM(p.quantity * c.unit_price) AS Total_Revenue,
    COUNT(DISTINCT p.learner_id) AS Unique_Learners
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY Total_Revenue DESC;

-- Q4. List learners who purchased from more than one category
SELECT 
    l.full_name AS Learner_Name,
    COUNT(DISTINCT c.category) AS Number_of_Categories
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

-- Q5. Identify courses never purchased
SELECT 
    c.course_name AS Course_Name,
    c.category AS Category
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;

-- Q6. Find learners whose total spending is above the average learner spending.

SELECT * FROM
(
    SELECT
        l.learner_id,
        l.full_name AS Learner_Name,
        SUM(p.quantity * c.unit_price) AS Total_Spending
    FROM learners l
    INNER JOIN purchases p
        ON l.learner_id = p.learner_id
    INNER JOIN courses c
        ON p.course_id = c.course_id
    GROUP BY l.learner_id, l.full_name
) AS learner_spending
WHERE Total_Spending >
(
    SELECT AVG(Total_Spending)
    FROM
    (
        SELECT
            SUM(p.quantity * c.unit_price) AS Total_Spending
        FROM purchases p
        INNER JOIN courses c
            ON p.course_id = c.course_id
        GROUP BY p.learner_id
    ) AS average_spending
);

-- Q7. Display courses whose price is higher than any course in the ‘Beginner’ category

SELECT
    course_name AS Course_Name,
    category AS Category,
    unit_price AS Unit_Price
FROM courses
WHERE unit_price > ANY
(
    SELECT unit_price
    FROM courses
    WHERE category = 'Beginner'
);

-- Q8 . Find learners who spent more than the average spending in their country.

SELECT
    l.full_name AS Learner_Name,
    l.country AS Country,
    SUM(p.quantity * c.unit_price) AS Total_Spending
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
HAVING SUM(p.quantity * c.unit_price) >
(
    SELECT AVG(country_spending.Total_Spending)
    FROM
    (
        SELECT
            l2.learner_id,
            l2.country,
            SUM(p2.quantity * c2.unit_price) AS Total_Spending
        FROM learners l2
        INNER JOIN purchases p2
            ON l2.learner_id = p2.learner_id
        INNER JOIN courses c2
            ON p2.course_id = c2.course_id
        GROUP BY l2.learner_id, l2.country
    ) AS country_spending
    WHERE country_spending.country = l.country
);

-- Q9. Use a CTE to calculate total spending per learner, then:
-- Display learners with spending above 10,000.

WITH learner_spending AS
(
    SELECT
        l.learner_id,
        l.full_name AS Learner_Name,
        l.country AS Country,
        SUM(p.quantity * c.unit_price) AS Total_Spending
    FROM learners l
    INNER JOIN purchases p
        ON l.learner_id = p.learner_id
    INNER JOIN courses c
        ON p.course_id = c.course_id
    GROUP BY l.learner_id, l.full_name, l.country
)

SELECT * FROM learner_spending
WHERE Total_Spending > 10000;

-- Q10. CASE Expression
-- Classify learners based on spending:
-- ● Above 15,000 → “High Value”,
-- ● 8,000–15,000 → “Medium Value”,
-- ● Below 8,000 → “Low Value”.

WITH learner_spending AS
(
    SELECT
        l.learner_id,
        l.full_name AS Learner_Name,
        l.country AS Country,
        SUM(p.quantity * c.unit_price) AS Total_Spending
    FROM learners l
    INNER JOIN purchases p
        ON l.learner_id = p.learner_id
    INNER JOIN courses c
        ON p.course_id = c.course_id
    GROUP BY l.learner_id, l.full_name, l.country
)

SELECT
    Learner_Name,
    Country,
    Total_Spending,

    CASE
        WHEN Total_Spending > 15000 THEN 'High Value'
        WHEN Total_Spending >= 8000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Learner_Category

FROM learner_spending
ORDER BY Total_Spending DESC;

-- Q11. NULL Handling

-- Display all courses and replace courses with no purchases with 0.

SELECT 
    c.course_name,
    COALESCE(COUNT(p.purchase_id), 0) AS purchase_count
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name;

-- Q12. Create View: category_performance_view

CREATE VIEW category_performance_view AS
SELECT 
    c.category,
    SUM(p.quantity * c.unit_price) AS total_revenue,
    COUNT(p.purchase_id) AS number_of_purchases,
    AVG(p.quantity * c.unit_price) AS average_revenue_per_purchase
FROM courses c
JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category;

SELECT * FROM category_performance_view;




 
 
 
 
 
 
 

