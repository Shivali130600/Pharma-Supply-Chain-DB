/* =========================================================
   PHARMACEUTICAL SUPPLY CHAIN DATABASE
   DDL SCRIPT
   SQL Server
   ========================================================= */

USE master;
GO

IF DB_ID('PharmaSupplyChainDB') IS NULL
BEGIN
    CREATE DATABASE PharmaSupplyChainDB;
END
GO

USE PharmaSupplyChainDB;
GO

/* =========================================================
   DROP TABLES IN CHILD-TO-PARENT ORDER
   ========================================================= */

DROP TABLE IF EXISTS RECALL_BATCH;
DROP TABLE IF EXISTS RECALL_EVENT;
DROP TABLE IF EXISTS COMPLIANCE_RECORD;
DROP TABLE IF EXISTS PAYMENT;
DROP TABLE IF EXISTS INVOICE;
DROP TABLE IF EXISTS STOCK_MOVEMENT;
DROP TABLE IF EXISTS INVENTORY_RESERVATION;
DROP TABLE IF EXISTS SHIPMENT_ITEM;
DROP TABLE IF EXISTS SHIPMENT;
DROP TABLE IF EXISTS ORDER_LINE;
DROP TABLE IF EXISTS SALES_ORDER;
DROP TABLE IF EXISTS INVENTORY_LOT;
DROP TABLE IF EXISTS BATCH;
DROP TABLE IF EXISTS PRODUCT_INGREDIENT;
DROP TABLE IF EXISTS REGULATORY_APPROVAL;
DROP TABLE IF EXISTS STORAGE_REQUIREMENT;
DROP TABLE IF EXISTS LICENSE;
DROP TABLE IF EXISTS PHARMACY_SITE;
DROP TABLE IF EXISTS WAREHOUSE;
DROP TABLE IF EXISTS PHARMACY;
DROP TABLE IF EXISTS DISTRIBUTOR;
DROP TABLE IF EXISTS MANUFACTURER;
DROP TABLE IF EXISTS MEDICATION_PRODUCT;
DROP TABLE IF EXISTS INGREDIENT;
DROP TABLE IF EXISTS PARTNER;
DROP TABLE IF EXISTS LOCATION;
GO

/* =========================================================
   PARENT TABLES
   ========================================================= */

CREATE TABLE PARTNER (
    partner_id               INT IDENTITY(1,1) PRIMARY KEY,
    partner_name             NVARCHAR(150) NOT NULL,
    contact_info             NVARCHAR(200) NULL,
    address                  NVARCHAR(250) NOT NULL,
    operational_status       NVARCHAR(30) NOT NULL,
    created_at               DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT CK_PARTNER_OPERATIONAL_STATUS
        CHECK (operational_status IN ('Active', 'Inactive', 'Suspended'))
);
GO

CREATE TABLE LOCATION (
    location_id              INT IDENTITY(1,1) PRIMARY KEY,
    location_name            NVARCHAR(150) NOT NULL,
    address                  NVARCHAR(250) NOT NULL,
    operating_hours          NVARCHAR(100) NULL
);
GO

CREATE TABLE MEDICATION_PRODUCT (
    product_id               INT IDENTITY(1,1) PRIMARY KEY,
    product_name             NVARCHAR(150) NOT NULL,
    brand_name               NVARCHAR(150) NULL,
    dosage_form              NVARCHAR(50) NOT NULL,
    strength                 NVARCHAR(50) NOT NULL,
    storage_category         NVARCHAR(50) NOT NULL,
    approval_status          NVARCHAR(30) NOT NULL,

    CONSTRAINT CK_MEDICATION_PRODUCT_DOSAGE_FORM
        CHECK (dosage_form IN ('Tablet', 'Capsule', 'Syrup', 'Injection', 'Ointment', 'Drops', 'Powder')),

    CONSTRAINT CK_MEDICATION_PRODUCT_STORAGE_CATEGORY
        CHECK (storage_category IN ('Ambient', 'Refrigerated', 'Frozen', 'Controlled')),

    CONSTRAINT CK_MEDICATION_PRODUCT_APPROVAL_STATUS
        CHECK (approval_status IN ('Approved', 'Pending', 'Rejected', 'Suspended'))
);
GO

