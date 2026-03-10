USE PharmaSupplyChainDB;
GO

/* =========================================================
   PARTNER
   1-10  = Manufacturers
   11-20 = Distributors
   21-30 = Pharmacies
   ========================================================= */

INSERT INTO PARTNER (partner_name, contact_info, address, operational_status, created_at) VALUES
('Pfizer Manufacturing Unit', 'pfizer.mfg@pharma.com', 'Boston, MA', 'Active', '2026-01-01'),
('Moderna Biologics Plant', 'moderna.mfg@pharma.com', 'Cambridge, MA', 'Active', '2026-01-02'),
('Novartis Production Hub', 'novartis.mfg@pharma.com', 'East Hanover, NJ', 'Active', '2026-01-03'),
('GSK Sterile Facility', 'gsk.mfg@pharma.com', 'Philadelphia, PA', 'Active', '2026-01-04'),
('AbbVie Packaging Center', 'abbvie.mfg@pharma.com', 'Chicago, IL', 'Active', '2026-01-05'),
('Merck Oral Dosage Plant', 'merck.mfg@pharma.com', 'Rahway, NJ', 'Active', '2026-01-06'),
('J&J Injectable Facility', 'jnj.mfg@pharma.com', 'New Brunswick, NJ', 'Active', '2026-01-07'),
('Sanofi Vaccine Unit', 'sanofi.mfg@pharma.com', 'Swiftwater, PA', 'Active', '2026-01-08'),
('Lilly API Facility', 'lilly.mfg@pharma.com', 'Indianapolis, IN', 'Active', '2026-01-09'),
('Bayer Tablet Production', 'bayer.mfg@pharma.com', 'Whippany, NJ', 'Active', '2026-01-10'),

('McKesson Distribution', 'mckesson.dist@pharma.com', 'Dallas, TX', 'Active', '2026-01-11'),
('Cardinal Health Logistics', 'cardinal.dist@pharma.com', 'Dublin, OH', 'Active', '2026-01-12'),
('AmerisourceBergen Supply', 'ab.dist@pharma.com', 'Conshohocken, PA', 'Active', '2026-01-13'),
('HealthPrime Distribution', 'healthprime.dist@pharma.com', 'Atlanta, GA', 'Active', '2026-01-14'),
('MediFlow Distributors', 'mediflow.dist@pharma.com', 'Phoenix, AZ', 'Active', '2026-01-15'),
('RxRoute Supply Chain', 'rxroute.dist@pharma.com', 'Denver, CO', 'Active', '2026-01-16'),
('PharmaBridge Wholesale', 'pharmabridge.dist@pharma.com', 'Seattle, WA', 'Active', '2026-01-17'),
('SureMeds Distribution', 'suremeds.dist@pharma.com', 'Miami, FL', 'Active', '2026-01-18'),
('CareLink Distributors', 'carelink.dist@pharma.com', 'Detroit, MI', 'Active', '2026-01-19'),
('NationWide Pharma Supply', 'nationwide.dist@pharma.com', 'Charlotte, NC', 'Active', '2026-01-20'),

('CVS Pharmacy Boston', 'cvs.boston@pharma.com', 'Boston, MA', 'Active', '2026-01-21'),
('Walgreens Cambridge', 'walgreens.cambridge@pharma.com', 'Cambridge, MA', 'Active', '2026-01-22'),
('Rite Aid Newark', 'riteaid.newark@pharma.com', 'Newark, NJ', 'Active', '2026-01-23'),
('CityCare Pharmacy', 'citycare@pharma.com', 'Chicago, IL', 'Active', '2026-01-24'),
('HealthFirst Drugs', 'healthfirst@pharma.com', 'Houston, TX', 'Active', '2026-01-25'),
('Wellness Meds', 'wellness@pharma.com', 'San Diego, CA', 'Active', '2026-01-26'),
('QuickRx Pharmacy', 'quickrx@pharma.com', 'Austin, TX', 'Active', '2026-01-27'),
('CarePlus Pharmacy', 'careplus@pharma.com', 'San Jose, CA', 'Active', '2026-01-28'),
('Community Health Pharmacy', 'community@pharma.com', 'Orlando, FL', 'Active', '2026-01-29'),
('MetroMeds Pharmacy', 'metromeds@pharma.com', 'New York, NY', 'Active', '2026-01-30');
GO

