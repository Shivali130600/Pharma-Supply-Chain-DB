
------------------SECURITY KEYS----------------------


USE PharmaSupplyChainDB;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.symmetric_keys
    WHERE name = '##MS_DatabaseMasterKey##'
)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'PharmaGroup4_MasterKey@2026';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.certificates
    WHERE name = 'PharmaSupplyChainCert'
)
BEGIN
    CREATE CERTIFICATE PharmaSupplyChainCert
    WITH SUBJECT = 'Certificate for Pharma Supply Chain column encryption';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.symmetric_keys
    WHERE name = 'PharmaSupplyChainSymKey'
)
BEGIN
    CREATE SYMMETRIC KEY PharmaSupplyChainSymKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE PharmaSupplyChainCert;
END;
GO

IF COL_LENGTH('dbo.PARTNER', 'encrypted_contact_info') IS NULL
BEGIN
    ALTER TABLE dbo.PARTNER
    ADD encrypted_contact_info VARBINARY(MAX) NULL;
END;
GO

IF COL_LENGTH('dbo.PARTNER', 'encrypted_address') IS NULL
BEGIN
    ALTER TABLE dbo.PARTNER
    ADD encrypted_address VARBINARY(MAX) NULL;
END;
GO

IF COL_LENGTH('dbo.LICENSE', 'encrypted_license_number') IS NULL
BEGIN
    ALTER TABLE dbo.LICENSE
    ADD encrypted_license_number VARBINARY(MAX) NULL;
END;
GO

PRINT 'Security objects and encrypted columns created successfully.';
GO

-----------------------ENCRYPTION--------------------------------


USE PharmaSupplyChainDB;
GO

OPEN SYMMETRIC KEY PharmaSupplyChainSymKey
DECRYPTION BY CERTIFICATE PharmaSupplyChainCert;
GO

UPDATE dbo.PARTNER
SET encrypted_contact_info =
    CASE
        WHEN contact_info IS NULL THEN NULL
        ELSE EncryptByKey(Key_GUID('PharmaSupplyChainSymKey'), CONVERT(VARBINARY(MAX), contact_info))
    END
WHERE encrypted_contact_info IS NULL;
GO

UPDATE dbo.PARTNER
SET encrypted_address =
    CASE
        WHEN address IS NULL THEN NULL
        ELSE EncryptByKey(Key_GUID('PharmaSupplyChainSymKey'), CONVERT(VARBINARY(MAX), address))
    END
WHERE encrypted_address IS NULL;
GO

UPDATE dbo.LICENSE
SET encrypted_license_number =
    CASE
        WHEN license_number IS NULL THEN NULL
        ELSE EncryptByKey(Key_GUID('PharmaSupplyChainSymKey'), CONVERT(VARBINARY(MAX), license_number))
    END
WHERE encrypted_license_number IS NULL;
GO

SELECT TOP 10
    partner_id,
    partner_name,
    encrypted_contact_info,
    encrypted_address
FROM dbo.PARTNER;
GO

SELECT TOP 10
    license_id,
    partner_id,
    encrypted_license_number
FROM dbo.LICENSE;
GO

CLOSE SYMMETRIC KEY PharmaSupplyChainSymKey;
GO

PRINT 'Sensitive data encrypted successfully.';
GO
