-- Inbound Schedule Table
CREATE TABLE IF NOT EXISTS inboundschedule_tm (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    schedule_date   VARCHAR(8) NOT NULL,
    created_dt      DATETIME NOT NULL,
    creator_id      INT NOT NULL,
    is_active       TINYINT NOT NULL DEFAULT 1
);

-- Inbound Table
CREATE TABLE IF NOT EXISTS inbound_tm (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    product_name        VARCHAR(255) NOT NULL,
    quantity            INT NOT NULL,
    created_dt          DATETIME,
    is_active           TINYINT NOT NULL DEFAULT 1,
);