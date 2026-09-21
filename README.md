# Auto Shop Relational Database

## Overview
This repository contains the architecture and SQL implementation for a relational database designed to track service operations and parts inventory for a specialized European automotive shop. The system monitors vehicle repairs, technician performance, and parts consumption to ensure efficient shop management and accurate invoicing.

## Tech Stack
* **Database Management System:** Microsoft Access
* **Language:** SQL
* **Core Concepts:** Relational Data Modeling, Entity-Relationship Design, 3rd Normal Form (3NF)

## Database Architecture
The database is strictly normalized to **3rd Normal Form (3NF)**, ensuring no repeating tuples, only atomic values, and no partial or transitive dependencies[cite: 2]. 

It consists of five core tables[cite: 2]:
* **VEHICLES:** Stores unique 17-character VINs, Year, Make, Model, and specific Engine Codes[cite: 2].
* **TECHS:** Tracks technician profiles, including their specific vehicle make specializations and unique hourly labor rates[cite: 2].
* **PARTS:** Manages current stock inventory (Quantity), manufacturer data, and wholesale part cost[cite: 2].
* **REPAIRS:** Records individual service events, linking a single vehicle and a single technician to a repair date and total billed labor hours[cite: 2].
* **REPR_PRT (Associative Entity):** Resolves the many-to-many relationship between repairs and parts, tracking the exact quantity of parts consumed during a specific repair event[cite: 2].

## SQL Query Highlights
Below are examples of the backend SQL queries used to drive reporting and analytics.

### 1. Total Labor Revenue per Technician
This query calculates the total amount of money due for every technician's repairs by aggregating their specific labor rates multiplied by their billed hours[cite: 2].

```sql
SELECT
  TECHS.Tech_ID,
  TECHS.Tech_Nam,
  Sum([Lab_Rate] * [Lab_Hrs]) AS TotalLbr
FROM
  TECHS
INNER JOIN REPAIRS ON TECHS.Tech_ID = REPAIRS.Tech_ID
GROUP BY
  TECHS.Tech_ID,
  TECHS.Tech_Nam;
```

### 2. Dynamic Repair History Filtering
This query retrieves the repair history for a specific technician within a dynamically specified timeframe (e.g., the last 65 days)[cite: 2].
```sql
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
```
