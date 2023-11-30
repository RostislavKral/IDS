-- Authors: xkralr06, xjezek19
/**
 * Na zaklade zpetne vazby jsme upravili ER diagram dle doporuceni pro reseni neodpovida diagramu z prvniho ukolu.
 *
 *
 *
 * Z hlediska pouziti v realnem svete, nam nedava smysl mazat jakkoukoliv entitu "hard-deletem" protoze jedna o pripadne bezpecnostni riziko. Nebylo by mozne zpetne
 * dohledat zadane platby a jejich udaje nebo informace o cinnosti zamestnance.
 * Tudiz, resenim je pouziti "soft-deletu", konkretne sloupec "deleted_at".
 * /

/**  Pro testovani */

DROP TABLE clients CASCADE constraints;
DROP TABLE users CASCADE constraints;
DROP TABLE payments CASCADE constraints;
DROP TABLE disponents CASCADE CONSTRAINTS;
DROP TABLE bank_accounts CASCADE CONSTRAINTS;
DROP TABLE bank_accounts_disponents CASCADE CONSTRAINTS;




-- -----------------------------------------------------
-- Table users
-- -----------------------------------------------------
CREATE TABLE users (
  id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
  first_name VARCHAR(191) NOT NULL,
  last_name VARCHAR(191) NOT NULL,
  username VARCHAR(191) NOT NULL UNIQUE,
  password VARCHAR(191) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT systimestamp,
  updated_at TIMESTAMP DEFAULT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  role INT DEFAULT 1 NOT NULL,
  PRIMARY KEY (id) );


-- -----------------------------------------------------
-- Table `clients`
-- -----------------------------------------------------
CREATE TABLE clients (
  id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
  first_name VARCHAR(191) NOT NULL,
  last_name VARCHAR(191) NOT NULL,
  email VARCHAR(191) NOT NULL,
  phone VARCHAR(191) NOT NULL,
  street VARCHAR(191) NOT NULL,
  street_number VARCHAR(191) NOT NULL,
  zip VARCHAR(6) NOT NULL,
  city VARCHAR(50) NOT NULL,
  delivery_street VARCHAR(191) DEFAULT NULL,
  delivery_street_number VARCHAR(191)  DEFAULT NULL,
  delivery_zip VARCHAR(191) DEFAULT NULL,
  delivery_city VARCHAR(191) DEFAULT NULL,
  personal_identification_number VARCHAR(191) NOT NULL, -- Rodne cislo
  identity_card_validity DATE NOT NULL,
  identity_card_number VARCHAR(191) DEFAULT NULL,
  created_at TIMESTAMP  DEFAULT systimestamp,
  updated_at TIMESTAMP DEFAULT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  authority VARCHAR(191) DEFAULT '',
  users_id NUMBER ,
  PRIMARY KEY (id),
  CONSTRAINT fk_clients_users1
    FOREIGN KEY (users_id)
    REFERENCES users (id));


ALTER TABLE clients -- Kontrola rodneho cisla
ADD CONSTRAINT check_rodne_cislo CHECK (REGEXP_LIKE(personal_identification_number, '^[0-9]{6}/[0-9]{4}$')
AND substr(personal_identification_number,1,2)<=31 AND substr(personal_identification_number,3,2)<=12);


-- -----------------------------------------------------
-- Table disponents
-- -----------------------------------------------------
CREATE TABLE disponents (
  id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
   first_name VARCHAR(191) NOT NULL,
  last_name VARCHAR(191) NOT NULL,
  email VARCHAR(191) NOT NULL,
  phone VARCHAR(191) NOT NULL,
  street VARCHAR(191) NOT NULL,
  street_number VARCHAR(191) NOT NULL,
  zip VARCHAR(6) NOT NULL,
  city VARCHAR(50) NOT NULL,
  delivery_street VARCHAR(191) DEFAULT NULL,
  delivery_street_number VARCHAR(191)  DEFAULT NULL,
  delivery_zip VARCHAR(191) DEFAULT NULL,
  delivery_city VARCHAR(191) DEFAULT NULL,
  personal_identification_number VARCHAR(191) NOT NULL, -- Rodne cislo
  identity_card_validity DATE NOT NULL,
  identity_card_number VARCHAR(191) NOT NULL,
  created_at TIMESTAMP  DEFAULT systimestamp,
  updated_at TIMESTAMP DEFAULT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  authority VARCHAR(191) DEFAULT '',
  clients_id NUMBER NOT NULL,
  users_id NUMBER NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_disponents_users1
    FOREIGN KEY (users_id)
    REFERENCES users (id),
   CONSTRAINT fk_disponents_clients1
    FOREIGN KEY (clients_id)
    REFERENCES clients (id)
    );

