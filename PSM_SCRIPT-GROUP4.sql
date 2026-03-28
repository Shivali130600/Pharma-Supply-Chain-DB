

------STORED PROCEDURES WITH TRANSACTION MANAGEMENT AND ERROR HANDLING------

USE PharmaSupplyChainDB;
GO

DROP PROCEDURE IF EXISTS dbo.sp_CreateSalesOrder;
DROP PROCEDURE IF EXISTS dbo.sp_CreateShipment;
DROP PROCEDURE IF EXISTS dbo.sp_RecordPayment;
GO

CREATE PROCEDURE dbo.sp_CreateSalesOrder
    @BuyerPartnerID   INT,
    @SellerPartnerID  INT,
    @OrderDate        DATE,
    @PriorityLevel    NVARCHAR(20),
    @NewOrderID       INT OUTPUT,
    @OrderNumber      NVARCHAR(100) OUTPUT,
    @Message          NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.PARTNER
            WHERE partner_id = @BuyerPartnerID
        )
        BEGIN
            SET @Message = 'Buyer partner does not exist.';
            RAISERROR(@Message, 16, 1);
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.PARTNER
            WHERE partner_id = @SellerPartnerID
        )
        BEGIN
            SET @Message = 'Seller partner does not exist.';
            RAISERROR(@Message, 16, 1);
        END

        IF @BuyerPartnerID = @SellerPartnerID
        BEGIN
            SET @Message = 'Buyer and seller partner cannot be the same.';
            RAISERROR(@Message, 16, 1);
        END

        IF @PriorityLevel NOT IN ('Low', 'Medium', 'High', 'Urgent')
        BEGIN
            SET @Message = 'Invalid priority level.';
            RAISERROR(@Message, 16, 1);
        END

        DECLARE @NextSeq INT;

        SELECT @NextSeq = ISNULL(MAX(order_id), 0) + 1
        FROM dbo.SALES_ORDER;

        SET @OrderNumber =
            'SO-' +
            CONVERT(VARCHAR(8), ISNULL(@OrderDate, GETDATE()), 112) +
            '-' +
            RIGHT('0000' + CAST(@NextSeq AS VARCHAR(10)), 4);

        INSERT INTO dbo.SALES_ORDER
        (
            order_number,
            buyer_partner_id,
            seller_partner_id,
            order_date,
            order_status,
            priority_level
        )
        VALUES
        (
            @OrderNumber,
            @BuyerPartnerID,
            @SellerPartnerID,
            ISNULL(@OrderDate, CAST(GETDATE() AS DATE)),
            'Created',
            @PriorityLevel
        );

        SET @NewOrderID = SCOPE_IDENTITY();
        SET @Message = 'Sales order created successfully.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NewOrderID = NULL;
        SET @OrderNumber = NULL;

        IF @Message IS NULL
            SET @Message = ERROR_MESSAGE();
        ELSE
            SET @Message = @Message + ' | SQL Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE dbo.sp_CreateShipment
    @OrderID                INT,
    @ShipFromLocationID     INT,
    @ShipToLocationID       INT,
    @ShipDate               DATE,
    @ExpectedDeliveryDate   DATE = NULL,
    @TrackingReference      NVARCHAR(100) = NULL,
    @NewShipmentID          INT OUTPUT,
    @ShipmentNumber         NVARCHAR(100) OUTPUT,
    @Message                NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.SALES_ORDER
            WHERE order_id = @OrderID
        )
        BEGIN
            SET @Message = 'Sales order does not exist.';
            RAISERROR(@Message, 16, 1);
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.LOCATION
            WHERE location_id = @ShipFromLocationID
        )
        BEGIN
            SET @Message = 'Ship-from location does not exist.';
            RAISERROR(@Message, 16, 1);
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.LOCATION
            WHERE location_id = @ShipToLocationID
        )
        BEGIN
            SET @Message = 'Ship-to location does not exist.';
            RAISERROR(@Message, 16, 1);
        END

        IF @ShipFromLocationID = @ShipToLocationID
        BEGIN
            SET @Message = 'Ship-from and ship-to locations cannot be the same.';
            RAISERROR(@Message, 16, 1);
        END

        IF @ExpectedDeliveryDate IS NOT NULL
           AND @ExpectedDeliveryDate < @ShipDate
        BEGIN
            SET @Message = 'Expected delivery date cannot be earlier than ship date.';
            RAISERROR(@Message, 16, 1);
        END

        DECLARE @NextShipmentSeq INT;

        SELECT @NextShipmentSeq = ISNULL(MAX(shipment_id), 0) + 1
        FROM dbo.SHIPMENT;

        SET @ShipmentNumber =
            'SH-' +
            CONVERT(VARCHAR(8), ISNULL(@ShipDate, GETDATE()), 112) +
            '-' +
            RIGHT('0000' + CAST(@NextShipmentSeq AS VARCHAR(10)), 4);

        INSERT INTO dbo.SHIPMENT
        (
            shipment_number,
            order_id,
            ship_from_location_id,
            ship_to_location_id,
            ship_date,
            expected_delivery_date,
            delivery_date,
            shipment_status,
            tracking_reference
        )
        VALUES
        (
            @ShipmentNumber,
            @OrderID,
            @ShipFromLocationID,
            @ShipToLocationID,
            ISNULL(@ShipDate, CAST(GETDATE() AS DATE)),
            @ExpectedDeliveryDate,
            NULL,
            'Created',
            @TrackingReference
        );

        SET @NewShipmentID = SCOPE_IDENTITY();
        SET @Message = 'Shipment created successfully.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NewShipmentID = NULL;
        SET @ShipmentNumber = NULL;

        IF @Message IS NULL
            SET @Message = ERROR_MESSAGE();
        ELSE
            SET @Message = @Message + ' | SQL Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE dbo.sp_RecordPayment
    @InvoiceID        INT,
    @PaymentDate      DATE,
    @AmountPaid       DECIMAL(14,2),
    @PaymentMethod    NVARCHAR(30),
    @ReferenceNote    NVARCHAR(150) = NULL,
    @NewPaymentID     INT OUTPUT,
    @Message          NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.INVOICE
            WHERE invoice_id = @InvoiceID
        )
        BEGIN
            SET @Message = 'Invoice does not exist.';
            RAISERROR(@Message, 16, 1);
        END

        IF @AmountPaid <= 0
        BEGIN
            SET @Message = 'Payment amount must be greater than zero.';
            RAISERROR(@Message, 16, 1);
        END

        IF @PaymentMethod NOT IN ('Cash', 'Card', 'Bank Transfer', 'UPI', 'Check')
        BEGIN
            SET @Message = 'Invalid payment method.';
            RAISERROR(@Message, 16, 1);
        END

        INSERT INTO dbo.PAYMENT
        (
            invoice_id,
            payment_date,
            amount_paid,
            payment_method,
            payment_status,
            reference_note
        )
        VALUES
        (
            @InvoiceID,
            ISNULL(@PaymentDate, CAST(GETDATE() AS DATE)),
            @AmountPaid,
            @PaymentMethod,
            'Completed',
            @ReferenceNote
        );

        SET @NewPaymentID = SCOPE_IDENTITY();

        DECLARE @InvoiceTotal DECIMAL(14,2);
        DECLARE @TotalPaid DECIMAL(14,2);

        SELECT @InvoiceTotal = total_amount
        FROM dbo.INVOICE
        WHERE invoice_id = @InvoiceID;

        SELECT @TotalPaid = ISNULL(SUM(amount_paid), 0)
        FROM dbo.PAYMENT
        WHERE invoice_id = @InvoiceID
          AND payment_status = 'Completed';

        UPDATE dbo.INVOICE
        SET invoice_status =
            CASE
                WHEN @TotalPaid <= 0 THEN 'Issued'
                WHEN @TotalPaid < @InvoiceTotal THEN 'Partially Paid'
                WHEN @TotalPaid >= @InvoiceTotal THEN 'Paid'
            END
        WHERE invoice_id = @InvoiceID;

        SET @Message = 'Payment recorded successfully.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NewPaymentID = NULL;

        IF @Message IS NULL
            SET @Message = ERROR_MESSAGE();
        ELSE
            SET @Message = @Message + ' | SQL Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

