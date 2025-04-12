-- Inbound Schedule Table
CREATE TABLE IF NOT EXISTS inboundschedule_tm (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    schedule_date   VARCHAR(8) NOT NULL,
    created_dt      DATETIME NOT NULL,
    creator_id      INT NOT NULL,
    notes           VARCHAR(255),     
    is_active       TINYINT NOT NULL DEFAULT 1
);

-- Inbound Table
CREATE TABLE IF NOT EXISTS inbound_tm (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status          VARCHAR(20) NOT NULL, -- 'PENDING', 'COMPLETED'
    supplier_name   VARCHAR(255), 
    notes           VARCHAR(255),
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    user_id         INT NOT NULL
);

CREATE TABLE IF NOT EXISTS inbounditems_tr (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inbound_id INT NOT NULL,
    stock_id INT NOT NULL, 
    add_quantity INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Master Parameter Table
CREATE TABLE IF NOT EXISTS master_parameter_tm (
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    parameter_name          VARCHAR(255) NOT NULL,
    parameter_value_varchar VARCHAR(255),
    parameter_value_int     INT,
    created_dt              DATETIME NOT NULL,
    is_active               TINYINT NOT NULL DEFAULT 1
);

-- Insert initial parameter
INSERT INTO master_parameter_tm (parameter_name, parameter_value_int, created_dt, is_active)
VALUES ('inbound_active', 1, NOW(), 1);