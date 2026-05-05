Create database BeanAndBrew;

Use BeanAndBrew;

# Changed column name of ids of all tables, as gibbrish name came while importing.
ALTER TABLE `beanandbrew`.`products` 
CHANGE COLUMN `ï»¿Product_ID` `Product_ID` TEXT NULL DEFAULT NULL ;

## DATA UNDERSTANDING ##
Select
	*
From
	Customers;
    
SELECT 
    order_date,
    STR_TO_DATE(order_date, '%d-%m-%Y') AS f1,
    STR_TO_DATE(order_date, '%m-%d-%Y') AS f2,
    STR_TO_DATE(order_date, '%Y-%m-%d') AS f3,
    STR_TO_DATE(order_date, '%d/%m/%Y') AS f4
FROM orders;	

UPDATE orders
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d');

# DATA PROFILING

Select 
	Count(*) as total_count,
    count(Distinct Order_id) as Total_orders,
    Count(Distinct Customer_id) as Total_Customers_who_ordered,
    Count(Distinct Product_id) as Total_distincT_Products_Ordered,
    Min(order_date) as Min_OrderDate,
    max(order_date) as Max_OrderDate
From 
	Orders;
-- Output
	-- Total rows: 1000
	-- Total Orders: 957
    -- Total Customers who ordered: 913
    -- Total Distinct products ordered: 48
    -- Min Order Date: 2019-01-02
    -- Max Order Date: 2022-08-19

# Identifying Null or blank values in columns
SELECT 
    COUNT(*) AS total_count,
    COUNT(DISTINCT Customer_id) AS total_customers,

    SUM(Customer_name IS NULL OR TRIM(Customer_name) = '') AS total_null_names,
    SUM(Email IS NULL OR TRIM(Email) = '') AS total_null_emails,
    SUM(Phone_Number IS NULL OR TRIM(Phone_Number) = '') AS total_null_phone_numbers,

    SUM(Address_Line1 IS NULL OR TRIM(Address_Line1) = '') AS total_null_address_line1,
    SUM(City IS NULL OR TRIM(City) = '') AS total_null_city,
    SUM(Country IS NULL OR TRIM(Country) = '') AS total_null_country,
    SUM(Postcode IS NULL OR TRIM(Postcode) = '') AS total_null_postcode,
    SUM(Loyalty_card IS NULL OR TRIM(Loyalty_card) = '') AS total_null_loyalty_card

FROM Customers;
-- Output:
	-- Total rows: 1000
    -- Total Customers: 1000 (That is, no blank ids)
    -- Total Blank Emails: 204
    -- Total Blank Phone Numbers: 130
    -- There is no blank entry in any other column

Update 
	Customers
Set 
	Email = "Not Known"
Where Email IS NULL OR TRIM(Email) = '';
-- 204 Emails changed to Not Known

Update 
	Customers
Set 
	Phone_Number = "Not Known"
Where Phone_Number IS NULL OR TRIM(Phone_Number) = '';
-- 130 Phone Numbers changed to Not Known

# Handling nulls of Products table

Select 
	Count(*) as Total_Rows,
    Count(Distinct Product_id) as Total_Product_ids,
    sum(Coffee_type is Null or trim(Coffee_type) = ' ') as Total_Null_Coffee_Type,
    sum(Roast_type is Null or trim(Roast_type) = ' ') as Total_Null_Roast_type,
    sum(Size is Null or trim(Size) = ' ') as Total_Null_Size,
    sum(Unit_Price is Null or trim(Unit_Price) = ' ') as Total_Null_Unit_Price,
    sum(Price_per_100g is Null or trim(Price_per_100g) = ' ') as Total_Null_Price_per_100g,
    sum(Profit is Null or trim(Profit) = ' ') as Total_Null_Profit
From
	Products;
-- Output:
	-- Total rows: 48
    -- Total Product ids: 48
    -- There is no blank entry in any column
    
# Check for inconsistent casing
Select
	Distinct Loyalty_card
From 
	Customers;
-- No inconsistencies found

Select 
	Distinct Coffee_Type
From 
	Products;
-- No inconsistencies found

Select 
	Distinct Roast_Type
From 
	Products;
-- No inconsistencies found

# Check for negative or invalid values.

Select 
	Order_id,
    Quantity
From
	Orders
Where 
	Quantity < 0;
-- No inconsistencies found

Select 
	Product_id,
    Size
From
	Products
Where 
	Size < 0;
-- No inconsistencies found

Select 
	Product_id,
    Unit_Price
From
	Products
Where 
	Unit_Price < 0;
-- No inconsistencies found

Select 
	Product_id,
    Price_per_100g
From
	Products
Where 
	Price_per_100g < 0;
-- No inconsistencies found

Select 
	Product_id,
    Profit
From
	Products
Where 
	Profit < 0;
-- No inconsistencies found

## DATA MODELING ## 

Create View Master_Sheet as 
Select
	O.Order_ID,
    O.Order_Date,
    O.Customer_Id,
    C.Customer_Name,
    C.Email as Customer_Email,
    C.Phone_Number as Customer_Phone_Number,
    C.Address_Line1 as Customer_Address,
    C.City as Customer_City,
    C.Country as Customer_Country,
    C.Postcode as Customer_Postcode,
    C.Loyalty_Card,
    O.Product_id,
    P.Coffee_Type,
    P.Roast_Type,
    P.Size,
    O.Quantity,
    P.Unit_Price,
    P.Profit
From Orders as O
Left Join Customers as C
on O.Customer_Id = C.Customer_Id
Left join Products as P
on O.Product_Id = P.Product_Id;