ALTER TABLE disponents -- Kontrola rodneho cisla
ADD CONSTRAINT check_rodne_cislo_disponents CHECK (REGEXP_LIKE(personal_identification_number, '^[0-9]{6}/[0-9]{4}$')
AND substr(personal_identification_number,1,2)<=31 AND substr(personal_identification_number,3,2)<=12);




-- -----------------------------------------------------
-- Table bank_accounts
-- -----------------------------------------------------
CREATE TABLE bank_accounts (
  id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
  client_id INT NOT NULL,
  bank_acc_number VARCHAR(191) NOT NULL,
  balance INT DEFAULT 0 NOT NULL,
  created_at TIMESTAMP DEFAULT systimestamp,
  updated_at TIMESTAMP DEFAULT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  clients_id INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_bank_accounts_clients1
    FOREIGN KEY (clients_id)
    REFERENCES clients (id));

  ALTER TABLE BANK_ACCOUNTS
	ADD CONSTRAINT bank_acc_number CHECK (REGEXP_LIKE(bank_acc_number, '^[0-9]{2,6}-?[0-9]{4,10}/[0-9]{4}$')); -- Kontrola formatu bankovniho uctu



-- -----------------------------------------------------
-- Table bank_accounts_disponents
-- -----------------------------------------------------

CREATE TABLE bank_accounts_disponents (
  id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
  bank_accounts_id INT NOT NULL,
  clients_id INT NOT NULL,
  users_id INT NOT NULL,
  disponents_id INT NOT NULL,
  created_at TIMESTAMP  DEFAULT systimestamp,
  updated_at TIMESTAMP DEFAULT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_bank_accounts_disponents_users1
    FOREIGN KEY (users_id)
    REFERENCES users (id),
  CONSTRAINT fk_bank_accounts_disponents_clients1
    FOREIGN KEY (clients_id)
    REFERENCES clients (id),
  CONSTRAINT fk_bank_accounts_disponents_bank_accounts1
    FOREIGN KEY (bank_accounts_id)
    REFERENCES bank_accounts (id),
  CONSTRAINT fk_bank_accounts_disponents_disponents1
    FOREIGN KEY (disponents_id)
    REFERENCES disponents (id)
);


-- -----------------------------------------------------
-- Table payments
-- -----------------------------------------------------
CREATE TABLE payments (
  id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
  amount FLOAT DEFAULT 0 NOT NULL ,
  user_id INT NOT NULL,
  bank_account_id INT NOT NULL,
  amount_in_words VARCHAR(191) NOT NULL,
  type INT NOT NULL,
  date_of_payment TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT systimestamp,
  updated_at TIMESTAMP DEFAULT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  contra_bank_account_id INT DEFAULT NULL,
  variable_symbol VARCHAR(20)  DEFAULT NULL,
  specific_symbol VARCHAR(20)  DEFAULT NULL,
  constant_symbol VARCHAR(20) DEFAULT NULL,
  cash_desk_amount INT DEFAULT NULL,
  first_name VARCHAR(191) NOT NULL,
  last_name VARCHAR(191) NOT NULL,
  street VARCHAR(191) DEFAULT NULL,
  street_number VARCHAR(191)  DEFAULT NULL,
  zip VARCHAR(191)  DEFAULT NULL,
  city VARCHAR(191)  DEFAULT NULL,
  personal_identification_number VARCHAR(191) DEFAULT NULL,
  identity_card_validity DATE DEFAULT NULL,
  identity_card_number VARCHAR(191) DEFAULT NULL,
  authority VARCHAR(191)  DEFAULT NULL,
  users_id INT NOT NULL,
  bank_accounts_id INT NOT NULL,
  bank_accounts_id1 INT NOT NULL,
  clients_id INT NOT NULL,
  disponent_id INT DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_payments_users1
    FOREIGN KEY (users_id)
    REFERENCES users (id),
  CONSTRAINT fk_payments_bank_accounts1
    FOREIGN KEY (bank_accounts_id)
    REFERENCES bank_accounts (id),
  CONSTRAINT fk_payments_bank_accounts2
    FOREIGN KEY (bank_accounts_id1)
    REFERENCES bank_accounts (id),
  CONSTRAINT fk_payments_clients1
    FOREIGN KEY (clients_id)
    REFERENCES clients (id));



   -- TRIGGERY
