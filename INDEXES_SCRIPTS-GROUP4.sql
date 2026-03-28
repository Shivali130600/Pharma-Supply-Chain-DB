USE PharmaSupplyChainDB;
GO

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_SALES_ORDER_BuyerSellerDate'
      AND object_id = OBJECT_ID('dbo.SALES_ORDER')
)
    DROP INDEX IX_SALES_ORDER_BuyerSellerDate ON dbo.SALES_ORDER;
GO

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_ORDER_LINE_OrderProduct'
      AND object_id = OBJECT_ID('dbo.ORDER_LINE')
)
    DROP INDEX IX_ORDER_LINE_OrderProduct ON dbo.ORDER_LINE;
GO

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_SHIPMENT_OrderStatusShipDate'
      AND object_id = OBJECT_ID('dbo.SHIPMENT')
)
    DROP INDEX IX_SHIPMENT_OrderStatusShipDate ON dbo.SHIPMENT;
GO

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_PAYMENT_InvoiceStatusDate'
      AND object_id = OBJECT_ID('dbo.PAYMENT')
)
    DROP INDEX IX_PAYMENT_InvoiceStatusDate ON dbo.PAYMENT;
GO

CREATE NONCLUSTERED INDEX IX_SALES_ORDER_BuyerSellerDate
ON dbo.SALES_ORDER (buyer_partner_id, seller_partner_id, order_date)
INCLUDE (order_number, order_status, priority_level);
GO

CREATE NONCLUSTERED INDEX IX_ORDER_LINE_OrderProduct
ON dbo.ORDER_LINE (order_id, product_id)
INCLUDE (requested_quantity, agreed_price);
GO

CREATE NONCLUSTERED INDEX IX_SHIPMENT_OrderStatusShipDate
ON dbo.SHIPMENT (order_id, shipment_status, ship_date)
INCLUDE (shipment_number, expected_delivery_date, delivery_date, tracking_reference);
GO

CREATE NONCLUSTERED INDEX IX_PAYMENT_InvoiceStatusDate
ON dbo.PAYMENT (invoice_id, payment_status, payment_date)
INCLUDE (amount_paid, payment_method);
GO

PRINT 'Indexes created successfully.';
GO