-- ========================================================
-- DATABASE SCHEMA & TABLE CREATION (DDL)
-- ========================================================

-- 1. Create VEHICLES Table
CREATE TABLE VEHICLES (
    Veh_VIN VARCHAR(17) NOT NULL PRIMARY KEY,
    Veh_Year INT NOT NULL,
    Veh_Make VARCHAR(15) NOT NULL,
    Veh_Modl VARCHAR(20) NOT NULL,
    Veh_Eng VARCHAR(10)
);

-- 2. Create TECHS Table
CREATE TABLE TECHS (
    Tech_ID VARCHAR(11) NOT NULL PRIMARY KEY,
    Tech_Nam VARCHAR(60) NOT NULL,
    Tech_Exp VARCHAR(15),
    Lab_Rate DECIMAL(10,2) NOT NULL CHECK (Lab_Rate >= 7.25)
);

-- 3. Create PARTS Table
CREATE TABLE PARTS (
    Part_Num VARCHAR(20) NOT NULL PRIMARY KEY,
    Part_Nam VARCHAR(40) NOT NULL,
    Part_Mfr VARCHAR(20) NOT NULL,
    Part_Qty INT NOT NULL CHECK (Part_Qty >= 0),
    Part_Cst DECIMAL(10,2) NOT NULL CHECK (Part_Cst >= 0)
);

-- 4. Create REPAIRS Table
CREATE TABLE REPAIRS (
    Rep_ID VARCHAR(15) NOT NULL PRIMARY KEY,
    Veh_VIN VARCHAR(17) NOT NULL,
    Tech_ID VARCHAR(11) NOT NULL,
    Rep_Date DATE NOT NULL,
    Lab_Hrs DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (Veh_VIN) REFERENCES VEHICLES(Veh_VIN),
    FOREIGN KEY (Tech_ID) REFERENCES TECHS(Tech_ID)
);

-- 5. Create REPR_PRT Associative Table (Many-to-Many Resolution)
CREATE TABLE REPR_PRT (
    Part_Num VARCHAR(20) NOT NULL,
    Rep_ID VARCHAR(15) NOT NULL,
    Prt_Qty INT NOT NULL,
    PRIMARY KEY (Part_Num, Rep_ID),
    FOREIGN KEY (Part_Num) REFERENCES PARTS(Part_Num),
    FOREIGN KEY (Rep_ID) REFERENCES REPAIRS(Rep_ID)
);

-- ========================================================
-- REPORTING & ANALYTICS QUERIES (DML)
-- ========================================================

-- Q1: Total Labor Revenue per Technician
SELECT
    t.Tech_ID,
    t.Tech_Nam,
    SUM(t.Lab_Rate * r.Lab_Hrs) AS TotalLbr
FROM TECHS t
INNER JOIN REPAIRS r ON t.Tech_ID = r.Tech_ID
GROUP BY
    t.Tech_ID,
    t.Tech_Nam;

-- Q2: Dynamic Repair History Filtering (e.g., Tech 0154, last 65 days)
SELECT
    r.Tech_ID,
    v.Veh_Year,
    v.Veh_Make,
    v.Veh_Modl,
    r.Rep_Date
FROM VEHICLES v
INNER JOIN REPAIRS r ON v.Veh_VIN = r.Veh_VIN
INNER JOIN TECHS t ON r.Tech_ID = t.Tech_ID
WHERE r.Tech_ID LIKE '%0154'
  AND r.Rep_Date >= CURRENT_DATE - INTERVAL '65 days';
