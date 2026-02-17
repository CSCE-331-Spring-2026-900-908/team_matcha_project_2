CREATE TABLE inventory (
    inventoryID INT PRIMARY KEY, 
    name VARCHAR(100), 
    cost DECIMAL(10,2), 
    inventoryNum INT, 
    useAverage INT
);

CREATE TABLE menu (
    menuID INT PRIMARY KEY, 
    name VARCHAR(100), 
    cost DECIMAL(10,2), 
    salesNum INT
);

CREATE TABLE employees (
    employeeID INT PRIMARY KEY, 
    name VARCHAR(100), 
    pay DECIMAL(10,2), 
    job VARCHAR(50), 
    orderNum INT
);

CREATE TABLE orders (
    orderID INT PRIMARY KEY, 
    customerName VARCHAR(100), 
    costTotal DECIMAL(10,2), 
    employeeID INT, 
    orderDateTime TIMESTAMP
);

CREATE TABLE order_items (
    ID INT PRIMARY KEY,
    menuID INT,
    orderID INT,
    quantity INT,
    cost DECIMAL(10,2)
);