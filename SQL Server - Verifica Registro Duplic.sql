-- VERIFICA SE H� REGISTROS DUPLICADOS --
SELECT campo, COUNT(campo) FROM scl.FISICA GROUP BY NOME HAVING COUNT(campo) > 1;