CREATE TABLE INGREDIENT (
    ingredient_id            INT IDENTITY(1,1) PRIMARY KEY,
    ingredient_name          NVARCHAR(150) NOT NULL,
    ingredient_role          NVARCHAR(50) NOT NULL,

    CONSTRAINT CK_INGREDIENT_ROLE
        CHECK (ingredient_role IN ('Active', 'Inactive', 'Excipient', 'Preservative', 'Stabilizer', 'Colorant'))
);
GO

/* =========================================================
   SUBTYPE TABLES
   ========================================================= */

CREATE TABLE MANUFACTURER (
    partner_id               INT PRIMARY KEY,
    quality_certifications   NVARCHAR(200) NULL,
    manufacturing_capability NVARCHAR(200) NULL,

    CONSTRAINT FK_MANUFACTURER_PARTNER
        FOREIGN KEY (partner_id) REFERENCES PARTNER(partner_id)
        ON DELETE CASCADE
);
GO

CREATE TABLE DISTRIBUTOR (
    partner_id               INT PRIMARY KEY,
    distribution_region      NVARCHAR(100) NOT NULL,
    service_level            NVARCHAR(50) NOT NULL,

    CONSTRAINT FK_DISTRIBUTOR_PARTNER
        FOREIGN KEY (partner_id) REFERENCES PARTNER(partner_id)
        ON DELETE CASCADE,

    CONSTRAINT CK_DISTRIBUTOR_SERVICE_LEVEL
        CHECK (service_level IN ('Standard', 'Express', 'Priority'))
);
GO

CREATE TABLE PHARMACY (
    partner_id               INT PRIMARY KEY,
    pharmacy_type            NVARCHAR(50) NOT NULL,
    dispensing_capability    NVARCHAR(100) NOT NULL,

    CONSTRAINT FK_PHARMACY_PARTNER
        FOREIGN KEY (partner_id) REFERENCES PARTNER(partner_id)
        ON DELETE CASCADE,

    CONSTRAINT CK_PHARMACY_TYPE
        CHECK (pharmacy_type IN ('Retail', 'Hospital', 'Clinic', 'Online'))
);
GO

CREATE TABLE WAREHOUSE (
    location_id              INT PRIMARY KEY,
    storage_capacity         INT NOT NULL,
    warehouse_classification NVARCHAR(50) NOT NULL,

    CONSTRAINT FK_WAREHOUSE_LOCATION
        FOREIGN KEY (location_id) REFERENCES LOCATION(location_id)
        ON DELETE CASCADE,

    CONSTRAINT CK_WAREHOUSE_STORAGE_CAPACITY
        CHECK (storage_capacity >= 0),

    CONSTRAINT CK_WAREHOUSE_CLASSIFICATION
        CHECK (warehouse_classification IN ('Ambient', 'Cold Chain', 'Hazmat', 'General'))
);
GO

CREATE TABLE PHARMACY_SITE (
    location_id              INT PRIMARY KEY,
    store_hours              NVARCHAR(100) NULL,
    dispensing_area          NVARCHAR(100) NULL,

    CONSTRAINT FK_PHARMACY_SITE_LOCATION
        FOREIGN KEY (location_id) REFERENCES LOCATION(location_id)
        ON DELETE CASCADE
);
GO

/* =========================================================
   SUPPORTING TABLES
   ========================================================= */

CREATE TABLE LICENSE (
    license_id               INT IDENTITY(1,1) PRIMARY KEY,
    partner_id               INT NOT NULL,
    license_number           NVARCHAR(100) NOT NULL,
    license_type             NVARCHAR(50) NOT NULL,
    issuing_authority        NVARCHAR(100) NOT NULL,
    issue_date               DATE NOT NULL,
    expiry_date              DATE NOT NULL,
    license_status           NVARCHAR(30) NOT NULL,

    CONSTRAINT FK_LICENSE_PARTNER
        FOREIGN KEY (partner_id) REFERENCES PARTNER(partner_id),

    CONSTRAINT UQ_LICENSE_NUMBER
        UNIQUE (license_number),

    CONSTRAINT CK_LICENSE_DATES
        CHECK (expiry_date > issue_date),

    CONSTRAINT CK_LICENSE_STATUS
        CHECK (license_status IN ('Active', 'Expired', 'Suspended', 'Pending'))
);
GO

CREATE TABLE STORAGE_REQUIREMENT (
    product_id               INT PRIMARY KEY,
    temperature_range        NVARCHAR(100) NOT NULL,
    humidity_constraints     NVARCHAR(100) NULL,
    light_protection         NVARCHAR(50) NULL,
    handling_notes           NVARCHAR(250) NULL,

    CONSTRAINT FK_STORAGE_REQUIREMENT_PRODUCT
        FOREIGN KEY (product_id) REFERENCES MEDICATION_PRODUCT(product_id)
        ON DELETE CASCADE
);
GO