/* =========================================================
   MANUFACTURER
   ========================================================= */

INSERT INTO MANUFACTURER (partner_id, quality_certifications, manufacturing_capability) VALUES
(1, 'FDA GMP, ISO 13485', 'Tablets and Capsules'),
(2, 'FDA GMP, WHO GMP', 'Biologics and Vaccines'),
(3, 'ISO 9001, FDA GMP', 'Sterile Injectables'),
(4, 'FDA GMP, EU GMP', 'Injectables and Syrups'),
(5, 'FDA GMP, ISO 9001', 'Packaging and Labeling'),
(6, 'WHO GMP, FDA GMP', 'Oral Solid Dosage'),
(7, 'FDA GMP, EU GMP', 'Parenteral Products'),
(8, 'WHO GMP, ISO 13485', 'Vaccines'),
(9, 'FDA GMP, ISO 9001', 'API and Powder Forms'),
(10, 'FDA GMP, WHO GMP', 'Tablet Manufacturing');
GO

/* =========================================================
   DISTRIBUTOR
   ========================================================= */

INSERT INTO DISTRIBUTOR (partner_id, distribution_region, service_level) VALUES
(11, 'South', 'Priority'),
(12, 'Midwest', 'Express'),
(13, 'Northeast', 'Priority'),
(14, 'Southeast', 'Standard'),
(15, 'West', 'Express'),
(16, 'Mountain', 'Standard'),
(17, 'Northwest', 'Priority'),
(18, 'Southeast', 'Express'),
(19, 'Midwest', 'Standard'),
(20, 'National', 'Priority');
GO

/* =========================================================
   PHARMACY
   ========================================================= */

INSERT INTO PHARMACY (partner_id, pharmacy_type, dispensing_capability) VALUES
(21, 'Retail', 'Prescription and OTC'),
(22, 'Retail', 'Prescription and OTC'),
(23, 'Retail', 'Prescription Only'),
(24, 'Hospital', 'Prescription and Controlled'),
(25, 'Clinic', 'Prescription Only'),
(26, 'Online', 'Mail Order Dispensing'),
(27, 'Retail', 'Prescription and OTC'),
(28, 'Retail', 'Prescription Only'),
(29, 'Clinic', 'Prescription and OTC'),
(30, 'Hospital', 'Controlled Substance Dispensing');
GO

/* =========================================================
   LOCATION
   1-10  = Warehouses
   11-20 = Pharmacy Sites
   ========================================================= */

INSERT INTO LOCATION (location_name, address, operating_hours) VALUES
('Boston Central Warehouse', 'Boston, MA', '24/7'),
('Cambridge Cold Storage', 'Cambridge, MA', '24/7'),
('Newark Regional Warehouse', 'Newark, NJ', '24/7'),
('Chicago Distribution Hub', 'Chicago, IL', '24/7'),
('Houston Pharma Depot', 'Houston, TX', '24/7'),
('San Diego Supply Hub', 'San Diego, CA', '24/7'),
('Austin Medical Warehouse', 'Austin, TX', '24/7'),
('San Jose Storage Center', 'San Jose, CA', '24/7'),
('Orlando Healthcare Depot', 'Orlando, FL', '24/7'),
('New York Main Warehouse', 'New York, NY', '24/7'),

