CREATE OR REPLACE PROCEDURE SECOND_HIGHEST_ORDER_TOTAL_AMOUNT
AS  
    cursor1 SYS_REFCURSOR;  
BEGIN 
    OPEN cursor1 FOR
    WITH selection_criteria AS (
        SELECT DISTINCT
            LTRIM(REPLACE(A.ORDER_REF, 'PO', ''), '0') AS "Order Reference", 
            TO_CHAR(A.ORDER_DATE, 'FMMonth DD, YYYY') AS "Order Date", 
            UPPER(B.SUPPLIER_NAME) AS "Supplier Name",
            TO_CHAR(A.ORDER_TOTAL_AMOUNT, '99,999,990.00') AS "Order Total Amount", 
            A.ORDER_STATUS AS "Order Status",
            (SELECT LISTAGG(INVOICE_REFERENCE, '|') WITHIN GROUP (ORDER BY INVOICE_REFERENCE) 
             FROM XXBCM_INVOICE INV WHERE INV.ORDER_ID = A.ORDER_ID) AS "Invoice References",
            ROW_NUMBER() OVER (ORDER BY A.ORDER_TOTAL_AMOUNT DESC) AS RNUM
        FROM XXBCM_ORDER A
        INNER JOIN XXBCM_SUPPLIER B ON B.SUPPLIER_ID = A.SUPPLIER_ID
    )
        
    SELECT "Order Reference", "Order Date", "Supplier Name", "Order Total Amount", "Order Status", "Invoice References"  
    FROM selection_criteria WHERE RNUM = 2;
    
    DBMS_SQL.RETURN_RESULT(cursor1);
END;
/