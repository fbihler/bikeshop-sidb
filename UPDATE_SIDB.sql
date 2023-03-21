--Scenario
--Arch-Bike increased the production of 2 existing bikes and introduced a new bike.
--Production of existing bike:
-- -    200 more of product with Model id = 8, Color id = 2, Size id = 1
-- -    75 more of product with Model id = 3, Color id = 3, Size id = 2
--Production of a new bike:
-- -    ModelID: 10
-- -    Model_Code: MOXT1000 (category id is 4, it is an offroad bike)
-- -    Description: Mounting Bike
-- -    ColorID: 3
-- -    SizeID: 1
-- -    OH_Quantity: 100
-- -    Initial_Price: $2590

DECLARE
    pr1_id number;
    pr2_id number;
    pr3_id number;
    pr1_price number;
    pr2_price number;
    
    i number;
    j number;
    k number;
    
    SN number;
    NEWROW number;
    NEWAIS number;
    LASTINV number;
BEGIN
    --Update existing bike models
    SELECT ProductID INTO pr1_id FROM PRODUCT_BUILT WHERE ModelID = 8 AND ColorID = 2 AND SizeID = 1;
    SELECT ProductID INTO pr2_id FROM PRODUCT_BUILT WHERE ModelID = 3 AND ColorID = 3 AND SizeID = 2;
    SELECT Initial_Price INTO pr1_price FROM PRODUCT_BUILT WHERE ProductID = pr1_id;
    SELECT Initial_Price INTO pr2_price FROM PRODUCT_BUILT WHERE ProductID = pr2_id;
    
    SELECT MAX(Serial_NO) INTO SN FROM INVENTORY;
    SELECT MAX(Row_NO) INTO NEWROW FROM INVENTORY;
    SELECT MAX(Aisle_No) INTO NEWAIS FROM INVENTORY;
    SELECT MAX(InventoryID) INTO LASTINV FROM INVENTORY;
    NEWROW:= NEWROW +1;
    NEWAIS:= NEWAIS +1;
    
    <<loop>>
    FOR i in 1..200 LOOP
        SN:= SN+1;
        LASTINV := LASTINV+1;
        INSERT INTO Inventory (Serial_No, Aisle_No, Row_No, WarehouseID, ProductID) VALUES (SN, NEWAIS, NEWROW, 1, pr1_id);
        INSERT INTO Price (Price, InventoryID) VALUES (pr1_price, LASTINV);
    END LOOP;
    
    NEWROW:= NEWROW+1;
    
    FOR  j in 1..75 LOOP
        SN:= SN+1;
        LASTINV := LASTINV+1;
        INSERT INTO Inventory (Serial_No, Aisle_No, Row_No, WarehouseID, ProductID) VALUES (SN, NEWAIS, NEWROW, 1, pr2_id);
        INSERT INTO Price (Price, InventoryID) VALUES (pr2_price, LASTINV);
    END LOOP;
    
    UPDATE PRODUCT_BUILT SET OH_QUANTITY = OH_QUANTITY + 200 WHERE PRODUCTID = pr1_id;
    UPDATE PRODUCT_BUILT SET OH_QUANTITY = OH_QUANTITY + 70 WHERE PRODUCTID = pr2_id;

    --Create new Model and populate tables
    INSERT INTO Product_Model (Model_Code, CategoryID) VALUES ('MOXT1000', 4);
    INSERT INTO Model_Text (Description, ModelID) VALUES ('Mountain Bike', 10);
    INSERT INTO Product_Built (Initial_Price, OH_Quantity, ColorID, SizeID, ModelID) VALUES (2590, 100, 3, 1, 10);
    
    SELECT ProductID INTO pr3_id FROM PRODUCT_BUILT WHERE ModelID = 10 AND ColorID = 3 AND SizeID = 1;
    
    NEWROW:= NEWROW + 1;
    
    <<loop>>
    FOR k in 1..100 LOOP
        SN:= SN+1;
        LASTINV := LASTINV+1;
        INSERT INTO Inventory (Serial_No, Aisle_No, Row_No, WarehouseID, ProductID) VALUES (SN, NEWAIS, NEWROW, 1, pr3_id);
        INSERT INTO Price (Price, InventoryID) VALUES (2590, LASTINV);
    END LOOP;
END;



