## Apagando a função se já existe
DROP FUNCTION IF EXISTS MASK;

## Criando a função
DELIMITER //
CREATE FUNCTION MASK(val VARCHAR(100), mask VARCHAR(100)) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
 DECLARE maskared VARCHAR(100) DEFAULT "";
 DECLARE k INT DEFAULT 0;
 DECLARE i INT DEFAULT 0;
 WHILE i < CHAR_LENGTH(mask) DO
  SET i = i + 1;
  IF SUBSTRING(mask, i, 1) = '#' THEN
   IF k < CHAR_LENGTH(val) THEN
    SET k = k+1;
    SET maskared = CONCAT(maskared, SUBSTRING(val, k, 1));
   END IF;
  ELSE
   IF i < CHAR_LENGTH(mask) THEN
    SET maskared = CONCAT(maskared, SUBSTRING(mask, i, 1));
            END IF;
        END IF;
 END WHILE;
 RETURN maskared;
END;
//
DELIMITER ;