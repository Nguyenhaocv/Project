---Truy vấn số lượng sản phẩm theo phân loại hàng.
SELECT c.CategoryName Product_Categories, count(p.ProductName) Product_quantity ,sum(o.Quantity) Total_Quantity 
FROM Categories AS c
INNER JOIN Products AS p ON c.CategoryID = p.CategoryID
INNER JOIN [Order Details] AS o ON p.ProductID = o.ProductID
GROUP BY c.CategoryName;


--- Truy vấn số lượng sản phẩm theo nhà cung cấp.
SELECT s.ContactName Suppliers, count(p.ProductName) Quantity
FROM Suppliers AS s
INNER JOIN Products AS p ON s.SupplierID = p.SupplierID
INNER JOIN [Order Details] AS o ON p.ProductID = o.ProductID
GROUP BY s.ContactName

--- Truy vấn giá trị trung bình của một đơn hàng.
SELECT OrderID ID,round(AVG(UnitPrice * Quantity),2) Avg_value
FROM [Order Details]
group by OrderID


--- Truy vấn số tiền trung bình mà mỗi khách hàng đã chi.
SELECT ContactName Customer ,round(AVG(UnitPrice * Quantity),2) AVG_Spend
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY ContactName

--- Truy vấn doanh thu của từng nhân viên trong năm 1997
SELECT e.EmployeeID ID, CONCAT(e.FirstName,' ',e.LastName) Name, YEAR(o.OrderDate) Year,sum(od.Quantity * od.UnitPrice) Sales
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, CONCAT(e.FirstName,' ',e.LastName) ,YEAR(o.OrderDate)
HAVING YEAR(o.OrderDate) = 1997;

--- Truy vấn hoa hồng nhận được của mỗi nhân viên.
WITH commission_each_order AS (
	SELECT od.OrderID, SUM(od.Quantity*od.UnitPrice) Sales,
			CASE WHEN SUM(od.Quantity*od.UnitPrice) < 2000 THEN round(SUM(od.Quantity*od.UnitPrice)*0.05,2)
			 ELSE  round(SUM(od.Quantity*od.UnitPrice)*0.075,2)
			END AS Commission
	FROM [Order Details] od
	GROUP BY od.OrderID
)

SELECT e.EmployeeID, CONCAT(e.FirstName,' ',e.LastName) Employee_Name,sum(c.commission) Employee_Sales_Commission
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN commission_each_order c ON c.OrderID = o.OrderID
GROUP by e.EmployeeID, CONCAT(e.FirstName,' ',e.LastName)

--- Truy vấn những khách hàng có đơn hàng mà địa chỉ giao hàng khác với địa chỉ sống.
SELECT c.ContactName Cus_Name, c.Address Cus_Address, o.ShipAddress Ship_Address
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.ShipAddress not in (
		SELECT Address
		FROM Customers
)
group by c.ContactName, c.Address,o.ShipAddress

--- Truy vấn số lượng hàng hóa mà mỗi nhà cung cấp đã cung ứng. 
SELECT s.ContactName Suppliers, sum(o.Quantity) Quantity_Supplied
FROM Suppliers AS s
INNER JOIN Products AS p ON s.SupplierID = p.SupplierID
INNER JOIN [Order Details] AS o ON p.ProductID = o.ProductID
GROUP BY s.ContactName

--- Truy vấn số lượng đơn hàng và số lượng hàng bán ra theo từng ngày trong tháng 6 năm 1997.
SELECT DAY(o.OrderDate) Day_Order, COUNT(o.OrderID) Number_Orders, COUNT(p.ProductName) Number_Products
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY DAY(o.OrderDate), o.OrderDate
HAVING MONTH(o.OrderDate) = 6 AND YEAR(o.OrderDate) = 1997
ORDER BY Day_Order


--- Truy vấn số ngày trung bình từ lúc đặt hàng đến lúc nhận hàng (RequiredDate).
SELECT 'Average day:' ,AVG(DATEDIFF(dd,OrderDate,RequiredDate)) DAY
FROM Orders


