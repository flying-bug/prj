CREATE DATABASE AutoWashPro;
GO

USE AutoWashPro;
GO

CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER', -- ADMIN or CUSTOMER
    fullName NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    licensePlate VARCHAR(20) UNIQUE NOT NULL,
    points INT DEFAULT 0,
    tier VARCHAR(20) DEFAULT 'Member', -- Member, Silver, Gold, Platinum
    totalSpent DECIMAL(18,2) DEFAULT 0,
    washCount INT DEFAULT 0,
    registerDate DATE DEFAULT GETDATE()
);

CREATE TABLE Promotions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    requiredPoints INT DEFAULT 0,
    targetTier VARCHAR(20) -- ALL, Silver, Gold, Platinum
);

CREATE TABLE Bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    userId INT FOREIGN KEY REFERENCES Users(id),
    bookingDate DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' -- PENDING, CONFIRMED, COMPLETED, CANCELLED
);

CREATE TABLE Transactions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    userId INT FOREIGN KEY REFERENCES Users(id),
    bookingId INT FOREIGN KEY REFERENCES Bookings(id),
    amount DECIMAL(18,2) NOT NULL,
    pointsEarned INT DEFAULT 0,
    transactionDate DATETIME DEFAULT GETDATE()
);

-- Insert an Admin user (password: 123)
INSERT INTO Users (username, password, role, fullName, phone, licensePlate, tier)
VALUES ('admin', '123', 'ADMIN', 'System Administrator', '0123456789', 'ADMIN01', 'Member');

-- Insert a sample Customer (password: 123)
INSERT INTO Users (username, password, role, fullName, phone, licensePlate, tier)
VALUES ('customer', '123', 'CUSTOMER', 'Nguyen Van A', '0987654321', '29A-12345', 'Member');

-- Create Redemptions table
CREATE TABLE Redemptions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    userId INT FOREIGN KEY REFERENCES Users(id),
    promotionId INT FOREIGN KEY REFERENCES Promotions(id),
    redeemedDate DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'ACTIVE' -- ACTIVE, EXPIRED, USED
);

-- Seed default promotions
INSERT INTO Promotions (name, description, requiredPoints, targetTier) VALUES 
('Free Waxing', 'Redeem 300 points to get a free car waxing service.', 300, 'Silver'),
('Free Exterior Wash', 'Redeem 500 points to get a free standard exterior wash.', 500, 'Silver'),
('VIP Interior Detailing', 'Redeem 1000 points for a full interior steam cleaning and detailing.', 1000, 'Gold'),
('Free Monthly Platinum Wash', 'Redeem 1500 points for a premium monthly wash package.', 1500, 'Platinum');