('CVS Boston Site', 'Boston, MA', '8AM-10PM'),
('Walgreens Cambridge Site', 'Cambridge, MA', '8AM-9PM'),
('Rite Aid Newark Site', 'Newark, NJ', '9AM-9PM'),
('CityCare Hospital Site', 'Chicago, IL', '24/7'),
('HealthFirst Clinic Site', 'Houston, TX', '8AM-8PM'),
('Wellness Online Fulfillment', 'San Diego, CA', '24/7'),
('QuickRx Austin Site', 'Austin, TX', '8AM-10PM'),
('CarePlus San Jose Site', 'San Jose, CA', '8AM-9PM'),
('Community Orlando Site', 'Orlando, FL', '8AM-8PM'),
('MetroMeds NYC Site', 'New York, NY', '24/7');
GO

/* =========================================================
   WAREHOUSE
   ========================================================= */

INSERT INTO WAREHOUSE (location_id, storage_capacity, warehouse_classification) VALUES
(1, 50000, 'General'),
(2, 30000, 'Cold Chain'),
(3, 45000, 'General'),
(4, 55000, 'General'),
(5, 40000, 'Ambient'),
(6, 35000, 'Cold Chain'),
(7, 30000, 'General'),
(8, 32000, 'Ambient'),
(9, 28000, 'General'),
(10, 60000, 'Cold Chain');
GO

/* =========================================================
   PHARMACY_SITE
   ========================================================= */

INSERT INTO PHARMACY_SITE (location_id, store_hours, dispensing_area) VALUES
(11, '8AM-10PM', 'Front Counter'),
(12, '8AM-9PM', 'Main Dispensing Desk'),
(13, '9AM-9PM', 'Retail Counter'),
(14, '24/7', 'Hospital Pharmacy Wing'),
(15, '8AM-8PM', 'Clinic Dispensing Area'),
(16, '24/7', 'Online Fulfillment Area'),
(17, '8AM-10PM', 'Retail Counter'),
(18, '8AM-9PM', 'Prescription Desk'),
(19, '8AM-8PM', 'Clinic Counter'),
(20, '24/7', 'Emergency Dispensing Unit');
GO

/* =========================================================
   LICENSE
   ========================================================= */

INSERT INTO LICENSE (partner_id, license_number, license_type, issuing_authority, issue_date, expiry_date, license_status) VALUES
(1, 'LIC-MFG-001', 'Manufacturing', 'FDA', '2025-01-01', '2028-01-01', 'Active'),
(2, 'LIC-MFG-002', 'Manufacturing', 'FDA', '2025-01-02', '2028-01-02', 'Active'),
(3, 'LIC-MFG-003', 'Manufacturing', 'FDA', '2025-01-03', '2028-01-03', 'Active'),
(11, 'LIC-DIS-001', 'Distribution', 'State Board', '2025-02-01', '2028-02-01', 'Active'),
(12, 'LIC-DIS-002', 'Distribution', 'State Board', '2025-02-02', '2028-02-02', 'Active'),
(13, 'LIC-DIS-003', 'Distribution', 'State Board', '2025-02-03', '2028-02-03', 'Active'),
(21, 'LIC-PHA-001', 'Pharmacy', 'State Board', '2025-03-01', '2028-03-01', 'Active'),
(22, 'LIC-PHA-002', 'Pharmacy', 'State Board', '2025-03-02', '2028-03-02', 'Active'),
(23, 'LIC-PHA-003', 'Pharmacy', 'State Board', '2025-03-03', '2028-03-03', 'Active'),
(24, 'LIC-PHA-004', 'Pharmacy', 'State Board', '2025-03-04', '2028-03-04', 'Active');
GO

/* =========================================================
   MEDICATION_PRODUCT
   ========================================================= */

