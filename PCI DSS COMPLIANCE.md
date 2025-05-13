
## PCI DCI

## UPDAPTE SPROCS
https://github.com/cko-card-processing/checkout-tpp-db/pull/213/files


## DELETE DATA

Not in snowflake
```SQL
UPDATE dci.CardProductCardNumber
SET CCHash = '', CCNumber = ''
```

```SQL
-- CardProductCardNumber batched update
DECLARE @batchSize INT = 10000;
DECLARE @rowsAffected INT = 1;

WHILE @rowsAffected > 0
BEGIN
    UPDATE TOP (@batchSize) dci.CardProductCardNumber
    SET CCHash = '', CCNumber = ''
    WHERE CCHash IS NOT NULL OR CCNumber IS NOT NULL;
    
    SET @rowsAffected = @@ROWCOUNT;
    
    IF @rowsAffected > 0
        WAITFOR DELAY '00:00:01'; 
END
```


Not in snowflake
```sql
UPDATE dci.CardProductCardNumberTemp
SET CCHash = '', CCNumber = ''
```

```SQL
-- CardProductCardNumberTemp batched update
DECLARE @batchSize INT = 10000;
DECLARE @rowsAffected INT = 1;

WHILE @rowsAffected > 0
BEGIN
    UPDATE TOP (@batchSize) dci.CardProductCardNumberTemp
    SET CCHash = '', CCNumber = ''
    WHERE CCHash IS NOT NULL OR CCNumber IS NOT NULL;
    
    SET @rowsAffected = @@ROWCOUNT;
    
    IF @rowsAffected > 0
        WAITFOR DELAY '00:00:01';
END
```



66Mill rows in snowflake
``` SQL
UPDATE dci.CFChargeRecord
SET CCHash = ''
```


```SQL
-- CFChargeRecord batched update
DECLARE @batchSize INT = 10000;
DECLARE @rowsAffected INT = 1;

WHILE @rowsAffected > 0
BEGIN
    UPDATE TOP (@batchSize) dci.CFChargeRecord
    SET CCHash = ''
    WHERE CCHash IS NOT NULL;
    
    SET @rowsAffected = @@ROWCOUNT;
    
    IF @rowsAffected > 0
        WAITFOR DELAY '00:00:01';
END
```


67Mill Rows in Snowflake
```SQL
UPDATE dci.DciDetail
SET CCHash = ''
```

```SQL
-- DciDetail batched update
DECLARE @batchSize INT = 10000;
DECLARE @rowsAffected INT = 1;

WHILE @rowsAffected > 0
BEGIN
    UPDATE TOP (@batchSize) dci.DciDetail
    SET CCHash = ''
    WHERE CCHash IS NOT NULL;
    
    SET @rowsAffected = @@ROWCOUNT;
    
    IF @rowsAffected > 0
        WAITFOR DELAY '00:00:01';
END
```



0 Rows in Snowflake
```SQL
UPDATE dci.DciSettlementChargeRecord
SET CCHash = ''
```

``` SQL
-- DciSettlementChargeRecord batched update
DECLARE @batchSize INT = 10000;
DECLARE @rowsAffected INT = 1;

WHILE @rowsAffected > 0
BEGIN
    UPDATE TOP (@batchSize) dci.DciSettlementChargeRecord
    SET CCHash = ''
    WHERE CCHash IS NOT NULL;
    
    SET @rowsAffected = @@ROWCOUNT;
    
    IF @rowsAffected > 0
        WAITFOR DELAY '00:00:01';
END
```


Not in Snowflake
```SQL
UPDATE dci.DFFOriginalInterchangeDetailRecord
SET CCHash = ''
```

```SQL
-- DFFOriginalInterchangeDetailRecord batched update
DECLARE @batchSize INT = 10000;
DECLARE @rowsAffected INT = 1;

WHILE @rowsAffected > 0
BEGIN
    UPDATE TOP (@batchSize) dci.DFFOriginalInterchangeDetailRecord
    SET CCHash = ''
    WHERE CCHash IS NOT NULL;
    
    SET @rowsAffected = @@ROWCOUNT;
    
    IF @rowsAffected > 0
        WAITFOR DELAY '00:00:01';
END
```