CREATE OR REPLACE TRIGGER trg_check_identity_card_validity
BEFORE INSERT OR UPDATE ON clients
FOR EACH ROW
BEGIN
  IF :NEW.identity_card_validity < SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20001, 'Identity card validity has expired.');
  END IF;
END;


CREATE OR REPLACE TRIGGER trg_payments_identity_card_validity
BEFORE INSERT OR UPDATE ON payments
FOR EACH ROW
DECLARE
    v_validity DATE;
BEGIN
    SELECT identity_card_validity INTO v_validity
    FROM clients
    WHERE id = :NEW.clients_id;

    IF v_validity < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Identity card validity of client ' || :NEW.id || ' has expired.');
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_update_timestamp
BEFORE UPDATE ON clients
FOR EACH ROW
BEGIN
    :NEW.updated_at := systimestamp;
END;


CREATE OR REPLACE TRIGGER trg_update_timestamp_disponents
BEFORE UPDATE ON disponents
FOR EACH ROW
BEGIN
    :NEW.updated_at := systimestamp;
END;


/*
    TRIGGER TEST FOR trg_update_timestamp
    je dole u MATERIALIZED VIEW
*/

/* TRIGGER TEST FOR CARD VALIDITY
INSERT INTO clients (first_name, last_name, email, phone, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, users_id)
          VALUES ('Alice', 'Johnson', 'alice@example.com', '123456789', 'Main Street', '10', '12345', 'New York', '010101/1234', TO_DATE('2020-04-24', 'YYYY-MM-DD'), 'AC123456',1);

 */

   -- Inserting into users table
INSERT INTO users (first_name, last_name, username, password, role)
VALUES ('John', 'Doe', 'johndoe', 'password', 1);

INSERT INTO users (first_name, last_name, username, password, role)
VALUES ('Jane', 'Doe', 'janedoe', 'password', 2);

INSERT INTO users (first_name, last_name, username, password, role)
VALUES ('Bob', 'Smith', 'bobsmith', 'password', 1);

-- Insert into clients
INSERT INTO clients (first_name, last_name, email, phone, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, users_id)
          VALUES ('Alice', 'Johnson', 'alice@example.com', '123456789', 'Main Street', '10', '12345', 'New York', '010101/1234', TO_DATE('2025-04-24', 'YYYY-MM-DD'), 'AC123456',1);

INSERT INTO clients (first_name, last_name, email, phone, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, users_id)
VALUES ('Peter', 'Green', 'peter@example.com', '987654321', 'Broadway', '20', '54321', 'Los Angeles', '020202/5678', TO_DATE('2023-08-25', 'YYYY-MM-DD'), 'PG654321', 2);

INSERT INTO clients (first_name, last_name, email, phone, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, users_id)
VALUES ('Mary', 'Brown', 'mary@example.com', '111222333', 'Market Street', '5', '67890', 'San Francisco', '030303/9012', TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'MB901234', 1);

-- Insert disponentes
INSERT INTO disponents (first_name, last_name, email, phone, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, users_id, clients_id)
VALUES ('Tom', 'Williams', 'tom@example.com', '555444333', 'Pine Street', '15', '09876', 'Chicago', '040404/3456', TO_DATE('2022-12-31', 'YYYY-MM-DD'), 'TW345678', 2, 1);

INSERT INTO disponents (first_name, last_name, email, phone, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, users_id, clients_id)
VALUES ('Samantha', 'Davis', 'samantha@example.com', '111222333', 'Elm Street', '25', '56789', 'Dallas', '050505/7890', TO_DATE('2023-06-01', 'YYYY-MM-DD'), 'SD789012', 1, 2);

INSERT INTO disponents (first_name, last_name, email, phone, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, users_id, clients_id)
VALUES ('David', 'Lee', 'david@example.com', '888777666', 'Oak Street', '35', '43210', 'Houston', '060606/1234', TO_DATE('2024-09-15', 'YYYY-MM-DD'), 'DL123456', 2, 3);