CREATE TABLE REGULATORY_APPROVAL (
    approval_id              INT IDENTITY(1,1) PRIMARY KEY,
    product_id               INT NOT NULL,
    authority_name           NVARCHAR(100) NOT NULL,
    approval_reference       NVARCHAR(100) NOT NULL,
    approval_date            DATE NOT NULL,
    approval_status          NVARCHAR(30) NOT NULL,
    market_region            NVARCHAR(100) NOT NULL,

    CONSTRAINT FK_REGULATORY_APPROVAL_PRODUCT
        FOREIGN KEY (product_id) REFERENCES MEDICATION_PRODUCT(product_id),

    CONSTRAINT UQ_APPROVAL_REFERENCE
        UNIQUE (approval_reference),

    CONSTRAINT CK_REGULATORY_APPROVAL_STATUS
        CHECK (approval_status IN ('Approved', 'Pending', 'Rejected', 'Withdrawn'))
);
GO

CREATE TABLE PRODUCT_INGREDIENT (
    product_ingredient_id    INT IDENTITY(1,1) PRIMARY KEY,
    product_id               INT NOT NULL,
    ingredient_id            INT NOT NULL,
    quantity                 DECIMAL(12,2) NOT NULL,
    quantity_unit            NVARCHAR(20) NOT NULL,
    concentration_pct        DECIMAL(5,2) NULL,
    composition_notes        NVARCHAR(250) NULL,

    CONSTRAINT FK_PRODUCT_INGREDIENT_PRODUCT
        FOREIGN KEY (product_id) REFERENCES MEDICATION_PRODUCT(product_id),

    CONSTRAINT FK_PRODUCT_INGREDIENT_INGREDIENT
        FOREIGN KEY (ingredient_id) REFERENCES INGREDIENT(ingredient_id),

    CONSTRAINT CK_PRODUCT_INGREDIENT_QUANTITY
        CHECK (quantity > 0),

    CONSTRAINT CK_PRODUCT_INGREDIENT_CONCENTRATION
        CHECK (concentration_pct IS NULL OR (concentration_pct >= 0 AND concentration_pct <= 100)),

    CONSTRAINT UQ_PRODUCT_INGREDIENT
        UNIQUE (product_id, ingredient_id)
);
GO

CREATE TABLE BATCH (
    batch_id                 INT IDENTITY(1,1) PRIMARY KEY,
    product_id               INT NOT NULL,
    manufacturer_partner_id  INT NOT NULL,
    batch_code               NVARCHAR(100) NOT NULL,
    manufacturing_date       DATE NOT NULL,
    expiry_date              DATE NOT NULL,
    batch_status             NVARCHAR(30) NOT NULL,

    CONSTRAINT FK_BATCH_PRODUCT
        FOREIGN KEY (product_id) REFERENCES MEDICATION_PRODUCT(product_id),

    CONSTRAINT FK_BATCH_MANUFACTURER
        FOREIGN KEY (manufacturer_partner_id) REFERENCES MANUFACTURER(partner_id),

    CONSTRAINT UQ_BATCH_CODE
        UNIQUE (batch_code),

    CONSTRAINT CK_BATCH_DATES
        CHECK (expiry_date > manufacturing_date),

    CONSTRAINT CK_BATCH_STATUS
        CHECK (batch_status IN ('Produced', 'Released', 'Quarantined', 'Expired', 'Recalled'))
);
GO

/* =========================================================
   ORDERS AND INVENTORY
   ========================================================= */

