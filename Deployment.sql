-- Deployment
    CREATE TABLE IF NOT EXISTS user_tm (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        username        VARCHAR(20),
        role_id         INT,
        is_active       TINYINT,
        created_dt      DATETIME,
        last_login_dt   DATETIME,
        password        VARCHAR(60)
    );

    CREATE TABLE IF NOT EXISTS role_tm (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        role_name		VARCHAR(20)
    );

    CREATE TABLE IF NOT EXISTS stocksize_tr (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        size_name       VARCHAR(255) NOT NULL,
        size_value      VARCHAR(255) NOT NULL,
        is_active       TINYINT NOT NULL DEFAULT 1
    );

    CREATE TABLE IF NOT EXISTS stockcolor_tr (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        color_name      VARCHAR(255) NOT NULL,
        color_hex       VARCHAR(7) NOT NULL,
        is_active       TINYINT NOT NULL DEFAULT 1
    );

    CREATE TABLE IF NOT EXISTS stocktype_tr (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        type_name       VARCHAR(255) NOT NULL,
        type_value      VARCHAR(255) NOT NULL,
        is_active       TINYINT NOT NULL DEFAULT 1
    );

    CREATE TABLE IF NOT EXISTS stock_tm (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        stock_type_id   INT NOT NULL,
        stock_size_id   INT NOT NULL,
        stock_color_id  INT NOT NULL,
        quantity        INT NOT NULL DEFAULT 0, 
        is_active       TINYINT NOT NULL DEFAULT 1
    );

    -- new
    CREATE TABLE IF NOT EXISTS productmapping_tr (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        ecom_code       VARCHAR(3) NOT NULL,
        field1          TEXT,
        field2          TEXT,
        field3          TEXT,
        field4          TEXT,
        field5          TEXT,
        stock_id        INT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS picklist_tm (
        id                      INT AUTO_INCREMENT PRIMARY KEY,
        draft_create_dt         DATETIME NOT NULL,
        draft_cancel_dt         DATETIME,
        creation_dt             DATETIME,
        pick_start_dt           DATETIME,
        completion_dt           DATETIME,
        picklist_status         VARCHAR(32) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS picklistfile_tr (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        ecom_code       VARCHAR(3) NOT NULL,
        file_name       VARCHAR(255) NOT NULL,
        file_data       LONGBLOB NOT NULL,
        upload_dt       DATETIME NOT NULL,
        picklist_id     INT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS picklistitem_tr (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        ecom_code       VARCHAR(3) NOT NULL,
        ecom_order_id   VARCHAR(255) NOT NULL,
        product_name    TEXT,
        field1          TEXT,
        field2          TEXT,
        field3          TEXT,
        field4          TEXT,
        field5          TEXT,
        is_excluded     TINYINT NOT NULL DEFAULT 0,
        picklistfile_id INT NOT NULL,
        picklist_id     INT NOT NULL,
        stock_id        INT
    );

    CREATE TABLE IF NOT EXISTS auditlog_th (
        id              INT AUTO_INCREMENT PRIMARY KEY,
        log_menu        VARCHAR(50),
        log_action      VARCHAR(255),
        entity_type     VARCHAR(50),
        entity_id       INT,
        msg             TEXT NOT NULL,
        ts              DATETIME NOT NULL,
        user_id         INT NOT NULL
    );

-- View
    CREATE OR REPLACE VIEW stock_view AS
    SELECT
        stock_tm.id AS stock_id,
        stock_tm.stock_type_id,
        stocktype_tr.type_name,
        stock_tm.stock_size_id,
        stocksize_tr.size_name,
        stock_tm.stock_color_id,
        stockcolor_tr.color_name,
        stock_tm.quantity AS quantity,
        stock_tm.is_active AS is_active
    FROM
        stock_tm
        INNER JOIN stocktype_tr ON stock_tm.stock_type_id = stocktype_tr.id
        INNER JOIN stocksize_tr ON stock_tm.stock_size_id = stocksize_tr.id
        INNER JOIN stockcolor_tr ON stock_tm.stock_color_id = stockcolor_tr.id;


-- Initial Value
    INSERT INTO user_tm(created_dt, username, is_active)
    SELECT now(), 'System', 1
    FROM dual
    WHERE NOT EXISTS (SELECT * FROM user_tm);

    INSERT INTO role_tm(role_name)
    SELECT "owner"  UNION ALL
    SELECT "wareh"  UNION ALL
    SELECT "ecomm" 	UNION ALL
    SELECT "packe"
    FROM dual
    WHERE NOT EXISTS (SELECT * FROM role_tm);

    INSERT INTO stockcolor_tr (color_name, color_hex)
    SELECT color_name, color_hex
    FROM (
        SELECT 'MAROON' AS color_name, '#800000' AS color_hex UNION ALL
        SELECT 'LIGHT GREY', '#D3D3D3' UNION ALL
        SELECT 'DARK GREY', '#A9A9A9' UNION ALL
        SELECT 'PUTIH', '#FFFFFF' UNION ALL
        SELECT 'HITAM', '#000000' UNION ALL
        SELECT 'MELON', '#FEBAAD' UNION ALL
        SELECT 'KUNING', '#FFFF00' UNION ALL
        SELECT 'BABY PINK', '#F4C2C2' UNION ALL
        SELECT 'UNGU MUDA', '#D8BFD8' UNION ALL
        SELECT 'LIGHT BLUE', '#ADD8E6' UNION ALL
        SELECT 'NAVY', '#000080' UNION ALL
        SELECT 'DUSTY', '#B6A19E' UNION ALL
        SELECT 'ARMY', '#4B5320' UNION ALL
        SELECT 'KHAKI', '#F0E68C' UNION ALL
        SELECT 'SALEM', '#FA8072' UNION ALL
        SELECT 'BURGUNDY', '#800020' UNION ALL
        SELECT 'BEIGE', '#F5F5DC' UNION ALL
        SELECT 'SAGE', '#B2AC88' UNION ALL
        SELECT 'KREM', '#FFFDD0' UNION ALL
        SELECT 'DARK BROWN', '#654321' UNION ALL
        SELECT 'HIJAU BOTOL', '#006400' UNION ALL
        SELECT 'SALMON', '#FA8072' UNION ALL
        SELECT 'NEON', '#39FF14' UNION ALL
        SELECT 'ORANGE', '#FFA500' UNION ALL
        SELECT 'DENIM', '#1560BD' UNION ALL
        SELECT 'ELDERBERRY', '#5B4B49' UNION ALL
        SELECT 'ALMOND', '#EFDECD' UNION ALL
        SELECT 'ROYAL BLUE', '#4169E1'
    ) AS tmp
    WHERE NOT EXISTS (SELECT 1 FROM stockcolor_tr);


    

    INSERT INTO stocksize_tr (size_name, size_value)
    SELECT size_name, size_value
    FROM (
        SELECT 'S' AS size_name, 'S' AS size_value UNION ALL
        SELECT 'M', 'M' UNION ALL
        SELECT 'L', 'L' UNION ALL
        SELECT 'XL', 'XL' UNION ALL
        SELECT 'XXL', 'XXL' UNION ALL
        SELECT 'XXXL', 'XXXL' UNION ALL
        SELECT 'M - L', 'M_TO_L' UNION ALL
        SELECT 'M - XL', 'M_TO_XL' UNION ALL
        SELECT 'L - XL', 'L_TO_XL' UNION ALL
        SELECT 'XL - XXL', 'XL_TO_XXL' UNION ALL
        SELECT 'S - M', 'S_TO_M' UNION ALL
        SELECT 'ALL SIZE', 'ALL_SIZE' UNION ALL
        SELECT 'BIG SIZE', 'BIG_SIZE' UNION ALL
        SELECT 'PANJANG', 'PANJANG' UNION ALL
        SELECT 'PENDEK', 'PENDEK' UNION ALL
        SELECT 'BIASA', 'BIASA' UNION ALL
        SELECT 'HOLO', 'HOLO' UNION ALL
        SELECT 'GLITTER', 'GLITTER' UNION ALL
        SELECT 'NO SIZE', 'NOSIZE'
    ) AS tmp
    WHERE NOT EXISTS (SELECT 1 FROM stocksize_tr);

    INSERT INTO stocktype_tr (type_name, type_value)
    SELECT type_name, type_value
    FROM (
        SELECT 'HDO' AS type_name, 'HDO' AS type_value UNION ALL
        SELECT 'HMC', 'HMC' UNION ALL
        SELECT 'SWO', 'SWO' UNION ALL
        SELECT 'LOTBOM', 'LOTBOM' UNION ALL
        SELECT 'WANGKI POLOS', 'WANGKI_POLOS' UNION ALL
        SELECT 'WANGKI VARIASI', 'WANGKI_VARIASI' UNION ALL
        SELECT 'POLO SHIRT', 'POLO_SHIRT' UNION ALL
        SELECT 'OVERSIZED', 'OVERSIZED' UNION ALL
        SELECT 'EMBOSS', 'EMBOSS' UNION ALL

        SELECT 'CROP JUMPER', 'CROP_JUMPER' UNION ALL
        SELECT 'CROP SWEATER', 'CROP_SWEATER' UNION ALL
        SELECT 'VARSITY', 'VARSITY' UNION ALL
        SELECT 'CARDIGAN', 'CARDIGAN' UNION ALL
        SELECT 'KAOS', 'KAOS' UNION ALL
        SELECT 'SWEATPANTS PANJANG', 'SWEATPANTS_PANJANG' UNION ALL
        SELECT 'SWEATPANTS PENDEK', 'SWEATPANTS_PENDEK' UNION ALL
        SELECT 'CROP KAOS', 'CROP_KAOS' UNION ALL
        SELECT 'BOMBER PARASUT', 'BOMBER_PARASUT' UNION ALL
        SELECT 'HOODIE ZIP ANAK', 'HOODIE_ZIP_ANAK' UNION ALL
        SELECT 'HOODIE JUMPER ANAK', 'HOODIE_JUMPER_ANAK' UNION ALL
        SELECT 'OBLONG ANAK', 'OBLONG_ANAK' UNION ALL
        SELECT 'COACH JAKET', 'COACH_JAKET' UNION ALL
        SELECT 'BASIC SHIRT', 'BASIC_SHIRT' UNION ALL
        SELECT 'GAMIS MAXMARA', 'GAMIS_MAXMARA' UNION ALL
        SELECT 'GAMIS JERSEY', 'GAMIS_JERSEY' UNION ALL
        SELECT 'SWEATER DIAMOND NITO', 'SWEATER_DIAMOND_NITO' UNION ALL
        SELECT 'RAGLAN PANJANG', 'RAGLAN_PANJANG' UNION ALL
        SELECT 'RAGLAN PENDEK', 'RAGLAN_PENDEK' UNION ALL
        SELECT 'CARD HOLDER', 'CARD_HOLDER' UNION ALL
        SELECT 'TOPI', 'TOPI' UNION ALL
        SELECT 'TUMBLR', 'TUMBLR'
    ) AS tmp
    WHERE NOT EXISTS (SELECT 1 FROM stocktype_tr);

    INSERT INTO stock_tm (stock_type_id, stock_size_id, stock_color_id)
    SELECT stock_type_id, stock_size_id, stock_color_id
    FROM (
        SELECT 1 AS stock_type_id, 7 AS stock_size_id, 1 AS stock_color_id UNION ALL
        SELECT 1, 4, 1 UNION ALL
        SELECT 1, 4, 2 UNION ALL
        SELECT 1, 5, 1 UNION ALL
        SELECT 1, 5, 2 UNION ALL
        SELECT 1, 5, 3
    ) AS tmp
    WHERE NOT EXISTS (SELECT 1 FROM stock_tm);

-- View
    CREATE OR REPLACE VIEW stock_view AS
    SELECT
        stock_tm.id,
        stocktype_tr.type_name,
        stocksize_tr.size_name,
        stockcolor_tr.color_name,
        stock_tm.quantity AS quantity,
        stock_tm.stock_type_id,
        stock_tm.stock_size_id,
        stock_tm.stock_color_id
    FROM
        stock_tm
        INNER JOIN stocktype_tr ON stock_tm.stock_type_id = stocktype_tr.id
        INNER JOIN stocksize_tr ON stock_tm.stock_size_id = stocksize_tr.id
        INNER JOIN stockcolor_tr ON stock_tm.stock_color_id = stockcolor_tr.id;