INSERT INTO MEDICATION_PRODUCT (product_name, brand_name, dosage_form, strength, storage_category, approval_status) VALUES
('Paracetamol Tablet', 'Tylenex', 'Tablet', '500mg', 'Ambient', 'Approved'),
('Ibuprofen Capsule', 'IbuCare', 'Capsule', '200mg', 'Ambient', 'Approved'),
('Amoxicillin Syrup', 'AmoxiPlus', 'Syrup', '250mg/5ml', 'Refrigerated', 'Approved'),
('Insulin Injection', 'GlucoFast', 'Injection', '100IU/ml', 'Refrigerated', 'Approved'),
('Hydrocortisone Ointment', 'CortiRelief', 'Ointment', '1%', 'Ambient', 'Approved'),
('Vitamin D Drops', 'D-Vita', 'Drops', '400IU/ml', 'Ambient', 'Approved'),
('Omeprazole Capsule', 'OmeSafe', 'Capsule', '20mg', 'Ambient', 'Approved'),
('Azithromycin Tablet', 'AzithroMed', 'Tablet', '500mg', 'Ambient', 'Approved'),
('Cough Relief Syrup', 'CoughNil', 'Syrup', '100ml', 'Ambient', 'Approved'),
('Ceftriaxone Injection', 'Cefrix', 'Injection', '1g', 'Controlled', 'Approved');
GO

/* =========================================================
   STORAGE_REQUIREMENT
   ========================================================= */

INSERT INTO STORAGE_REQUIREMENT (product_id, temperature_range, humidity_constraints, light_protection, handling_notes) VALUES
(1, '15-25C', 'Keep Dry', 'No Special Protection', 'Store in sealed container'),
(2, '15-25C', 'Keep Dry', 'No Special Protection', 'Avoid moisture'),
(3, '2-8C', 'Low Humidity', 'Protect from Light', 'Shake before use'),
(4, '2-8C', 'Low Humidity', 'Protect from Light', 'Do not freeze'),
(5, '15-25C', 'Normal', 'Protect from Light', 'Close cap tightly'),
(6, '15-25C', 'Normal', 'Protect from Light', 'Keep away from sunlight'),
(7, '15-25C', 'Keep Dry', 'No Special Protection', 'Store below 25C'),
(8, '15-25C', 'Keep Dry', 'No Special Protection', 'Keep in original pack'),
(9, '15-25C', 'Normal', 'Protect from Light', 'Keep bottle closed'),
(10, '2-8C', 'Low Humidity', 'Protect from Light', 'Sterile product');
GO

/* =========================================================
   REGULATORY_APPROVAL
   ========================================================= */

INSERT INTO REGULATORY_APPROVAL (product_id, authority_name, approval_reference, approval_date, approval_status, market_region) VALUES
(1, 'FDA', 'APP-001', '2025-04-01', 'Approved', 'USA'),
(2, 'FDA', 'APP-002', '2025-04-02', 'Approved', 'USA'),
(3, 'FDA', 'APP-003', '2025-04-03', 'Approved', 'USA'),
(4, 'FDA', 'APP-004', '2025-04-04', 'Approved', 'USA'),
(5, 'FDA', 'APP-005', '2025-04-05', 'Approved', 'USA'),
(6, 'FDA', 'APP-006', '2025-04-06', 'Approved', 'USA'),
(7, 'FDA', 'APP-007', '2025-04-07', 'Approved', 'USA'),
(8, 'FDA', 'APP-008', '2025-04-08', 'Approved', 'USA'),
(9, 'FDA', 'APP-009', '2025-04-09', 'Approved', 'USA'),
(10, 'FDA', 'APP-010', '2025-04-10', 'Approved', 'USA');
GO

/* =========================================================
   INGREDIENT
   ========================================================= */

INSERT INTO INGREDIENT (ingredient_name, ingredient_role) VALUES
('Paracetamol', 'Active'),
('Ibuprofen', 'Active'),
('Amoxicillin Trihydrate', 'Active'),
('Insulin Human', 'Active'),
('Hydrocortisone', 'Active'),
('Vitamin D3', 'Active'),
('Omeprazole', 'Active'),
('Azithromycin', 'Active'),
('Dextromethorphan', 'Active'),
('Ceftriaxone Sodium', 'Active');
GO

/* =========================================================
   PRODUCT_INGREDIENT
   ========================================================= */

