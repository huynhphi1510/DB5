-- 5.1. Provinces having an area greater than 15,000 square kilometers
SELECT ProvinceID, ProvinceName 
FROM Province 
WHERE Area > 15000; 

-- 5.2. Provinces (*) that neighbor provinces with an area larger than 15,000 square kilometers.
SELECT DISTINCT p.ProvinceID, p.ProvinceName 
FROM Province p 
JOIN Neighbor n ON p.ProvinceID = n.ProvinceID 
JOIN Province n_prov ON n.NeighborID = n_prov.ProvinceID 
WHERE n_prov.Area > 15000; 

-- 5.3. Provinces (*) within the country ’North’?
SELECT p.ProvinceID, p.ProvinceName 
FROM Province p 
JOIN Country c ON p.CountryID = c.CountryID 
WHERE c.CountryName = 'North'; 

-- 5.4. Which nation borders the northern provinces?
SELECT DISTINCT cn.CountryID, cn.CountryName
FROM Border b
JOIN Province p  ON b.ProvinceID = p.ProvinceID
JOIN Country  c  ON p.CountryID  = c.CountryID
JOIN Country  cn ON b.NationID   = cn.CountryID
WHERE c.CountryName = 'North';

-- 5.5. Calculate the average area of the southern provinces.
SELECT AVG(p.Area) AS AvgArea
FROM Province p
JOIN Country c ON p.CountryID = c.CountryID
WHERE c.CountryName = 'South';

-- 5.6. Calculate the population density of the central country.
SELECT SUM(p.Population) / SUM(p.Area) AS PopulationDensity
FROM Province p
JOIN Country c ON p.CountryID = c.CountryID
WHERE c.CountryName = 'Central';

-- 5.7. Identify the provinces with the highest population density.
SELECT p1.ProvinceName, (p1.Population / p1.Area) AS Density
FROM Province p1
WHERE NOT EXISTS (SELECT 1 FROM Province p2 WHERE (p2.Population / p2.Area) > (p1.Population / p1.Area));

-- 5.8. Which provinces have the greatest area?
SELECT a1.ProvinceName, a1.Area
FROM Province a1
WHERE NOT EXISTS (SELECT 1 FROM Province a2 WHERE a2.Area > a1.Area);

-- 5.9. In the southern country, provinces with the largest area.
SELECT p1.ProvinceName, p1.Area
FROM Province p1
JOIN Country c1 ON p1.CountryID = c1.CountryID
WHERE c1.CountryName = 'South'
  AND NOT EXISTS (SELECT 1 FROM Province p2 JOIN Country c2 ON p2.CountryID = c2.CountryID
    		   WHERE c2.CountryName = 'South' AND p2.Area > p1.Area);


-- 5.10. Provinces that share borders with two or more nations.
SELECT p.ProvinceID, p.ProvinceName
FROM Province p JOIN Border b
ON p.ProvinceID=b.ProvinceID
GROUP BY p.ProvinceID,p.ProvinceName
HAVING COUNT(DISTINCT b.NationID)>=2;

-- 5.11. List of countries, showing the number of provinces each has.
SELECT c.CountryID, c.CountryName, COUNT(p.ProvinceID) AS NumberOfProvinces
FROM Country c LEFT JOIN Province p ON c.CountryID=p.CountryID
GROUP BY c.CountryID,c.CountryName;

-- 5.12. Provinces with the greatest number of neighboring provinces.
WITH NeighborCount AS(SELECT ProvinceID, COUNT(NeighborID) AS TotalNeighbor FROM Neighbor GROUP BY ProvinceID),
MaxNeighbor AS(SELECT MAX(TotalNeighbor) AS MaxValue FROM NeighborCount)
SELECT p.ProvinceID, p.ProvinceName, nc.TotalNeighbor
FROM Province p JOIN NeighborCount nc ON p.ProvinceID=nc.ProvinceID
JOIN MaxNeighbor m ON nc.TotalNeighbor=m.MaxValue;

-- 5.13. Provinces whose area is larger than the area of their neighboring provinces.
WITH NeighborArea AS(SELECT n.ProvinceID, MAX(p2.Area) AS MaxNeighborArea
    FROM Neighbor n JOIN Province p2 ON n.NeighborID=p2.ProvinceID GROUP BY n.ProvinceID)
SELECT p.ProvinceID, p.ProvinceName, p.Area
FROM Province p JOIN NeighborArea na ON p.ProvinceID=na.ProvinceID
WHERE p.Area>na.MaxNeighborArea;

-- 5.14. For each country, list the provinces with the largest areas.
WITH MaxArea AS (SELECT CountryID, MAX(Area) AS LargestArea FROM Province GROUP BY CountryID)

SELECT c.CountryName, p.ProvinceName, p.Area
FROM Province p JOIN MaxArea m ON p.CountryID=m.CountryID AND p.Area=m.LargestArea
JOIN Country c ON p.CountryID=c.CountryID;

-- 5.15. For each country, list the provinces with a population larger than the country’s average population.
WITH AvgPopulation AS
(SELECT CountryID,AVG(Population) AS AvgPop FROM Province GROUP BY CountryID)