-- Insert bank_accounts
INSERT INTO bank_accounts (client_id, bank_acc_number, balance, created_at, updated_at, deleted_at, clients_id)
VALUES (1, '123456-789012/3456', 5000, SYSTIMESTAMP, NULL, NULL, 1);

INSERT INTO bank_accounts (client_id, bank_acc_number, balance, created_at, updated_at, deleted_at, clients_id)
VALUES (2, '1234-5678/9101', 10000, SYSTIMESTAMP, NULL, NULL, 2);

INSERT INTO bank_accounts (client_id, bank_acc_number, balance, created_at, updated_at, deleted_at, clients_id)
VALUES (3, '444456-789022/3456', 150000, SYSTIMESTAMP, NULL, NULL, 3);

-- Insert bank_accounts_disponents

INSERT INTO bank_accounts_disponents (bank_accounts_id, clients_id, users_id, disponents_id, created_at, updated_at, deleted_at)
VALUES (1, 1, 1, 2, SYSTIMESTAMP, NULL, NULL);

INSERT INTO bank_accounts_disponents (bank_accounts_id, clients_id, users_id, disponents_id, created_at, updated_at, deleted_at)
VALUES (2, 2, 2, 1, SYSTIMESTAMP, NULL, NULL);

INSERT INTO bank_accounts_disponents (bank_accounts_id, clients_id, users_id, disponents_id, created_at, updated_at, deleted_at)
VALUES (3, 3, 3, 1, SYSTIMESTAMP, NULL, NULL);

-- Insert payments

INSERT INTO payments (amount, user_id, bank_account_id, amount_in_words, type, date_of_payment, created_at, updated_at, deleted_at, contra_bank_account_id, variable_symbol, specific_symbol, constant_symbol, cash_desk_amount, first_name, last_name, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, authority, users_id, bank_accounts_id, bank_accounts_id1, clients_id, disponent_id)
VALUES (500, 1, 1, 'Five hundred dollars', 1, SYSTIMESTAMP, SYSTIMESTAMP, NULL, NULL, NULL, '123456', '789', '012', NULL, 'John', 'Doe', 'Main Street', '123', '12345', 'New York', '123456/1234', SYSDATE, 'ABC123', 'City Authority', 1, 1, 1, 1, NULL);

INSERT INTO payments (amount, user_id, bank_account_id, amount_in_words, type, date_of_payment, created_at, updated_at, deleted_at, contra_bank_account_id, variable_symbol, specific_symbol, constant_symbol, cash_desk_amount, first_name, last_name, street, street_number, zip, city, personal_identification_number, identity_card_validity, identity_card_number, authority, users_id, bank_accounts_id, bank_accounts_id1, clients_id, disponent_id)
VALUES (1000, 2, 2, 'One thousand dollars', 1, SYSTIMESTAMP, SYSTIMESTAMP, NULL, NULL, NULL, '5678', '9101', NULL, NULL, 'Jane', 'Doe', 'Second Street', '456', '67890', 'Los Angeles', '123456/2345', SYSDATE, 'DEF456', 'City Authority', 2, 2, 2, 2, NULL);



-- Vypis disponentu k daným uctum
SELECT ba.bank_acc_number, bd.first_name, bd.last_name
FROM bank_accounts ba
JOIN bank_accounts_disponents bad ON ba.id = bad.bank_accounts_id
JOIN disponents bd ON bad.disponents_id = bd.id;


-- Vypis z uctu
SELECT p.id, c.first_name, c.last_name, ba.bank_acc_number, p.CONTRA_BANK_ACCOUNT_ID, p.amount, p."TYPE", p.VARIABLE_SYMBOL, p.SPECIFIC_SYMBOL, p.CONSTANT_SYMBOL, p.DISPONENT_ID, p.created_at
FROM payments p
JOIN clients c ON p.clients_id = c.id
JOIN bank_accounts ba ON p.bank_accounts_id = ba.id;

-- Pocet uskutecnenych plateb klientem
SELECT clients_id, COUNT(*) as num_payments
FROM payments
GROUP BY clients_id;

-- Dotaz pro zjištění celkového toku peněz přes účet
SELECT bank_accounts_id, SUM(amount) as total_amount
FROM payments
GROUP BY bank_accounts_id;

-- Dotaz s predikátem EXISTS, který zjistí, zda klienti mají nějakého disponenta
SELECT c.id, c.first_name, c.last_name
FROM clients c
WHERE EXISTS (
SELECT 1
FROM bank_accounts_disponents bad
WHERE bad.clients_id = c.id
);