INSERT INTO PRODUCT_INGREDIENT (product_id, ingredient_id, quantity, quantity_unit, concentration_pct, composition_notes) VALUES
(1, 1, 500.00, 'mg', 100.00, 'Single active ingredient'),
(2, 2, 200.00, 'mg', 100.00, 'Single active ingredient'),
(3, 3, 250.00, 'mg', 5.00, 'Per 5 ml syrup'),
(4, 4, 100.00, 'IU', 100.00, 'Sterile injectable'),
(5, 5, 1.00, '%', 1.00, 'Topical formulation'),
(6, 6, 400.00, 'IU', 100.00, 'Pediatric drops'),
(7, 7, 20.00, 'mg', 100.00, 'Capsule product'),
(8, 8, 500.00, 'mg', 100.00, 'Tablet product'),
(9, 9, 15.00, 'mg', 15.00, 'Cough syrup formulation'),
(10, 10, 1.00, 'g', 100.00, 'Sterile injectable antibiotic');
GO

/* =========================================================
   BATCH
   ========================================================= */

INSERT INTO BATCH (product_id, manufacturer_partner_id, batch_code, manufacturing_date, expiry_date, batch_status) VALUES
(1, 1, 'BATCH-001', '2026-01-05', '2028-01-05', 'Released'),
(2, 2, 'BATCH-002', '2026-01-06', '2028-01-06', 'Recalled'),
(3, 3, 'BATCH-003', '2026-01-07', '2027-01-07', 'Recalled'),
(4, 4, 'BATCH-004', '2026-01-08', '2027-01-08', 'Recalled'),
(5, 5, 'BATCH-005', '2026-01-09', '2028-01-09', 'Recalled'),
(6, 6, 'BATCH-006', '2026-01-10', '2028-01-10', 'Recalled'),
(7, 7, 'BATCH-007', '2026-01-11', '2028-01-11', 'Released'),
(8, 8, 'BATCH-008', '2026-01-12', '2028-01-12', 'Recalled'),
(9, 9, 'BATCH-009', '2026-01-13', '2027-01-13', 'Recalled'),
(10, 10, 'BATCH-010', '2026-01-14', '2027-01-14', 'Recalled');
GO

/* =========================================================
   SALES_ORDER
   Buyers: 21-30
   Sellers: 11-20
   ========================================================= */

INSERT INTO SALES_ORDER (order_number, buyer_partner_id, seller_partner_id, order_date, order_status, priority_level) VALUES
('ORD-001', 21, 11, '2026-02-01', 'Processing', 'High'),
('ORD-002', 22, 12, '2026-02-02', 'Processing', 'Medium'),
('ORD-003', 23, 13, '2026-02-03', 'Shipped', 'High'),
('ORD-004', 24, 14, '2026-02-04', 'Delivered', 'Urgent'),
('ORD-005', 25, 15, '2026-02-05', 'Processing', 'Medium'),
('ORD-006', 26, 16, '2026-02-06', 'Shipped', 'Low'),
('ORD-007', 27, 17, '2026-02-07', 'Delivered', 'High'),
('ORD-008', 28, 18, '2026-02-08', 'Processing', 'Medium'),
('ORD-009', 29, 19, '2026-02-09', 'Created', 'Low'),
('ORD-010', 30, 20, '2026-02-10', 'Confirmed', 'Urgent');
GO

/* =========================================================
   ORDER_LINE
   ========================================================= */

INSERT INTO ORDER_LINE (order_id, product_id, requested_quantity, agreed_price, currency_code, line_status) VALUES
(1, 1, 100.00, 45.00, 'USD', 'Allocated'),
(2, 2, 150.00, 60.00, 'USD', 'Allocated'),
(3, 3, 80.00, 75.00, 'USD', 'Partially Shipped'),
(4, 4, 50.00, 150.00, 'USD', 'Shipped'),
(5, 5, 120.00, 35.00, 'USD', 'Allocated'),
(6, 6, 200.00, 25.00, 'USD', 'Partially Shipped'),
(7, 7, 110.00, 55.00, 'USD', 'Shipped'),
(8, 8, 90.00, 70.00, 'USD', 'Allocated'),
(9, 9, 75.00, 40.00, 'USD', 'Pending'),
(10, 10, 60.00, 125.00, 'USD', 'Pending');
GO

