UPDATE d
   SET d.CustomerName = s.CustomerName
FROM dbo.DimCustomerStandard AS d
JOIN dbo.Stg_Customer       AS s ON s.CustomerID = d.CustomerCode
WHERE d.CustomerName <> s.CustomerName;

INSERT INTO dbo.DimCustomerStandard (CustomerCode, CustomerName)
SELECT s.CustomerID, s.CustomerName
FROM dbo.Stg_Customer s
LEFT JOIN dbo.DimCustomerStandard d ON d.CustomerCode = s.CustomerID
WHERE d.CustomerCode IS NULL;
