# Northwind Order & Revenue Analysis
Task 3 - SQL for Data Analysis | Elevate Labs Data Analyst Internship

- Internship: Data Analyst Internship (Elevate Labs)
- Dataset used: Northwind Database (ecommerce-style sample dataset)
- Tool: SQLite

## What's in this repo
- `task3_queries.sql` - all my SQL queries
- `northwind.db` - the database file
- `Q1.jpeg` to `Q9.jpeg` - screenshots of each query and its output
- `README.md` - this file

## What I did
I used the Northwind database to practice writing SQL queries for real analysis questions, going from basic filtering all the way up to views and indexing.

I started simple - SELECT, WHERE, and ORDER BY to list all orders shipped to Germany, most recent first. Then I used GROUP BY with COUNT to find the total number of orders placed by each customer, which immediately showed me who the top customers were.

For joins, I used an INNER JOIN to pull each order alongside the customer's company name, then a LEFT JOIN to list every customer and their orders - including customers who've never placed one, which an INNER JOIN would have silently dropped. I also needed a RIGHT JOIN to list all orders with their employee, even if the employee was missing, but SQLite doesn't support RIGHT JOIN directly. I worked around this by swapping the table order and using LEFT JOIN instead (Orders LEFT JOIN Employees), which gives the exact same result.

I used SUM and AVG together to calculate total and average revenue per order from the Order Details table, since revenue isn't a stored column - it has to be calculated as UnitPrice * Quantity * (1 - Discount).

The subquery was the trickiest part - I wrote a query to find customers whose total order revenue is above the overall average, using a subquery inside the WHERE clause to calculate that average on the fly instead of hardcoding a number.

To make the revenue analysis reusable, I created a VIEW called CustomerRevenueSummary that joins Orders, Customers, and Order Details, and calculates total orders and total revenue per customer in one place. Instead of rewriting that join every time, I can just query the view.

Finally, I optimized the database with indexes on CustomerID (Orders table) and OrderID (Order Details table), since those are the columns I was joining on repeatedly. I verified both indexes were created by querying sqlite_master.

Working through this task made it clear how much LEFT JOIN vs INNER JOIN actually matters - if I'd used INNER JOIN everywhere, I would have silently lost customers with no orders and orders with no employee assigned, without any error being thrown.
