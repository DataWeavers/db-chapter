-- Cedar Books: original fictional data for Business Databases.
-- Run this file ONCE in a NEW, EMPTY SQLite database.

PRAGMA foreign_keys = ON;

CREATE TABLE Customers (
  CustomerID INTEGER PRIMARY KEY,
  CustomerName TEXT NOT NULL,
  City TEXT NOT NULL,
  Email TEXT
);

CREATE TABLE Books (
  BookID INTEGER PRIMARY KEY,
  Title TEXT NOT NULL,
  Category TEXT NOT NULL,
  ListPrice REAL NOT NULL
    CHECK (typeof(ListPrice) IN ('integer', 'real') AND ListPrice >= 0)
);

CREATE TABLE Orders (
  OrderID INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL REFERENCES Customers(CustomerID),
  OrderDate TEXT NOT NULL,
  Status TEXT NOT NULL
    CHECK (Status IN ('Completed', 'Pending', 'Cancelled'))
);

CREATE TABLE OrderLines (
  OrderID INTEGER NOT NULL REFERENCES Orders(OrderID),
  BookID INTEGER NOT NULL REFERENCES Books(BookID),
  Quantity INTEGER NOT NULL
    CHECK (typeof(Quantity) = 'integer' AND Quantity > 0),
  UnitPrice REAL NOT NULL
    CHECK (typeof(UnitPrice) IN ('integer', 'real') AND UnitPrice >= 0),
  PRIMARY KEY (OrderID, BookID)
);

INSERT INTO Customers (CustomerID, CustomerName, City, Email) VALUES (1, 'Avery Chen', 'Portland', 'avery@example.com');
INSERT INTO Customers (CustomerID, CustomerName, City, Email) VALUES (2, 'Morgan Lee', 'Salem', NULL);
INSERT INTO Customers (CustomerID, CustomerName, City, Email) VALUES (3, 'Sam Rivera', 'Portland', 'sam@example.com');
INSERT INTO Customers (CustomerID, CustomerName, City, Email) VALUES (4, 'Morgan Lee', 'Eugene', 'morgan@example.com');

INSERT INTO Books (BookID, Title, Category, ListPrice) VALUES (101, 'Everyday Economics', 'Business', 20.0);
INSERT INTO Books (BookID, Title, Category, ListPrice) VALUES (102, 'The Quiet Forest', 'Fiction', 15.0);
INSERT INTO Books (BookID, Title, Category, ListPrice) VALUES (103, 'Practical Data', 'Business', 30.0);
INSERT INTO Books (BookID, Title, Category, ListPrice) VALUES (104, 'City Walks', 'Travel', 24.0);
INSERT INTO Books (BookID, Title, Category, ListPrice) VALUES (105, 'Kitchen Science', 'Cooking', 18.0);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status) VALUES (501, 1, '2025-04-03', 'Completed');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status) VALUES (502, 2, '2025-04-05', 'Completed');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status) VALUES (503, 1, '2025-04-12', 'Cancelled');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status) VALUES (504, 3, '2025-04-20', 'Completed');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status) VALUES (505, 2, '2025-04-29', 'Pending');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status) VALUES (506, 3, '2025-05-02', 'Completed');

INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (501, 101, 1, 20.0);
INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (501, 102, 2, 15.0);
INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (502, 103, 1, 25.0);
INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (502, 104, 1, 24.0);
INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (503, 101, 1, 20.0);
INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (504, 102, 3, 14.0);
INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (504, 105, 2, 18.0);
INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (505, 104, 2, 24.0);
INSERT INTO OrderLines (OrderID, BookID, Quantity, UnitPrice) VALUES (506, 101, 2, 20.0);

