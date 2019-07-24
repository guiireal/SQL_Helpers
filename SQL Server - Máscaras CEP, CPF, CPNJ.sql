-- MÁSCARA CEP 1 --
SELECT LEFT(@CEP, 5) + '-' + RIGHT(@CEP, LEN(@CEP) - 5)

-- MÁSCARA CEP 2 (SEM O ZERO) --
SELECT CONCAT('0', (LEFT(@cep, 4) + '-' + RIGHT(@cep, LEN(@cep) - 4))),

-- MÁSCARA CPF 1 --
SELECT SUBSTRING(CPF,1,3) + '.' + SUBSTRING(CPF,4,3) + '.' + 
	   SUBSTRING(CPF,7,3) + '-' + SUBSTRING(CPF,10,2)

-- MÁSCARA CPF 2 --
(LEFT(LEFT(LEFT(@cpf, 3) + '.' + 
RIGHT(@cpf, LEN(@cpf) - 3), 7) + '.' + 
RIGHT(LEFT(@cpf, 3) + '.' + 
RIGHT(@cpf, LEN(@cpf) - 3), LEN(LEFT(@cpf, 3) + '.' + 
RIGHT(@cpf, LEN(@cpf) - 3)) - 7), 11) + '-' + 
RIGHT(LEFT(LEFT(@cpf, 3) + '.' + RIGHT(@cpf, LEN(@cpf) - 3), 7) + '.' +
RIGHT(LEFT(@cpf, 3) + '.' + 
RIGHT(@cpf, LEN(@cpf) - 3), LEN(LEFT(@cpf, 3) + '.' + 
RIGHT(@cpf, LEN(@cpf) - 3)) - 7), LEN(LEFT(LEFT(@cpf, 3) + '.' + 
RIGHT(@cpf, LEN(@cpf) - 3), 7) + '.' + 
RIGHT(LEFT(@cpf, 3) + '.' + 
RIGHT(@cpf, LEN(@cpf) - 3), LEN(LEFT(@cpf, 3) + '.' + 
RIGHT(@cpf, LEN(@cpf) - 3)) - 7)) - 11))

-- MÁSCARA CNPJ --
SELECT SUBSTRING(@cnpj, 1, 2) + '.' + SUBSTRING(@cnpj, 3, 3) + '.' + 
       SUBSTRING(@cnpj, 6, 3) + '/' + SUBSTRING(@cnpj, 9, 4) + '-' + 
	   SUBSTRING(@cnpj, 13, 2)