PRINT 'Stored procedures created successfully.';
GO

--------------END OF STROED PROCEDURES---------------------




--------------UDF------------------------

USE PharmaSupplyChainDB;
GO

DROP FUNCTION IF EXISTS dbo.fn_CalculateOrderTotal;
DROP FUNCTION IF EXISTS dbo.fn_GetShipmentCount;
DROP FUNCTION IF EXISTS dbo.fn_GetPartnerTotalSales;
GO

CREATE FUNCTION dbo.fn_CalculateOrderTotal
(
    @OrderID INT
)
RETURNS DECIMAL(14,2)
AS
BEGIN
    DECLARE @Total DECIMAL(14,2);

    SELECT
        @Total = ISNULL(SUM(requested_quantity * agreed_price), 0)
    FROM dbo.ORDER_LINE
    WHERE order_id = @OrderID;

    RETURN ISNULL(@Total, 0);
END;
GO

CREATE FUNCTION dbo.fn_GetShipmentCount
(
    @OrderID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @ShipmentCount INT;

    SELECT
        @ShipmentCount = COUNT(*)
    FROM dbo.SHIPMENT
    WHERE order_id = @OrderID;

    RETURN ISNULL(@ShipmentCount, 0);
END;
GO

CREATE FUNCTION dbo.fn_GetPartnerTotalSales
(
    @SellerPartnerID INT
)
RETURNS DECIMAL(14,2)
AS
BEGIN
    DECLARE @TotalSales DECIMAL(14,2);

    SELECT
        @TotalSales = ISNULL(SUM(ol.requested_quantity * ol.agreed_price), 0)
    FROM dbo.SALES_ORDER so
    INNER JOIN dbo.ORDER_LINE ol
        ON so.order_id = ol.order_id
    WHERE so.seller_partner_id = @SellerPartnerID;

    RETURN ISNULL(@TotalSales, 0);
END;
GO

PRINT 'Functions created successfully.';
GO


----------------------END OF UDF-------------------------




------------------VIEWS-----------------------------------


USE PharmaSupplyChainDB;
GO

DROP VIEW IF EXISTS dbo.vw_OrderSummary;
DROP VIEW IF EXISTS dbo.vw_ShipmentTracking;
DROP VIEW IF EXISTS dbo.vw_ProductSalesReport;
GO

CREATE VIEW dbo.vw_OrderSummary
AS
SELECT
    so.order_id,
    so.order_number,
    so.order_date,
    so.order_status,
    so.priority_level,
    buyer.partner_name AS buyer_name,
    seller.partner_name AS seller_name,
    COUNT(DISTINCT ol.order_line_id) AS total_order_lines,
    ISNULL(SUM(ol.requested_quantity * ol.agreed_price), 0) AS calculated_order_value
FROM dbo.SALES_ORDER so
INNER JOIN dbo.PARTNER buyer
    ON so.buyer_partner_id = buyer.partner_id
INNER JOIN dbo.PARTNER seller
    ON so.seller_partner_id = seller.partner_id
LEFT JOIN dbo.ORDER_LINE ol
    ON so.order_id = ol.order_id
GROUP BY
    so.order_id,
    so.order_number,
    so.order_date,
    so.order_status,
    so.priority_level,
    buyer.partner_name,
    seller.partner_name;
GO

CREATE VIEW dbo.vw_ShipmentTracking
AS
SELECT
    s.shipment_id,
    s.shipment_number,
    s.order_id,
    so.order_number,
    s.ship_date,
    s.expected_delivery_date,
    s.delivery_date,
    s.shipment_status,
    s.tracking_reference,
    lf.location_name AS ship_from_location,
    lt.location_name AS ship_to_location,
    COUNT(DISTINCT si.shipment_item_id) AS total_shipment_items,
    ISNULL(SUM(si.shipped_quantity), 0) AS total_quantity_shipped
FROM dbo.SHIPMENT s
INNER JOIN dbo.SALES_ORDER so
    ON s.order_id = so.order_id
INNER JOIN dbo.LOCATION lf
    ON s.ship_from_location_id = lf.location_id
INNER JOIN dbo.LOCATION lt
    ON s.ship_to_location_id = lt.location_id
LEFT JOIN dbo.SHIPMENT_ITEM si
    ON s.shipment_id = si.shipment_id
GROUP BY
    s.shipment_id,
    s.shipment_number,
    s.order_id,
    so.order_number,
    s.ship_date,
    s.expected_delivery_date,
    s.delivery_date,
    s.shipment_status,
    s.tracking_reference,
    lf.location_name,
    lt.location_name;
GO

CREATE VIEW dbo.vw_ProductSalesReport
AS
SELECT
    mp.product_id,
    mp.product_name,
    mp.brand_name,
    mp.dosage_form,
    mp.strength,
    mp.storage_category,
    COUNT(DISTINCT ol.order_line_id) AS total_order_lines,
    ISNULL(SUM(ol.requested_quantity), 0) AS total_quantity_ordered,
    ISNULL(SUM(ol.requested_quantity * ol.agreed_price), 0) AS total_revenue
FROM dbo.MEDICATION_PRODUCT mp
LEFT JOIN dbo.ORDER_LINE ol
    ON mp.product_id = ol.product_id
GROUP BY
    mp.product_id,
    mp.product_name,
    mp.brand_name,
    mp.dosage_form,
    mp.strength,
    mp.storage_category;
GO

PRINT 'Views created successfully.';
GO



-------------------------END OF VIEWS-------------------------------------





------------------------TRIGGERS---------------------------------------



USE PharmaSupplyChainDB;
GO

DROP TRIGGER IF EXISTS dbo.trg_AuditSalesOrderStatusChange;
GO

DROP TABLE IF EXISTS dbo.SALES_ORDER_AUDIT;
GO

CREATE TABLE dbo.SALES_ORDER_AUDIT
(
    audit_id        INT IDENTITY(1,1) PRIMARY KEY,
    order_id        INT NOT NULL,
    order_number    NVARCHAR(100) NOT NULL,
    old_status      NVARCHAR(30) NULL,
    new_status      NVARCHAR(30) NULL,
    changed_at      DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    changed_by      NVARCHAR(128) NOT NULL DEFAULT SUSER_SNAME(),
    remarks         NVARCHAR(250) NULL,
    CONSTRAINT FK_SALES_ORDER_AUDIT_ORDER
        FOREIGN KEY (order_id) REFERENCES dbo.SALES_ORDER(order_id)
);
GO

CREATE TRIGGER dbo.trg_AuditSalesOrderStatusChange
ON dbo.SALES_ORDER
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SALES_ORDER_AUDIT
    (
        order_id,
        order_number,
        old_status,
        new_status,
        changed_at,
        changed_by,
        remarks
    )
    SELECT
        d.order_id,
        d.order_number,
        d.order_status,
        i.order_status,
        SYSDATETIME(),
        SUSER_SNAME(),
        'Sales order status updated'
    FROM inserted i
    INNER JOIN deleted d
        ON i.order_id = d.order_id
    WHERE ISNULL(d.order_status, '') <> ISNULL(i.order_status, '');
END;
GO

PRINT 'Audit table and trigger created successfully.';
GO



-------------------END OF THE TRIGGERS--------------------------









