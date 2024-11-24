-- Deployment
    -- user_tm
        CREATE TABLE IF NOT EXISTS user_tm (
            id              INT AUTO_INCREMENT PRIMARY KEY,
            username        VARCHAR(20),
            role_id         INT,
            is_active       TINYINT,
            created_dt      DATETIME,
            last_login_dt   DATETIME,
            password        VARCHAR(60)
        )  ENGINE=INNODB;
    
    -- role_tm
		    CREATE TABLE IF NOT EXISTS role_tm (
            id              INT AUTO_INCREMENT PRIMARY KEY,
            role_name		    VARCHAR(20)
        )  ENGINE=INNODB;

-- Initial Value
    -- user_tm
        INSERT INTO user_tm(created_dt, username, is_active)
        SELECT now(), 'System', 1
        FROM dual
        WHERE NOT EXISTS (SELECT * FROM user_tm);

    -- role_tm
        INSERT INTO role_tm(role_name)
        SELECT "owner"  UNION ALL
        SELECT "wareh"  UNION ALL
        SELECT "ecomm" 	UNION ALL
        SELECT "packe"
        FROM dual
        WHERE NOT EXISTS (SELECT * FROM role_tm);