-- Dotaz s predikátem IN s vnořeným selectem, který zobrazí bankovní účty, které patří klientovi, u kterého byla provedena platba
SELECT ba.bank_acc_number, ba.balance
FROM bank_accounts ba
WHERE ba.clients_id IN (
SELECT p.clients_id
FROM payments p
WHERE p.amount > 500
);


-- Dotaz s klauzulí GROUP BY a agregační funkcí AVG na tabulku payments pro zjištění průměrné hodnoty platby daného účtu
SELECT bank_accounts_id, AVG(amount) as avg_amount
FROM payments p
JOIN bank_accounts ba ON p.bank_accounts_id = ba.id
GROUP BY bank_accounts_id;





-- PRAVA
GRANT ALL ON users TO xjezek19;
GRANT ALL ON clients TO xjezek19;
GRANT ALL ON bank_accounts TO xjezek19;
GRANT ALL ON payments TO xjezek19;
GRANT ALL ON disponents TO xjezek19;
GRANT ALL ON bank_accounts_disponents TO xjezek19;




-- MATERIALIZED VIEW
/*
Tento pohled bude obsahovat sloupce bank_accounts.id, bank_accounts.bank_acc_number, bank_accounts.balance, clients.first_name, clients.last_name a clients.email.
*/

DROP MATERIALIZED VIEW BANK_ACC_AND_CLIENTS_MATERIALIZED_VIEW;

CREATE MATERIALIZED VIEW bank_acc_and_clients_materialized_view
BUILD IMMEDIATE
AS SELECT ba.id, ba.bank_acc_number, ba.balance, c.first_name, c.last_name, c.email, c.created_at, c.updated_at
FROM bank_accounts ba
JOIN clients c ON ba.clients_id = c.id;

GRANT SELECT ON  bank_acc_and_clients_materialized_view TO XJEZEK19; -- Permise

SELECT * FROM bank_acc_and_clients_materialized_view; -- VYPIS MATERIALIZED VIEW

UPDATE clients c SET c.first_name = 'JAN' where c.id = 1; -- ZAROVEN I TEST TRIGERU NA AKTUALIZACI updated_at kolonky

SELECT * FROM clients; -- PRO POROVNANI A ZAROVEN TEST TRIGGERU NA updated_at
SELECT * FROM bank_acc_and_clients_materialized_view; -- HODNOTY V MATERIALIZED SE PO PREDESLEM UPDATU NEZMENILY


-- EXPLAIN PLAN
/*
    Zavedli jsme index v tabulce bank_accounts(clients_id), který nám urychlí spojení těchto dvou tabulek
    aby dotaz nemusel provést úplny přístup do tabulky ale jen na daný index. Možná bychom mohli použít i INNER JOIN
*/

EXPLAIN PLAN FOR
SELECT c.first_name, c.last_name, COUNT(ba.bank_acc_number) AS pocet_uctu
FROM clients c
JOIN bank_accounts ba ON c.id = ba.clients_id
GROUP BY c.first_name, c.last_name;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_bank_accounts_clients_id ON bank_accounts(clients_id);

EXPLAIN PLAN FOR
SELECT c.first_name, c.last_name, COUNT(ba.bank_acc_number) AS pocet_uctu
FROM clients c
JOIN bank_accounts ba ON c.id = ba.clients_id
GROUP BY c.first_name, c.last_name;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


DROP INDEX idx_bank_accounts_clients_id;


-- PROCEDURES

CREATE OR REPLACE PROCEDURE make_transfer(
    from_account bank_accounts.bank_acc_number%TYPE,
    to_account bank_accounts.bank_acc_number%TYPE,
    amount NUMBER
) IS

    CURSOR from_account_cur IS
        SELECT balance, clients_id
        FROM bank_accounts
        WHERE bank_acc_number = from_account
        FOR UPDATE;
    CURSOR to_account_cur IS
        SELECT balance, clients_id
        FROM bank_accounts
        WHERE bank_acc_number = to_account
        FOR UPDATE;
    from_balance bank_accounts.balance%TYPE;
    to_balance bank_accounts.balance%TYPE;
    from_client_id bank_accounts.clients_id%TYPE;
    to_client_id bank_accounts.clients_id%TYPE;
    insufficient_funds EXCEPTION;
    from_account_not_found EXCEPTION;
    to_account_not_found EXCEPTION;

