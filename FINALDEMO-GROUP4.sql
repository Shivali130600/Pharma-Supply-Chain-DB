USE PharmaSupplyChainDB;
GO

/* =========================================================
   FILE: 11_Final_Demo_RunOrder.sql
   PURPOSE:
     Final demo execution script
   ========================================================= */

/* =========================================================
   STEP 1: BASE DATA CHECK
   ========================================================= */
PRINT '--- BASE DATA CHECK ---';

SELECT TOP 5 * FROM dbo.PARTNER;
SELECT TOP 5 * FROM dbo.SALES_ORDER;
SELECT TOP 5 * FROM dbo.ORDER_LINE;
SELECT TOP 5 * FROM dbo.SHIPMENT;
SELECT TOP 5 * FROM dbo.INVOICE;
GO

/* =========================================================
   STEP 2: VIEWS DEMONSTRATION
   ========================================================= */
PRINT '--- VIEWS OUTPUT ---';

SELECT TOP 5 * FROM dbo.vw_OrderSummary;
SELECT TOP 5 * FROM dbo.vw_ShipmentTracking;
SELECT TOP 5 * FROM dbo.vw_ProductSalesReport;
GO

/* =========================================================
   STEP 3: FUNCTIONS DEMONSTRATION
   ========================================================= */
PRINT '--- FUNCTIONS OUTPUT ---';

SELECT dbo.fn_CalculateOrderTotal(1) AS Order1_Total;
SELECT dbo.fn_GetShipmentCount(1) AS Order1_ShipmentCount;
SELECT dbo.fn_GetPartnerTotalSales(12) AS Partner12_TotalSales;
GO

/* =========================================================
   STEP 4, 5, 6: STORED PROCEDURES DEMO
   KEEP IN ONE BATCH
   ========================================================= */
PRINT '--- STORED PROCEDURES OUTPUT ---';

DECLARE @Today DATE = CAST(GETDATE() AS DATE);
DECLARE @ExpectedDelivery DATE = DATEADD(DAY, 5, @Today);

DECLARE @NewOrderID INT;
DECLARE @OrderNumber NVARCHAR(100);
DECLARE @OrderMessage NVARCHAR(4000);

DECLARE @NewShipmentID INT;
DECLARE @ShipmentNumber NVARCHAR(100);
DECLARE @ShipmentMessage NVARCHAR(4000);

DECLARE @NewPaymentID INT;
DECLARE @PaymentMessage NVARCHAR(4000);

/* ---------- CREATE SALES ORDER ---------- */
EXEC dbo.sp_CreateSalesOrder
    @BuyerPartnerID = 21,
    @SellerPartnerID = 11,
    @OrderDate = @Today,
    @PriorityLevel = 'High',
    @NewOrderID = @NewOrderID OUTPUT,
    @OrderNumber = @OrderNumber OUTPUT,
    @Message = @OrderMessage OUTPUT;

SELECT
    @NewOrderID AS NewOrderID,
    @OrderNumber AS OrderNumber,
    @OrderMessage AS OrderMessage;

SELECT *
FROM dbo.SALES_ORDER
WHERE order_id = @NewOrderID;

/* ---------- CREATE SHIPMENT ---------- */
EXEC dbo.sp_CreateShipment
    @OrderID = @NewOrderID,
    @ShipFromLocationID = 1,
    @ShipToLocationID = 2,
    @ShipDate = @Today,
    @ExpectedDeliveryDate = @ExpectedDelivery,
    @TrackingReference = 'TRACK-DEMO-001',
    @NewShipmentID = @NewShipmentID OUTPUT,
    @ShipmentNumber = @ShipmentNumber OUTPUT,
    @Message = @ShipmentMessage OUTPUT;

SELECT
    @NewShipmentID AS NewShipmentID,
    @ShipmentNumber AS ShipmentNumber,
    @ShipmentMessage AS ShipmentMessage;

SELECT *
FROM dbo.SHIPMENT
WHERE shipment_id = @NewShipmentID;

/* ---------- RECORD PAYMENT ---------- */
/* Change InvoiceID if needed to one that exists in your table */
EXEC dbo.sp_RecordPayment
    @InvoiceID = 10,
    @PaymentDate = @Today,
    @AmountPaid = 500.00,
    @PaymentMethod = 'Card',
    @ReferenceNote = 'Demo Payment',
    @NewPaymentID = @NewPaymentID OUTPUT,
    @Message = @PaymentMessage OUTPUT;

SELECT
    @NewPaymentID AS NewPaymentID,
    @PaymentMessage AS PaymentMessage;

SELECT *
FROM dbo.PAYMENT
WHERE payment_id = @NewPaymentID;
GO

/* =========================================================
   STEP 7: TRIGGER DEMONSTRATION
   ========================================================= */
PRINT '--- TRIGGER DEMO ---';

UPDATE dbo.SALES_ORDER
SET order_status = 'Confirmed'
WHERE order_id = 1;

SELECT TOP 5 *
FROM dbo.SALES_ORDER_AUDIT
ORDER BY changed_at DESC;
GO

/* =========================================================
   STEP 8: ENCRYPTION DEMONSTRATION
   ========================================================= */
PRINT '--- ENCRYPTION OUTPUT ---';

SELECT TOP 5
    partner_id,
    partner_name,
    encrypted_contact_info,
    encrypted_address
FROM dbo.PARTNER;

SELECT TOP 5
    license_id,
    partner_id,
    encrypted_license_number
FROM dbo.LICENSE;
GO

/* =========================================================
   STEP 9: INDEX CHECK
   ========================================================= */
PRINT '--- INDEXES ---';

SELECT
    i.name AS index_name,
    OBJECT_NAME(i.object_id) AS table_name,
    i.type_desc
FROM sys.indexes i
WHERE i.type_desc = 'NONCLUSTERED'
  AND OBJECT_NAME(i.object_id) IN ('SALES_ORDER', 'ORDER_LINE', 'SHIPMENT', 'PAYMENT');
GO

PRINT '--- DEMO COMPLETED SUCCESSFULLY ---';
GO