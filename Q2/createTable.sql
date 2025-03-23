-- Drop and recreate sequence for contact IDs
drop sequence contact_seq;
create sequence contact_seq start with 1 increment by 1 nocache nocycle;

-- Drop the XXBCM_CONTACT table if it exists and recreate it
drop table xxbcm_contact cascade constraints;

create table xxbcm_contact (
   contact_id          number(10) default contact_seq.nextval,
   supp_contact_name   varchar2(50),
   supp_address        varchar2(100),
   supp_contact_number varchar2(50),
   supp_email          varchar2(50),
   constraint pk_contact primary key ( contact_id )
);

-- Drop and recreate sequence for supplier IDs
drop sequence supplier_seq;
create sequence supplier_seq start with 1 increment by 1 nocache nocycle;

-- Drop the XXBCM_SUPPLIER table if it exists and recreate it
drop table xxbcm_supplier cascade constraints;

create table xxbcm_supplier (
   supplier_id   number(10) default supplier_seq.nextval,
   contact_id    number(10),
   supplier_name varchar2(50),
   constraint pk_supplier primary key ( supplier_id ),
   constraint fk_supplier foreign key ( contact_id )
      references XXBCM_contact ( contact_id )
);

-- Drop and recreate sequence for order IDs
drop sequence order_seq;
create sequence order_seq start with 1 increment by 1 nocache nocycle;

-- Drop the XXBCM_ORDER table if it exists and recreate it
drop table xxbcm_order cascade constraints;

create table xxbcm_order (
   order_id           number(10) default order_seq.nextval,
   supplier_id        number(10),
   order_ref          varchar2(20),
   order_date         date,
   order_total_amount number(10),
   order_description  varchar2(100),
   order_status       varchar2(10),
   order_line_amount  number(10),
   constraint pk_order primary key ( order_id ),
   constraint fk_order foreign key ( supplier_id )
      references XXBCM_supplier ( supplier_id )
);

-- Drop and recreate sequence for invoice IDs
drop sequence invoice_seq;
create sequence invoice_seq start with 1 increment by 1 nocache nocycle;

-- Drop the XXBCM_INVOICE table if it exists and recreate it
drop table xxbcm_invoice cascade constraints;

create table xxbcm_invoice (
   invoice_id          number(10) default invoice_seq.nextval,
   order_id            number(10),
   invoice_reference   varchar2(20),
   invoice_date        date,
   invoice_status      varchar2(10),
   invoice_hold_reason varchar2(50),
   invoice_amount      number(10),
   invoice_description varchar2(50),
   constraint pk_invoice primary key ( invoice_id ),
   constraint fk_invoice foreign key ( order_id )
      references XXBCM_order ( order_id )
);

-----------------------------------------------------------------------------------

-- Check to see if XXBCM_SUPPLIER is avalable and data succesfully loaded
DESC XXBCM_SUPPLIER;

SELECT * FROM XXBCM_SUPPLIER;

-- Check to see if XXBCM_CONTACT is avalable and data succesfully loaded
DESC XXBCM_CONTACT;

SELECT * FROM XXBCM_CONTACT;

-- Check to see if XXBCM_CONTACT is avalable and data succesfully loaded
DESC XXBCM_ORDER;

SELECT * FROM XXBCM_ORDER;

-- Check to see if XXBCM_INVOICE is avalable and data succesfully loaded
DESC XXBCM_INVOICE;

SELECT * FROM XXBCM_INVOICE;