/* =========================================================
   INVENTORY_LOT
   ========================================================= */

INSERT INTO INVENTORY_LOT (location_id, batch_id, last_count_date) VALUES
(1, 1, '2026-02-01'),
(2, 2, '2026-02-01'),
(3, 3, '2026-02-01'),
(4, 4, '2026-02-01'),
(5, 5, '2026-02-01'),
(6, 6, '2026-02-01'),
(7, 7, '2026-02-01'),
(8, 8, '2026-02-01'),
(9, 9, '2026-02-01'),
(10, 10, '2026-02-01');
GO

/* =========================================================
   SHIPMENT
   ========================================================= */

INSERT INTO SHIPMENT (shipment_number, order_id, ship_from_location_id, ship_to_location_id, ship_date, expected_delivery_date, delivery_date, shipment_status, tracking_reference) VALUES
('SHIP-001', 1, 1, 11, '2026-02-03', '2026-02-05', NULL, 'In Transit', 'TRK-001'),
('SHIP-002', 2, 2, 12, '2026-02-04', '2026-02-06', NULL, 'Packed', 'TRK-002'),
('SHIP-003', 3, 3, 13, '2026-02-05', '2026-02-07', NULL, 'In Transit', 'TRK-003'),
('SHIP-004', 4, 4, 14, '2026-02-06', '2026-02-08', '2026-02-08', 'Delivered', 'TRK-004'),
('SHIP-005', 5, 5, 15, '2026-02-07', '2026-02-09', NULL, 'Created', 'TRK-005'),
('SHIP-006', 6, 6, 16, '2026-02-08', '2026-02-10', NULL, 'In Transit', 'TRK-006'),
('SHIP-007', 7, 7, 17, '2026-02-09', '2026-02-11', '2026-02-11', 'Delivered', 'TRK-007'),
('SHIP-008', 8, 8, 18, '2026-02-10', '2026-02-12', NULL, 'Packed', 'TRK-008'),
('SHIP-009', 9, 9, 19, '2026-02-11', '2026-02-13', NULL, 'Created', 'TRK-009'),
('SHIP-010', 10, 10, 20, '2026-02-12', '2026-02-14', NULL, 'Created', 'TRK-010');
GO

/* =========================================================
   SHIPMENT_ITEM
   Partial shipment support retained
   ========================================================= */

INSERT INTO SHIPMENT_ITEM (shipment_id, order_line_id, batch_id, shipped_quantity, condition_notes) VALUES
(1, 1, 1, 60.00, 'Partial shipment for first allocation'),
(2, 2, 2, 100.00, 'Partial shipment dispatched'),
(3, 3, 3, 40.00, 'First partial shipment for syrup order'),
(4, 4, 4, 50.00, 'Full quantity delivered'),
(5, 5, 5, 70.00, 'Initial partial shipment'),
(6, 6, 6, 120.00, 'Partial quantity shipped'),
(7, 7, 7, 110.00, 'Complete order line fulfilled'),
(8, 8, 8, 45.00, 'First half of requested quantity'),
(9, 9, 9, 30.00, 'Initial dispatch created'),
(10, 10, 10, 20.00, 'First shipment against urgent order');
GO

/* =========================================================
   STOCK_MOVEMENT
   ========================================================= */

