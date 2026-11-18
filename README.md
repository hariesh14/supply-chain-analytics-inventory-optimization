# Supply Chain Analytics & Inventory Optimization

## Dataset
This is synthetic practice data, not real company data:
- Products.csv — product category, unit cost, reorder point, target stock
- Suppliers.csv — supplier details and tier
- Inventory.csv — current stock snapshot
- PurchaseOrders.csv — order, promised receipt, actual receipt, quantity and cost
- SupplyChainAnalytics.sql — SQL Server schema and analysis queries

## Two-day build plan
Day 1: install Power BI Desktop and SQL Server Express + SSMS if time allows. Import CSVs into SQL Server, run SQL queries, verify counts and data types.
Day 2: connect Power BI to the CSVs or SQL Server, create relationships, DAX measures, visuals, and write a README with screenshots.

## Suggested Power BI relationships
Products[ProductID] 1:* PurchaseOrders[ProductID]
Suppliers[SupplierID] 1:* PurchaseOrders[SupplierID]
Products[ProductID] 1:1 Inventory[ProductID]




# Supply Chain Analytics & Inventory Optimization

An end-to-end portfolio project using **PostgreSQL, pgAdmin, and Microsoft Power BI** to analyse inventory levels, identify replenishment needs, and review supplier delivery performance.

> **Data note:** This project uses synthetic/sample data created for learning and portfolio demonstration. It is not company-confidential or real operational data.

## Project objectives

- Monitor inventory value and product counts.
- Identify products below their reorder point.
- Estimate suggested replenishment quantities using target stock.
- Analyse inventory value and low-stock items by product category.
- Review supplier on-time delivery performance.
- Present the analysis in an interactive Power BI dashboard.

## Tools used

- PostgreSQL – relational database and SQL analysis
- pgAdmin – database management and query execution
- Microsoft Power BI Desktop – data modelling, DAX measures and dashboard development

## Database structure

The project uses four main tables:

| Table | Purpose |
|---|---|
| `products` | Product attributes, category, unit cost, reorder point and target stock |
| `suppliers` | Supplier details |
| `inventory` | Current on-hand quantity by product |
| `purchase_orders` | Procurement orders and delivery dates |

Check the SQL scripts and CSV files in this repository for the exact column names and sample records.

## Dashboard contents

The Power BI report includes:

- KPI cards: Total Inventory Value, Total Products, Low Stock Products and On-Time Delivery %
- Inventory Value by Product Category
- Supplier Delivery Performance
- Low Stock Analysis
- Inventory Reorder Recommendations table
- Product Category and Supplier slicers

## Key business logic

### Inventory value

Inventory value is calculated as on-hand quantity multiplied by the related product unit cost, summed across inventory records.

### Low-stock identification

A product is considered low stock when its on-hand quantity is below its reorder point.

### Suggested reorder quantity

The suggested quantity is calculated as the positive difference between target stock and current on-hand quantity. If current stock is already at or above target stock, the suggested quantity is zero.

The synthetic dataset was adjusted so target stock is greater than reorder point for the products used in the replenishment analysis. This is a modelling assumption for the demonstration, not a universal inventory policy.

### On-time delivery

On-time delivery is measured by comparing received date with promised date for purchase orders. Confirm the exact treatment of blank or open orders in the SQL/DAX implementation before interpreting the percentage.


Only include files that you actually created and tested. Replace example filenames with your actual filenames if they differ.

## How to reproduce the project

1. Install PostgreSQL and pgAdmin.
2. Create a database named `supply_chain_analytics`.
3. Create the four tables using the SQL script in `sql/`.
4. Import the CSV files from `data/` into their matching tables.
5. Run the SQL analysis queries and review the results.
6. Open the Power BI file from `powerbi/`.
7. If needed, update the PostgreSQL server, database and credentials in Power BI. Do not publish database passwords.
8. Refresh the report and test the slicers and visuals.

## Key analysis questions

1. What is the total estimated value of inventory on hand?
2. How many products are below their reorder point?
3. Which categories hold the highest inventory value?
4. Which products require replenishment?
5. How much stock is suggested to reach each product's target stock?
6. Which suppliers have the strongest on-time delivery performance?
7. What is the total procurement spend represented by the purchase orders?

## Limitations and assumptions

- The data is synthetic and intended for portfolio practice.
- Suggested reorder quantities are simple replenishment estimates; they do not account for lead-time demand, safety stock, seasonality, MOQ, storage constraints or forecast demand.
- On-time delivery results depend on the date fields and treatment of incomplete purchase orders in the model.
- The report is an analytical demonstration, not a live enterprise planning system.





