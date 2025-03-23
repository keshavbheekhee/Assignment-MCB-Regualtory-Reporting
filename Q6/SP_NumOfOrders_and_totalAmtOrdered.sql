CREATE OR REPLACE PROCEDURE NumOfOrders_and_totalAmtOrdered
AS  
    cursor1 SYS_REFCURSOR;  
BEGIN 
    OPEN cursor1 FOR
        SELECT 
            B.SUPPLIER_NAME AS "Supplier Name",
            C.SUPP_CONTACT_NAME AS "Supplier Contact Name",
            
            -- Extract and format first contact number
            CASE 
                WHEN INSTR(C.SUPP_CONTACT_NUMBER, ',') != 0 
                THEN REGEXP_REPLACE(REGEXP_SUBSTR(C.SUPP_CONTACT_NUMBER, '[^,]+'), '(\d{3,4})(\d{4})', '\1-\2') 
                ELSE REGEXP_REPLACE(C.SUPP_CONTACT_NUMBER, '(\d{3,4})(\d{4})', '\1-\2') 
            END AS "Supplier Contact No. 1",
            
            -- Extract and format second contact number
            CASE 
                WHEN INSTR(C.SUPP_CONTACT_NUMBER, ',') != 0 
                THEN REGEXP_REPLACE(REGEXP_SUBSTR(C.SUPP_CONTACT_NUMBER, '[^,]+$', 1, 1), '(\d{3,4})(\d{4})', '\1-\2') 
                ELSE '' 
            END AS "Supplier Contact No. 2",
            
            COUNT(A.ORDER_ID) AS "Total Orders",
            TO_CHAR(SUM(A.ORDER_TOTAL_AMOUNT), '99,999,990.00') AS "Order Total Amount" 
        
        FROM XXBCM_ORDER A
        INNER JOIN XXBCM_SUPPLIER B ON B.SUPPLIER_ID = A.SUPPLIER_ID
        INNER JOIN XXBCM_CONTACT C ON C.CONTACT_ID = B.CONTACT_ID
        
        -- Corrected date range
        WHERE A.ORDER_DATE BETWEEN TO_DATE('01 January 2022', 'dd Month yyyy') 
                               AND TO_DATE('31 August 2022', 'dd Month yyyy')

        -- Grouping by supplier
        GROUP BY B.SUPPLIER_NAME, 
                 C.SUPP_CONTACT_NAME, 
                 C.SUPP_CONTACT_NUMBER

        -- Ordering by Supplier Name (or Total Orders if preferred)
        ORDER BY B.SUPPLIER_NAME;

    DBMS_SQL.RETURN_RESULT(cursor1);
END;
/
