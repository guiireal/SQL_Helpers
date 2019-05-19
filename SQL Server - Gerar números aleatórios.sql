------------------------------------------------------------------
-- Gerar n�meros aleat�rios no SQL Server
------------------------------------------------------------------
 
----------------------------------------------
-- Newid
----------------------------------------------
-- Exemplo 1: Inteiro aleat�rio
select
    newid() as string_aleatorio,
    checksum(newid()) as inteiro_aleatorio
 
-- Exemplo 2: Inteiro aleat�rios (sempre positivo)
select abs(checksum(newid())) as int_aleatorio_positivo
 
-- Exemplo 3: Inteiro aleat�rios (entre -60 e 60 - resto da divis�o inteira por 61)
select checksum(newid()) %61 as int_aleatorio_range
 
-- Exemplo 4: Inteiro aleat�rios (entre 1 e 60 para mega-sena)
select (abs(checksum(newid())) % 60) + 1 as int_aleatorio_mega
 
-- Exemplo 5: N�mero inteiro com AT� X digitos (no exemplo, 5 digitos)
select left(checksum(newid()), 5) as int_aleatorio_5_digitos
 
-- Exemplo 6: BIGINT
select convert(bigint, convert(varbinary(8), newid())) as bigint_aleatorio
 
-- Exemplo 7: DECIMAL
select convert(decimal(38,10), left(convert(varchar, convert(bigint, convert(varbinary(8), newid()))) + '.' + convert(varchar, abs(checksum(newid()))), 38)) as decimal_aleatorio
 
-- Exemplo 8: FLOAT
select convert(float, left(convert(varchar, convert(bigint, convert(varbinary(8), newid()))) + '.' + convert(varchar, abs(checksum(newid()))), 38)) as decimal_aleatorio
 
 
----------------------------------------------
-- Gerando listas de n�meros aleat�rios
----------------------------------------------
-- Exemplo 1: Usando CTE recursiva (meu preferido!)
;with cte_seq as (
    select 1 as sequencia, checksum(newid()) as int_aleatorio_positivo
    union all
    select sequencia + 1, checksum(newid()) from cte_seq where sequencia < 1000
)
select * from cte_seq option (maxrecursion 0) -- option (maxrecursion 0) permite loops + de 100 itens
 
-- Exemplo 2: Usando loop ou cursor
declare @i smallint = 1
while @i <= 1000
    begin
        print checksum(newid())
        set @i+= 1
    end
 
-- Exemplo 3: Usando select em tabelas
select top 1000
    left(convert(int, crypt_gen_random(8)), 2) as meu_preferido_sql2012
from sysobjects a full join sysobjects b on 1 = 1
 
 
----------------------------------------------
-- Outras formas
----------------------------------------------
-- FC matem�tica rand e rand com seed
-- OBS: Note que ao executar os dois comandos juntos o valor n�o � aleat�rio
select rand()
select rand(123)
 
-- FC matem�tica rand (inteiro em um range)
declare @maior int;
declare @menor int
set @menor = 1 ---- menor n�mero
set @maior = 60 ---- maior n�mero
select round(((@maior - @menor -1) * rand() + @menor), 0)
 
-- FC matem�tica rand (decimal)
-- Entre 0 e 20 (decimal)
select 20 * rand()
-- Entre 10 e 30
select 10 + 20*rand()
 
-- FC criptografica
select convert(bigint, crypt_gen_random(8))
 
-- FC sysdatetime (ns = nanosegundos)
select (datepart(ns, sysdatetime()))