BEGIN
    -- Lock the rows in the "bank_accounts" table corresponding to the "from_account" and "to_account" bank account numbers
    OPEN from_account_cur;
    FETCH from_account_cur INTO from_balance, from_client_id;
    IF from_account_cur%NOTFOUND THEN
        CLOSE from_account_cur;
        RAISE from_account_not_found;
    END IF;
    OPEN to_account_cur;
    FETCH to_account_cur INTO to_balance, to_client_id;
    IF to_account_cur%NOTFOUND THEN
        CLOSE to_account_cur;
        RAISE to_account_not_found;
    END IF;

    -- Check if the "from_account" has enough funds to make the transfer
    IF from_balance < amount THEN
        CLOSE from_account_cur;
        CLOSE to_account_cur;
        RAISE insufficient_funds;
    END IF;

    -- Update the account balances
    UPDATE bank_accounts SET balance = from_balance - amount WHERE bank_acc_number = from_account;
    UPDATE bank_accounts SET balance = to_balance + amount WHERE bank_acc_number = to_account;

    -- Commit the changes to the database
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Funds were successfully transfered');
    -- Close the cursors
    CLOSE from_account_cur;
    CLOSE to_account_cur;

EXCEPTION
    WHEN from_account_not_found THEN
        CLOSE to_account_cur;
        RAISE_APPLICATION_ERROR(-20001, 'From account not found.');
    WHEN to_account_not_found THEN
        CLOSE from_account_cur;
        RAISE_APPLICATION_ERROR(-20002, 'To account not found.');
    WHEN insufficient_funds THEN
        CLOSE from_account_cur;
        CLOSE to_account_cur;
        RAISE_APPLICATION_ERROR(-20003, 'Insufficient funds.');
    WHEN OTHERS THEN
        CLOSE from_account_cur;
        CLOSE to_account_cur;
        RAISE;
END;

GRANT EXECUTE ON make_transfer TO XJEZEK19; -- PRAVA na proceduru

-- Predvedeni
BEGIN
  make_transfer('123456-789012/3456', '1234-5678/9101', 1000);
END;



CREATE OR REPLACE PROCEDURE create_bank_account (
    p_client_id IN NUMBER,
    p_balance IN NUMBER
)
IS
    v_bank_acc_number VARCHAR2(191);
    v_count NUMBER;
BEGIN
    -- Generate a new bank account number in the Czech format
    v_bank_acc_number := to_char(trunc(dbms_random.value(100000, 999999)), 'FM000000') || '-' || to_char(trunc(dbms_random.value(1000, 9999)), 'FM0000') || '/' || to_char(trunc(dbms_random.value(1000, 9999)), 'FM0000');

    -- Check if the bank account number already exists
    SELECT COUNT(*) INTO v_count FROM bank_accounts WHERE bank_acc_number = v_bank_acc_number;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Bank account number already exists');
    END IF;

    -- Insert the new bank account into the table
    INSERT INTO bank_accounts (client_id, bank_acc_number, balance, clients_id)
    VALUES (p_client_id, v_bank_acc_number, p_balance, p_client_id);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Bank account created with number: ' || v_bank_acc_number);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;

GRANT EXECUTE ON create_bank_account TO XJEZEK19; -- PRAVA NA PROCEDURU


begin
    create_bank_account(3, 1000);
end;


-- Complex SQL query including WITH CASE

/*
Tento dotaz získává jméno a příjmení klienta, číslo bankovního účtu, zůstatek na účtu a kategorii zůstatku na účtu. Kategorie se určuje pomocí operátoru CASE podle výše zůstatku na účtu - výše 50000 Kč určuje vysoký zůstatek,
výše 10000 Kč až 49999 Kč určuje střední zůstatek,
a nižší částky určují nízký zůstatek. Kategorie
se vypisuje v novém sloupci s názvem balance_category.
*/

WITH total_balance AS (
  SELECT SUM(balance) AS sum_balance
  FROM bank_accounts
)
SELECT c.first_name || ' ' || c.last_name AS full_name,
       b.bank_acc_number,
       b.balance,
       CASE
         WHEN b.balance >= 50000 THEN 'high balance'
         WHEN b.balance >= 10000 THEN 'medium balance'
         ELSE 'low balance'
       END AS balance_category
FROM clients c
JOIN bank_accounts b ON c.id = b.clients_id
CROSS JOIN total_balance tb;