INSERT INTO STOCK_MOVEMENT (batch_id, from_location_id, to_location_id, related_shipment_id, movement_date, movement_type, quantity_moved, reason_code) VALUES
(1, 1, 11, 1, '2026-02-03 09:00:00', 'Outbound', 60.00, 'Order Fulfillment'),
(2, 2, 12, 2, '2026-02-04 10:00:00', 'Outbound', 100.00, 'Order Fulfillment'),
(3, 3, 13, 3, '2026-02-05 11:00:00', 'Outbound', 40.00, 'Partial Shipment'),
(4, 4, 14, 4, '2026-02-06 12:00:00', 'Outbound', 50.00, 'Delivered Shipment'),
(5, 5, 15, 5, '2026-02-07 13:00:00', 'Outbound', 70.00, 'Order Fulfillment'),
(6, 6, 16, 6, '2026-02-08 14:00:00', 'Outbound', 120.00, 'Partial Shipment'),
(7, 7, 17, 7, '2026-02-09 15:00:00', 'Outbound', 110.00, 'Delivered Shipment'),
(8, 8, 18, 8, '2026-02-10 16:00:00', 'Outbound', 45.00, 'Initial Shipment'),
(9, 9, 19, 9, '2026-02-11 17:00:00', 'Outbound', 30.00, 'Initial Shipment'),
(10, 10, 20, 10, '2026-02-12 18:00:00', 'Outbound', 20.00, 'Urgent Dispatch');
GO

/* =========================================================
   INVENTORY_RESERVATION
   ========================================================= */

INSERT INTO INVENTORY_RESERVATION (order_line_id, location_id, batch_id, quantity_reserved, reservation_date, reservation_status) VALUES
(1, 1, 1, 100.00, '2026-02-02 09:00:00', 'Active'),
(2, 2, 2, 150.00, '2026-02-03 09:00:00', 'Active'),
(3, 3, 3, 80.00, '2026-02-04 09:00:00', 'Consumed'),
(4, 4, 4, 50.00, '2026-02-05 09:00:00', 'Consumed'),
(5, 5, 5, 120.00, '2026-02-06 09:00:00', 'Active'),
(6, 6, 6, 200.00, '2026-02-07 09:00:00', 'Consumed'),
(7, 7, 7, 110.00, '2026-02-08 09:00:00', 'Consumed'),
(8, 8, 8, 90.00, '2026-02-09 09:00:00', 'Active'),
(9, 9, 9, 75.00, '2026-02-10 09:00:00', 'Active'),
(10, 10, 10, 60.00, '2026-02-11 09:00:00', 'Active');
GO

/* =========================================================
   INVOICE
   ========================================================= */

INSERT INTO INVOICE (invoice_number, order_id, invoice_date, total_amount, due_date, invoice_status) VALUES
('INV-001', 1, '2026-02-03', 4500.00, '2026-03-03', 'Paid'),
('INV-002', 2, '2026-02-04', 9000.00, '2026-03-04', 'Issued'),
('INV-003', 3, '2026-02-05', 6000.00, '2026-03-05', 'Partially Paid'),
('INV-004', 4, '2026-02-06', 7500.00, '2026-03-06', 'Paid'),
('INV-005', 5, '2026-02-07', 4200.00, '2026-03-07', 'Issued'),
('INV-006', 6, '2026-02-08', 5000.00, '2026-03-08', 'Partially Paid'),
('INV-007', 7, '2026-02-09', 6050.00, '2026-03-09', 'Paid'),
('INV-008', 8, '2026-02-10', 6300.00, '2026-03-10', 'Issued'),
('INV-009', 9, '2026-02-11', 3000.00, '2026-03-11', 'Draft'),
('INV-010', 10, '2026-02-12', 7500.00, '2026-03-12', 'Draft');
GO

/* =========================================================
   PAYMENT
   ========================================================= */

INSERT INTO PAYMENT (invoice_id, payment_date, amount_paid, payment_method, payment_status, reference_note) VALUES
(1, '2026-02-10', 4500.00, 'Bank Transfer', 'Completed', 'Full payment received'),
(2, '2026-02-11', 4500.00, 'Card', 'Completed', 'First partial payment'),
(3, '2026-02-12', 3000.00, 'Bank Transfer', 'Completed', 'Partial payment'),
(4, '2026-02-13', 7500.00, 'Bank Transfer', 'Completed', 'Invoice fully paid'),
(5, '2026-02-14', 2000.00, 'UPI', 'Completed', 'Advance payment'),
(6, '2026-02-15', 2500.00, 'Card', 'Completed', 'Partial payment'),
(7, '2026-02-16', 6050.00, 'Bank Transfer', 'Completed', 'Settled in full'),
(8, '2026-02-17', 3000.00, 'Check', 'Pending', 'Cheque submitted'),
(9, '2026-02-18', 1000.00, 'Cash', 'Completed', 'Draft invoice advance'),
(10, '2026-02-19', 2500.00, 'Bank Transfer', 'Pending', 'Urgent order partial payment');
GO

