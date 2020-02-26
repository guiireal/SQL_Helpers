CREATE Function UcsToUtf8(@src nvarchar(MAX)) returns varchar(MAX) as
begin
    declare @res varchar(MAX)='', @pi char(8)='%[^'+char(0)+'-'+char(127)+']%', @i int, @j int
    select @i=patindex(@pi,@src collate Latin1_General_BIN)
    while @i>0
    begin
        select @j=unicode(substring(@src,@i,1))
        if @j<0x800     select @res=@res+left(@src,@i-1)+char((@j&1984)/64+192)+char((@j&63)+128)
        else            select @res=@res+left(@src,@i-1)+char((@j&61440)/4096+224)+char((@j&4032)/64+128)+char((@j&63)+128)
        select @src=substring(@src,@i+1,datalength(@src)-1), @i=patindex(@pi,@src collate Latin1_General_BIN)
    end
    select @res=@res+@src
    return @res
end

CREATE Function Utf8ToUcs(@src varchar(MAX)) returns nvarchar(MAX) as
begin
    declare @i int, @res nvarchar(MAX)=@src, @pi varchar(18)
    select @pi='%[à-ï][€-¿][€-¿]%',@i=patindex(@pi,@src collate Latin1_General_BIN)
    while @i>0 select @res=stuff(@res,@i,3,nchar(((ascii(substring(@src,@i,1))&31)*4096)+((ascii(substring(@src,@i+1,1))&63)*64)+(ascii(substring(@src,@i+2,1))&63))), @src=stuff(@src,@i,3,'.'), @i=patindex(@pi,@src collate Latin1_General_BIN)
    select @pi='%[Â-ß][€-¿]%',@i=patindex(@pi,@src collate Latin1_General_BIN)
    while @i>0 select @res=stuff(@res,@i,2,nchar(((ascii(substring(@src,@i,1))&31)*64)+(ascii(substring(@src,@i+1,1))&63))), @src=stuff(@src,@i,2,'.'),@i=patindex(@pi,@src collate Latin1_General_BIN)
    return @res
end