CREATE TABLE SALES_ORDER (
    order_id                 INT IDENTITY(1,1) PRIMARY KEY,
    order_number             NVARCHAR(100) NOT NULL,
    buyer_partner_id         INT NOT NULL,
    seller_partner_id        INT NOT NULL,
    order_date               DATE NOT NULL,
    order_status             NVARCHAR(30) NOT NULL,
    priority_level           NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_SALES_ORDER_BUYER
        FOREIGN KEY (buyer_partner_id) REFERENCES PARTNER(partner_id),

    CONSTRAINT FK_SALES_ORDER_SELLER
        FOREIGN KEY (seller_partner_id) REFERENCES PARTNER(partner_id),

    CONSTRAINT UQ_SALES_ORDER_NUMBER
        UNIQUE (order_number),

    CONSTRAINT CK_SALES_ORDER_STATUS
        CHECK (order_status IN ('Created', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),

    CONSTRAINT CK_SALES_ORDER_PRIORITY
        CHECK (priority_level IN ('Low', 'Medium', 'High', 'Urgent')),

    CONSTRAINT CK_SALES_ORDER_PARTNERS_DIFFERENT
        CHECK (buyer_partner_id <> seller_partner_id)
);
GO

CREATE TABLE ORDER_LINE (
    order_line_id            INT IDENTITY(1,1) PRIMARY KEY,
    order_id                 INT NOT NULL,
    product_id               INT NOT NULL,
    requested_quantity       DECIMAL(12,2) NOT NULL,
    agreed_price             DECIMAL(12,2) NOT NULL,
    currency_code            CHAR(3) NOT NULL,
    line_status              NVARCHAR(30) NOT NULL,

    CONSTRAINT FK_ORDER_LINE_ORDER
        FOREIGN KEY (order_id) REFERENCES SALES_ORDER(order_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_ORDER_LINE_PRODUCT
        FOREIGN KEY (product_id) REFERENCES MEDICATION_PRODUCT(product_id),

    CONSTRAINT CK_ORDER_LINE_REQUESTED_QUANTITY
        CHECK (requested_quantity > 0),

    CONSTRAINT CK_ORDER_LINE_AGREED_PRICE
        CHECK (agreed_price >= 0),

    CONSTRAINT CK_ORDER_LINE_CURRENCY
        CHECK (currency_code IN ('USD', 'EUR', 'INR', 'GBP')),

    CONSTRAINT CK_ORDER_LINE_STATUS
        CHECK (line_status IN ('Pending', 'Allocated', 'Partially Shipped', 'Shipped', 'Cancelled'))
);
GO

CREATE TABLE INVENTORY_LOT (
    inventory_lot_id         INT IDENTITY(1,1) PRIMARY KEY,
    location_id              INT NOT NULL,
    batch_id                 INT NOT NULL,
    last_count_date          DATE NULL,

    CONSTRAINT FK_INVENTORY_LOT_LOCATION
        FOREIGN KEY (location_id) REFERENCES LOCATION(location_id),

    CONSTRAINT FK_INVENTORY_LOT_BATCH
        FOREIGN KEY (batch_id) REFERENCES BATCH(batch_id),

    CONSTRAINT UQ_INVENTORY_LOT_LOCATION_BATCH
        UNIQUE (location_id, batch_id)
);
GO

CREATE TABLE SHIPMENT (
    shipment_id              INT IDENTITY(1,1) PRIMARY KEY,
    shipment_number          NVARCHAR(100) NOT NULL,
    order_id                 INT NOT NULL,
    ship_from_location_id    INT NOT NULL,
    ship_to_location_id      INT NOT NULL,
    ship_date                DATE NOT NULL,
    expected_delivery_date   DATE NULL,
    delivery_date            DATE NULL,
    shipment_status          NVARCHAR(30) NOT NULL,
    tracking_reference       NVARCHAR(100) NULL,

    CONSTRAINT FK_SHIPMENT_ORDER
        FOREIGN KEY (order_id) REFERENCES SALES_ORDER(order_id),

    CONSTRAINT FK_SHIPMENT_FROM_LOCATION
        FOREIGN KEY (ship_from_location_id) REFERENCES LOCATION(location_id),

    CONSTRAINT FK_SHIPMENT_TO_LOCATION
        FOREIGN KEY (ship_to_location_id) REFERENCES LOCATION(location_id),

    CONSTRAINT UQ_SHIPMENT_NUMBER
        UNIQUE (shipment_number),

    CONSTRAINT CK_SHIPMENT_STATUS
        CHECK (shipment_status IN ('Created', 'Packed', 'In Transit', 'Delivered', 'Delayed', 'Cancelled')),

    CONSTRAINT CK_SHIPMENT_LOCATIONS_DIFFERENT
        CHECK (ship_from_location_id <> ship_to_location_id),

    CONSTRAINT CK_SHIPMENT_EXPECTED_DATE
        CHECK (expected_delivery_date IS NULL OR expected_delivery_date >= ship_date),

    CONSTRAINT CK_SHIPMENT_DELIVERY_DATE
        CHECK (delivery_date IS NULL OR delivery_date >= ship_date)
);
GO

CREATE TABLE SHIPMENT_ITEM (
    shipment_item_id         INT IDENTITY(1,1) PRIMARY KEY,
    shipment_id              INT NOT NULL,
    order_line_id            INT NOT NULL,
    batch_id                 INT NOT NULL,
    shipped_quantity         DECIMAL(12,2) NOT NULL,
    condition_notes          NVARCHAR(250) NULL,

    CONSTRAINT FK_SHIPMENT_ITEM_SHIPMENT
        FOREIGN KEY (shipment_id) REFERENCES SHIPMENT(shipment_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_SHIPMENT_ITEM_ORDER_LINE
        FOREIGN KEY (order_line_id) REFERENCES ORDER_LINE(order_line_id),

    CONSTRAINT FK_SHIPMENT_ITEM_BATCH
        FOREIGN KEY (batch_id) REFERENCES BATCH(batch_id),

    CONSTRAINT CK_SHIPMENT_ITEM_QUANTITY
        CHECK (shipped_quantity > 0)
);
GO

CREATE TABLE STOCK_MOVEMENT (
    movement_id              INT IDENTITY(1,1) PRIMARY KEY,
    batch_id                 INT NOT NULL,
    from_location_id         INT NULL,
    to_location_id           INT NULL,
    related_shipment_id      INT NULL,
    movement_date            DATETIME2 NOT NULL,
    movement_type            NVARCHAR(30) NOT NULL,
    quantity_moved           DECIMAL(12,2) NOT NULL,
    reason_code              NVARCHAR(100) NULL,

    CONSTRAINT FK_STOCK_MOVEMENT_BATCH
        FOREIGN KEY (batch_id) REFERENCES BATCH(batch_id),

    CONSTRAINT FK_STOCK_MOVEMENT_FROM_LOCATION
        FOREIGN KEY (from_location_id) REFERENCES LOCATION(location_id),

    CONSTRAINT FK_STOCK_MOVEMENT_TO_LOCATION
        FOREIGN KEY (to_location_id) REFERENCES LOCATION(location_id),

    CONSTRAINT FK_STOCK_MOVEMENT_SHIPMENT
        FOREIGN KEY (related_shipment_id) REFERENCES SHIPMENT(shipment_id),

    CONSTRAINT CK_STOCK_MOVEMENT_TYPE
        CHECK (movement_type IN ('Inbound', 'Outbound', 'Transfer', 'Adjustment', 'Return')),

    CONSTRAINT CK_STOCK_MOVEMENT_QUANTITY
        CHECK (quantity_moved > 0),

    CONSTRAINT CK_STOCK_MOVEMENT_LOCATIONS
        CHECK (
            from_location_id IS NOT NULL
            OR to_location_id IS NOT NULL
        )
);
GO

CREATE TABLE INVENTORY_RESERVATION (
    reservation_id           INT IDENTITY(1,1) PRIMARY KEY,
    order_line_id            INT NOT NULL,
    location_id              INT NOT NULL,
    batch_id                 INT NOT NULL,
    quantity_reserved        DECIMAL(12,2) NOT NULL,
    reservation_date         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    reservation_status       NVARCHAR(30) NOT NULL,

    CONSTRAINT FK_INVENTORY_RESERVATION_ORDER_LINE
        FOREIGN KEY (order_line_id) REFERENCES ORDER_LINE(order_line_id),

    CONSTRAINT FK_INVENTORY_RESERVATION_LOCATION
        FOREIGN KEY (location_id) REFERENCES LOCATION(location_id),

    CONSTRAINT FK_INVENTORY_RESERVATION_BATCH
        FOREIGN KEY (batch_id) REFERENCES BATCH(batch_id),

    CONSTRAINT CK_INVENTORY_RESERVATION_QUANTITY
        CHECK (quantity_reserved > 0),

    CONSTRAINT CK_INVENTORY_RESERVATION_STATUS
        CHECK (reservation_status IN ('Active', 'Released', 'Consumed', 'Cancelled'))
);
GO

/* =========================================================
   BILLING
   ========================================================= */

CREATE TABLE INVOICE (
    invoice_id               INT IDENTITY(1,1) PRIMARY KEY,
    invoice_number           NVARCHAR(100) NOT NULL,
    order_id                 INT NOT NULL,
    invoice_date             DATE NOT NULL,
    total_amount             DECIMAL(14,2) NOT NULL,
    due_date                 DATE NOT NULL,
    invoice_status           NVARCHAR(30) NOT NULL,

    CONSTRAINT FK_INVOICE_ORDER
        FOREIGN KEY (order_id) REFERENCES SALES_ORDER(order_id),

    CONSTRAINT UQ_INVOICE_NUMBER
        UNIQUE (invoice_number),

    CONSTRAINT CK_INVOICE_TOTAL_AMOUNT
        CHECK (total_amount >= 0),

    CONSTRAINT CK_INVOICE_DUE_DATE
        CHECK (due_date >= invoice_date),

    CONSTRAINT CK_INVOICE_STATUS
        CHECK (invoice_status IN ('Draft', 'Issued', 'Paid', 'Partially Paid', 'Overdue', 'Cancelled'))
);
GO

CREATE TABLE PAYMENT (
    payment_id               INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id               INT NOT NULL,
    payment_date             DATE NOT NULL,
    amount_paid              DECIMAL(14,2) NOT NULL,
    payment_method           NVARCHAR(30) NOT NULL,
    payment_status           NVARCHAR(30) NOT NULL,
    reference_note           NVARCHAR(150) NULL,

    CONSTRAINT FK_PAYMENT_INVOICE
        FOREIGN KEY (invoice_id) REFERENCES INVOICE(invoice_id),

    CONSTRAINT CK_PAYMENT_AMOUNT
        CHECK (amount_paid > 0),

    CONSTRAINT CK_PAYMENT_METHOD
        CHECK (payment_method IN ('Cash', 'Card', 'Bank Transfer', 'UPI', 'Check')),

    CONSTRAINT CK_PAYMENT_STATUS
        CHECK (payment_status IN ('Pending', 'Completed', 'Failed', 'Refunded'))
);
GO

/* =========================================================
   COMPLIANCE AND RECALL
   ========================================================= */

CREATE TABLE COMPLIANCE_RECORD (
    compliance_id            INT IDENTITY(1,1) PRIMARY KEY,
    partner_id               INT NOT NULL,
    location_id              INT NOT NULL,
    record_type              NVARCHAR(50) NOT NULL,
    record_date              DATE NOT NULL,
    outcome_status           NVARCHAR(30) NOT NULL,
    notes                    NVARCHAR(250) NULL,

    CONSTRAINT FK_COMPLIANCE_RECORD_PARTNER
        FOREIGN KEY (partner_id) REFERENCES PARTNER(partner_id),

    CONSTRAINT FK_COMPLIANCE_RECORD_LOCATION
        FOREIGN KEY (location_id) REFERENCES LOCATION(location_id),

    CONSTRAINT CK_COMPLIANCE_RECORD_TYPE
        CHECK (record_type IN ('Audit', 'Inspection', 'Deviation', 'CAPA', 'Certification Review')),

    CONSTRAINT CK_COMPLIANCE_RECORD_OUTCOME
        CHECK (outcome_status IN ('Passed', 'Failed', 'Open', 'Closed', 'Pending'))
);
GO

CREATE TABLE RECALL_EVENT (
    recall_event_id          INT IDENTITY(1,1) PRIMARY KEY,
    recall_reference         NVARCHAR(100) NOT NULL,
    recall_date              DATE NOT NULL,
    recall_reason            NVARCHAR(250) NOT NULL,
    recall_class             NVARCHAR(20) NOT NULL,
    recall_status            NVARCHAR(30) NOT NULL,

    CONSTRAINT UQ_RECALL_REFERENCE
        UNIQUE (recall_reference),

    CONSTRAINT CK_RECALL_CLASS
        CHECK (recall_class IN ('Class I', 'Class II', 'Class III')),

    CONSTRAINT CK_RECALL_STATUS
        CHECK (recall_status IN ('Open', 'In Progress', 'Closed'))
);
GO

CREATE TABLE RECALL_BATCH (
    recall_batch_id          INT IDENTITY(1,1) PRIMARY KEY,
    recall_event_id          INT NOT NULL,
    batch_id                 INT NOT NULL,
    action_required          NVARCHAR(150) NOT NULL,
    notification_date        DATE NOT NULL,
    resolution_status        NVARCHAR(30) NOT NULL,

    CONSTRAINT FK_RECALL_BATCH_EVENT
        FOREIGN KEY (recall_event_id) REFERENCES RECALL_EVENT(recall_event_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_RECALL_BATCH_BATCH
        FOREIGN KEY (batch_id) REFERENCES BATCH(batch_id),

    CONSTRAINT CK_RECALL_BATCH_RESOLUTION
        CHECK (resolution_status IN ('Pending', 'Resolved', 'Escalated'))
);
GO