/* =========================================================
   COMPLIANCE_RECORD
   ========================================================= */

INSERT INTO COMPLIANCE_RECORD (partner_id, location_id, record_type, record_date, outcome_status, notes) VALUES
(1, 1, 'Audit', '2026-01-15', 'Passed', 'Manufacturing audit passed'),
(2, 2, 'Inspection', '2026-01-16', 'Passed', 'Cold storage compliant'),
(3, 3, 'Deviation', '2026-01-17', 'Closed', 'Minor documentation deviation'),
(11, 1, 'Certification Review', '2026-01-18', 'Passed', 'Distributor certification renewed'),
(12, 2, 'Audit', '2026-01-19', 'Passed', 'Warehouse operations compliant'),
(21, 11, 'Inspection', '2026-01-20', 'Passed', 'Retail site inspected'),
(22, 12, 'CAPA', '2026-01-21', 'Open', 'CAPA in progress'),
(24, 14, 'Audit', '2026-01-22', 'Passed', 'Hospital site passed audit'),
(29, 19, 'Inspection', '2026-01-23', 'Pending', 'Awaiting final report'),
(30, 20, 'Certification Review', '2026-01-24', 'Passed', 'Emergency dispensing certified');
GO

/* =========================================================
   RECALL_EVENT
   ========================================================= */

INSERT INTO RECALL_EVENT (recall_reference, recall_date, recall_reason, recall_class, recall_status) VALUES
('REC-001', '2026-02-01', 'Labeling discrepancy', 'Class III', 'Closed'),
('REC-002', '2026-02-02', 'Packaging defect', 'Class II', 'In Progress'),
('REC-003', '2026-02-03', 'Temperature excursion', 'Class II', 'Open'),
('REC-004', '2026-02-04', 'Stability concern', 'Class I', 'Open'),
('REC-005', '2026-02-05', 'Seal integrity issue', 'Class II', 'In Progress'),
('REC-006', '2026-02-06', 'Potency variance', 'Class I', 'Open'),
('REC-007', '2026-02-07', 'Misprint on carton', 'Class III', 'Closed'),
('REC-008', '2026-02-08', 'Foreign particle complaint', 'Class I', 'In Progress'),
('REC-009', '2026-02-09', 'Storage deviation', 'Class II', 'Open'),
('REC-010', '2026-02-10', 'Batch mix-up risk', 'Class I', 'Open');
GO

/* =========================================================
   RECALL_BATCH
   ========================================================= */

INSERT INTO RECALL_BATCH (recall_event_id, batch_id, action_required, notification_date, resolution_status) VALUES
(1, 1, 'Monitor distributed stock', '2026-02-02', 'Resolved'),
(2, 2, 'Return affected units', '2026-02-03', 'Pending'),
(3, 3, 'Quarantine remaining stock', '2026-02-04', 'Pending'),
(4, 4, 'Immediate recall from market', '2026-02-05', 'Escalated'),
(5, 5, 'Replace defective packaging', '2026-02-06', 'Pending'),
(6, 6, 'Investigate potency issue', '2026-02-07', 'Escalated'),
(7, 7, 'Correct carton print issue', '2026-02-08', 'Resolved'),
(8, 8, 'Collect field samples', '2026-02-09', 'Pending'),
(9, 9, 'Assess storage records', '2026-02-10', 'Pending'),
(10, 10, 'Market withdrawal initiated', '2026-02-11', 'Escalated');
GO