# MySQL--Analyzing-E-Learning-Platform-Purchases-

# Online Course Database Analysis

## 📌 Project Overview

This project demonstrates SQL concepts using an **Online Course Database**. The database contains information about learners, courses, and course purchases.

The project focuses on analyzing learner spending, course purchases, category performance, and revenue using various SQL concepts.

---

## 🗂️ Database Name

`Online_Course_DB`

---

## 📊 Database Tables

### 1. Learners

Stores information about learners.

| Column       | Description                |
| ------------ | -------------------------- |
| `learner_id` | Unique ID for each learner |
| `full_name`  | Name of the learner        |
| `country`    | Country of the learner     |

### 2. Courses

Stores information about available courses.

| Column        | Description               |
| ------------- | ------------------------- |
| `course_id`   | Unique ID for each course |
| `course_name` | Name of the course        |
| `category`    | Course category           |
| `unit_price`  | Price of one course unit  |

### 3. Purchases

Stores information about course purchases.

| Column          | Description                 |
| --------------- | --------------------------- |
| `purchase_id`   | Unique ID for each purchase |
| `learner_id`    | ID of the learner           |
| `course_id`     | ID of the purchased course  |
| `quantity`      | Number of courses purchased |
| `purchase_date` | Date of purchase            |

---

## 🔗 Table Relationships

* One learner can make multiple purchases.
* One course can be purchased multiple times.
* The `purchases` table connects the `learners` and `courses` tables using foreign keys.

---

## 🛠️ SQL Concepts Used

This project demonstrates the following SQL concepts:

* Database creation
* Table creation
* Primary Key and Foreign Key
* INSERT statements
* INNER JOIN
* LEFT JOIN
* RIGHT JOIN
* Aggregate functions
* GROUP BY
* HAVING
* ORDER BY
* LIMIT
* Subqueries
* Correlated subqueries
* Common Table Expressions (CTE)
* CASE expressions
* NULL handling using COALESCE()
* Views
* `ANY` operator

---

## 📈 Analytical Queries

The project includes the following analysis:

1. Display each learner's total spending with their country.
2. Find the top 3 most purchased courses by quantity.
3. Show each category's total revenue and number of unique learners.
4. List learners who purchased from more than one category.
5. Identify courses that were never purchased.
6. Find learners whose total spending is above the average learner spending.
7. Display courses whose price is higher than any course in the Beginner category.
8. Find learners who spent more than the average spending in their country.
9. Use a CTE to calculate total spending per learner and display learners spending above 10,000.
10. Classify learners as High Value, Medium Value, or Low Value using a CASE expression.
11. Display all courses and handle NULL purchase counts using COALESCE().
12. Create a view named `category_performance_view` to analyze category performance.

---

## 📊 View: category_performance_view

The `category_performance_view` displays:

* Course Category
* Total Revenue
* Number of Purchases
* Average Revenue per Purchase

Revenue is calculated using:

`Quantity × Unit Price`

---

## 💻 Tools Used

* MySQL
* MySQL Workbench
* GitHub


  

---

## 👩‍💻 Author

**Uma Senya**

Aspiring Data Analyst

**Skills:** SQL | Python | Excel | Power BI