SELECT c.CountryName, p.ProvinceName, p.Population
FROM Province p JOIN AvgPopulation a ON p.CountryID=a.CountryID
JOIN Country c ON p.CountryID=c.CountryID
WHERE p.Population>a.AvgPop;

-- 5.16. Countries with the greatest total area.
WITH CountryArea AS (SELECT CountryID, SUM(Area) AS TotalArea FROM Province GROUP BY CountryID),
MaxArea AS (SELECT MAX(TotalArea) AS MaxValue FROM CountryArea)
SELECT c.CountryName, ca.TotalArea
FROM CountryArea ca JOIN MaxArea m ON ca.TotalArea = m.MaxValue
JOIN Country c ON ca.CountryID = c.CountryID;

-- 5.17. Countries with the largest total population.
WITH CountryPop AS (SELECT CountryID, SUM(Population) AS TotalPop FROM Province GROUP BY CountryID),
MaxPop AS (SELECT MAX(TotalPop) AS MaxValue FROM CountryPop
)
SELECT c.CountryName, cp.TotalPop
FROM CountryPop cp JOIN MaxPop m ON cp.TotalPop = m.MaxValue
JOIN Country c ON cp.CountryID = c.CountryID;

-- 5.18. Provinces whose area is larger than the average area of provinces in their country.
WITH AvgArea AS (SELECT CountryID, AVG(Area) AS AvgA FROM Province GROUP BY CountryID)
SELECT p.ProvinceName, p.Area
FROM Province p JOIN AvgArea a ON p.CountryID = a.CountryID
WHERE p.Area > a.AvgA;

-- 5.19 . List of countries, showing the total number of provinces and total population each has.
SELECT c.CountryName, COUNT(p.ProvinceID) AS TotalProvinces, SUM(p.Population) AS TotalPopulation
FROM Country c LEFT JOIN Province p ON c.CountryID = p.CountryID
GROUP BY c.CountryID, c.CountryName;

-- 5.20. Countries with the greatest number of provinces.
WITH ProvinceCount AS (SELECT CountryID, COUNT(ProvinceID) AS TotalProvinces FROM Province GROUP BY CountryID),
MaxCount AS (SELECT MAX(TotalProvinces) AS MaxValue FROM ProvinceCount)
SELECT c.CountryName, pc.TotalProvinces
FROM ProvinceCount pc JOIN MaxCount m ON pc.TotalProvinces = m.MaxValue
JOIN Country c ON pc.CountryID = c.CountryID;

-- 6. Show all the integrity constraints.
SELECT 
    table_name AS "Tên bảng", 
    constraint_name AS "Tên ràng buộc", 
    constraint_type AS "Loại ràng buộc"
FROM 
    information_schema.table_constraints
WHERE 
    table_schema = 'public'
    AND table_name IN ('country', 'province', 'border', 'neighbor')
ORDER BY 
    table_name, 
    constraint_type;

-- Sub-query
--5.18.Provinces whose area is larger than the average area of provinces in their country.(Procedure)
CREATE OR REPLACE FUNCTION fn_timtinhlonnhat(maqg VARCHAR)
RETURNS TABLE (
    provinceid VARCHAR(20),
    provincename VARCHAR(100),
    area FLOAT
) 
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT p.provinceid, p.provincename, p.area 
    FROM province p
    WHERE p.countryid = maqg 
      AND p.area > (SELECT AVG(p2.area) FROM province p2 WHERE p2.countryid = maqg);
END;
$$;

SELECT * FROM province
WHERE countryid = 'C01'
  AND area > (SELECT AVG(area) FROM province WHERE countryid = 'C01');

--5.20.Countries with the greatest number of provinces.
ALTER TABLE Country ADD COLUMN TotalProvinces INT DEFAULT 0;

UPDATE Country c SET 
    TotalProvinces = (SELECT COUNT(*) FROM Province p WHERE p.CountryID = c.CountryID);

CREATE OR REPLACE FUNCTION tg_update_province_max_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE Country SET TotalProvinces = TotalProvinces + 1 WHERE CountryID = NEW.CountryID;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE Country SET TotalProvinces = TotalProvinces - 1 WHERE CountryID = OLD.CountryID;
    ELSIF TG_OP = 'UPDATE' THEN
        -- Nếu tỉnh bị thay đổi từ miền này sang miền khác
        IF OLD.CountryID IS DISTINCT FROM NEW.CountryID THEN
            UPDATE Country SET TotalProvinces = TotalProvinces - 1 WHERE CountryID = OLD.CountryID;
            UPDATE Country SET TotalProvinces = TotalProvinces + 1 WHERE CountryID = NEW.CountryID;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_province_max_changes
AFTER INSERT OR UPDATE OR DELETE ON Province
FOR EACH ROW
EXECUTE FUNCTION tg_update_province_max_count();
SELECT CountryName, TotalProvinces 
FROM Country 
WHERE TotalProvinces = (SELECT MAX(TotalProvinces) FROM Country);
