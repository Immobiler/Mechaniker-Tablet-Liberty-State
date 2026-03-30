-- coastnet_database.sql
CREATE TABLE IF NOT EXISTS `coastnet_citizens` (
    `id`            INT AUTO_INCREMENT PRIMARY KEY,
    `name`          VARCHAR(100) NOT NULL DEFAULT '',
    `birth`         VARCHAR(20)  DEFAULT '',
    `height`        VARCHAR(20)  DEFAULT '',
    `phone`         VARCHAR(20)  DEFAULT '',
    `sex`           VARCHAR(1)   DEFAULT 'M',
    `identifier`    VARCHAR(100) DEFAULT NULL COMMENT 'FiveM Spieler-Identifier (steam: oder license:)',
    `job`           VARCHAR(100) DEFAULT 'job_arbeitslos',
    `job_rank`      VARCHAR(100) DEFAULT 'rank_al_1',
    `second_job`    VARCHAR(100) DEFAULT NULL,
    `second_rank`   VARCHAR(100) DEFAULT NULL,
    `wanted`        TINYINT(1)   DEFAULT 0,
    `wanted_reason` TEXT,
    `wanted_by`     VARCHAR(100) DEFAULT NULL,
    `wanted_date`   TIMESTAMP    NULL,
    `created_at`    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='COAST.NET Buerger/Charakter Tabelle';


CREATE TABLE IF NOT EXISTS `coastnet_tokens` (
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `token`            VARCHAR(20)  UNIQUE NOT NULL  COMMENT 'Format: XXXX-XXXX-XXXX',
    `identifier`       VARCHAR(100) NOT NULL         COMMENT 'FiveM Identifier des Spielers',
    `player_name`      VARCHAR(100) DEFAULT ''       COMMENT 'FiveM Ingame-Name beim Erstellen',
    `citizen_id`       INT          DEFAULT NULL     COMMENT 'Verknuepfter Citizen',
    `used`             TINYINT(1)   DEFAULT 0        COMMENT '0 = offen, 1 = genutzt',
    `used_by_username` VARCHAR(100) DEFAULT NULL     COMMENT 'Account-Name der diesen Token genutzt hat',
    `created_at`       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `used_at`          TIMESTAMP    NULL,
    INDEX idx_identifier (`identifier`),
    INDEX idx_used (`used`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='COAST.NET Registrierungs-Tokens';


CREATE TABLE IF NOT EXISTS `coastnet_vehicles` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `plate`      VARCHAR(20)  UNIQUE NOT NULL,
    `model`      VARCHAR(50)  DEFAULT '',
    `owner`      VARCHAR(100) DEFAULT '',
    `color`      VARCHAR(50)  DEFAULT '',
    `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='COAST.NET Fahrzeuge';


INSERT IGNORE INTO `coastnet_citizens` (`name`, `birth`, `height`, `phone`, `sex`, `wanted`, `wanted_reason`) VALUES
('Max Mustermann', '01.01.1990', '180 cm', '555-1234', 'M', 0, NULL),
('Anna Schmidt',   '15.05.1985', '165 cm', '555-5678', 'W', 0, NULL),
('Peter Meier',    '22.08.1992', '175 cm', '555-9012', 'M', 1, 'Verdacht auf Diebstahl');

INSERT IGNORE INTO `coastnet_vehicles` (`plate`, `model`, `owner`, `color`) VALUES
('ABC-123', 'Adder',    'Max Mustermann', 'Schwarz'),
('XYZ-789', 'T20',      'Anna Schmidt',   'Rot'),
('DEF-456', 'Zentorno', 'Peter Meier',    'Blau');
