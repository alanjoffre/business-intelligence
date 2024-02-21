if object_id('UP_CARGA_DIMENSAO_TEMPO', 'P') is not null
  drop procedure UP_CARGA_DIMENSAO_TEMPO;
go

create PROCEDURE UP_CARGA_DIMENSAO_TEMPO
(@ANO_INICIAL varchar(255),  @ANO_FINAL varchar(255))    AS 
--initialize variables here


--/**************************************************************************************
-- **
-- **  
-- ** Autor      : ALFREDO CARNEIRO - aluno do treinamento
-- ** Parâmetros : ano_inicio smallint    ano inicio da carga
-- **              ano_fim    smallint    ano final da carga
-- **
-- **     
-- **************************************************************************************/

 DECLARE 
		--@ANO_INICIAL int = 1990,
		--@ANO_FINAL int = 2030,

		@dtc_dia DATETIME,
        @dtr_data DATETIME,
        @dtc_dia2 varchar(255),
        @dia int,
        @quinzena int,
        @mes int,
        @ano int,
        @dtr_ano_mes int,
        @dtr_ano_mes2 varchar(255),
        @dtc_mes_ano varchar(255),
        @dtc_mes_ano_completo varchar(255),
        @dtc_mes_ano_numerico varchar(255),
        @nom_quinzena varchar(255),
        @nom_mes varchar(255),
        @nom_dia varchar(255),
        @num_bimestre int,
        @num_trimestre int,
        @num_quadrimestre int,
        @nom_trimestre varchar(255) ,
        @nom_bimestre varchar(255) ,
        @nom_quadrimestre varchar(255) ,
        @num_semestre int,
        @nom_semestre varchar(255),
        @sts_fim_de_semana varchar(255),
        @num_nivel int,
        @mes_ant int = 0,
        @num_trimestre_ant int = 0 ,
        @num_bimestre_ant int = 0 ,
        @num_quadrimestre_ant int = 0 ,
        @num_semestre_ant int = 0 ,
        @ano_ant int = 0,
        @num_dia_semana int,
        @ano_inicio int,
        @cont  int=1
BEGIN

	set	@ano_inicio = @ANO_INICIAL;

	select @dtc_dia = '01/01/' + (CONVERT(VARCHAR(255), @ano_inicio)) ;

	delete DIM_TEMPO;

--print  @dtc_dia

WHILE @ano_inicio <= @ANO_FINAL begin


    set @dia = DAY (@dtc_dia);
    set @mes = MONTH (@dtc_dia);
    set @ano = YEAR (@dtc_dia);

    set @num_trimestre = datepart(quarter, @dtc_dia);
--print  @num_trimestre        
    set @nom_trimestre = convert(varchar(255),@num_trimestre) + 'º Tri/' + convert(varchar(255),@ano);
--print  @nom_trimestre
    set @dtr_ano_mes = (@ano*100) + @mes;
--print @dtr_ano_mes          
     
    set @dtc_dia2 = convert(varchar(255), (@dtr_ano_mes*100) + @dia);
--print @dtc_dia2


	IF (@mes <= 2) begin
        set @num_bimestre = 1;
    END
    ELSE IF (@mes >2 and @mes< 5) begin
        set @num_bimestre = 2;
        END
        ELSE IF (@mes >=5 and @mes< 7) begin
        set @num_bimestre = 3;
    END
    ELSE IF (@mes >=7 and @mes< 9) begin
        set @num_bimestre = 4;
   END
   ELSE IF (@mes >=9 and @mes<11) begin
        set @num_bimestre = 5;
    END
    ELSE BEGIN  
        set @num_bimestre = 6;
    END 
--print @num_bimestre

	set @nom_bimestre = convert(varchar(255),@num_bimestre) + 'º Bim/' +  convert(varchar(255),@ano);
--print @nom_bimestre

	IF (@num_bimestre <= 2) begin
        set @num_quadrimestre = 1;
    END
    ELSE IF (@num_bimestre >2  and @num_bimestre <5) begin
        set @num_quadrimestre = 2;
        END
        ELSE BEGIN 
         set @num_quadrimestre = 3;
    end 
--print @num_quadrimestre
	set @nom_quadrimestre = convert(varchar(255),@num_quadrimestre) + 'º Quad/' + convert(varchar(255),@ano);
--print @nom_quadrimestre

	IF (@num_trimestre < 3) begin
        set @num_semestre = 1;
    END
    ELSE BEGIN
        set @num_semestre = 2;
    end 

    set @nom_semestre = convert(varchar(255),@num_semestre) + 'º Sem/' +  convert(varchar(255),@ano);
--print @nom_semestre
    set @num_dia_semana =  DATEPART(dw, @dtc_dia);
--print @num_dia_semana
   IF @num_dia_semana = 1 or @num_dia_semana = 7 BEGIN
        set @sts_fim_de_semana = 1;
    END
    ELSE BEGIN
        set @sts_fim_de_semana = 0;
    END
--print @sts_fim_de_semana

	SELECT @nom_mes = CASE @mes
		WHEN 1 THEN 'Janeiro'
		WHEN 2 THEN 'Fevereiro'
		WHEN 3 THEN 'Março'
		WHEN 4 THEN 'Abril'
		WHEN 5 THEN 'Maio'
		WHEN 6 THEN 'Junho'
		WHEN 7 THEN 'Julho'
		WHEN 8 THEN 'Agosto'
		WHEN 9 THEN 'Setembro'
		WHEN 10 THEN 'Outubro'
		WHEN 11 THEN 'Novembro'
		WHEN 12 THEN 'Dezembro'
	END;
--print @nom_mes

	IF (@dia <16) BEGIN
        set @quinzena = 1;
    END
    ELSE BEGIN  
        set @quinzena = 2;
    end 
--print @quinzena

	set @nom_quinzena = convert(varchar(255),@quinzena) + 'º Quin/' + convert(varchar(255),SUBSTRING(@nom_mes,1,3));
--print @nom_quinzena

	SELECT   @nom_dia = CASE @num_dia_semana
		WHEN 1 THEN 'Domingo'
		WHEN 2 THEN 'Segunda'
		WHEN 3 THEN 'Terça'
		WHEN 4 THEN 'Quarta'
		WHEN 5 THEN 'Quinta'
		WHEN 6 THEN 'Sexta'
		WHEN 7 THEN 'Sábado'
	END;
--print @nom_dia

	IF (@mes <10) BEGIN
       set @dtc_mes_ano_numerico='0'+(convert(varchar(255), @mes))+'/'+(substring(convert(varchar(255), @dtr_ano_mes),1,4));
    END
    ELSE BEGIN  
       set @dtc_mes_ano_numerico=(convert(varchar(255), @mes))+'/'+(substring(convert(varchar(255), @dtr_ano_mes),1,4));
    end 
--print @dtc_mes_ano_numerico

	set @dtc_mes_ano=(substring(@nom_mes,1,3))+'/'+(substring(convert(varchar(255), @dtr_ano_mes),1,4));
    set @dtc_mes_ano_completo=(@nom_mes)+'/'+(substring(convert(varchar(255), @dtr_ano_mes),1,4));
--print @dtc_mes_ano    
--print @dtc_mes_ano_completo
    
	set @num_nivel  = 1;
    set @dtr_ano_mes2 = convert(varchar(255), @dtr_ano_mes);
    set @dtr_data= convert(DATETIME, @dtc_dia2);
--print @num_nivel
--print @dtr_ano_mes2
--print @dtr_data
    INSERT INTO DIM_TEMPO (DTC_DATA,NUM_ANO, NUM_DIA, NUM_MES, SK_TEMPO, DES_ANO_MES,DES_MES_ANO_NUMERICO,DES_MES_ANO_COMPLETO,DES_MES_ANO,DES_DATA_DIA,DES_DIA, DES_MES, DES_QUINZENA, DES_SEMESTRE, DES_TRIMESTRE, NUM_NIVEL, NUM_QUINZENA, NUM_SEMESTRE, NUM_TRIMESTRE, IND_FINAL_SEMANA, DES_BIMESTRE, DES_QUADRIMESTRE, NUM_BIMESTRE, NUM_QUADRIMESTRE)
    VALUES ( @dtr_data,@ano, @dia, @mes, @cont,@dtr_ano_mes2,@dtc_mes_ano_numerico,@dtc_mes_ano_completo,@dtc_mes_ano,@dtc_dia2,@nom_dia, @nom_mes, @nom_quinzena, @nom_semestre, @nom_trimestre, @num_nivel, @quinzena, @num_semestre, @num_trimestre, @sts_fim_de_semana, @nom_bimestre, @nom_quadrimestre, @num_bimestre, @num_quadrimestre);
    set @cont = @cont + 1;
        ;
           IF (@mes_ant != @mes) BEGIN
        set @mes_ant = @mes;
        set @num_nivel = 2;
    INSERT INTO DIM_TEMPO (DTC_DATA,NUM_ANO, NUM_DIA, NUM_MES, SK_TEMPO,DES_ANO_MES,DES_MES_ANO_NUMERICO,DES_MES_ANO_COMPLETO,DES_MES_ANO,DES_DATA_DIA,DES_DIA, DES_MES, DES_QUINZENA, DES_SEMESTRE, DES_TRIMESTRE, NUM_NIVEL, NUM_QUINZENA, NUM_SEMESTRE, NUM_TRIMESTRE, IND_FINAL_SEMANA, DES_BIMESTRE, DES_QUADRIMESTRE, NUM_BIMESTRE, NUM_QUADRIMESTRE)
        VALUES ( NULL,@ano, NULL, @mes, @cont,@dtr_ano_mes2,@dtc_mes_ano_numerico,@dtc_mes_ano_completo,@dtc_mes_ano, NULL, NULL,@nom_mes, NULL, @nom_semestre, @nom_trimestre, @num_nivel, NULL, @num_semestre, @num_trimestre, 0, @nom_bimestre, @nom_quadrimestre, @num_bimestre, @num_quadrimestre);
        set @cont = @cont + 1;
                ;
    END 
                
        /* Acrescenta um dia à data */
    set @dtc_dia = @dtc_dia + 1;
    --SELECT dtc_dia2 = substring(convert(char(10),dtc_dia),7,4) + substring(convert(char(10),dtc_dia),4,2) + substring(convert(char(10),dtc_dia),1,2)
    /* Atualiza a condição de saída do LOOP */
    set @ano_inicio = YEAR (@dtc_dia); 
END                       


--    Except
--        WHEN OTHERS THEN 
--            NULL;  -- informe aqui quaisquer códigos de exceção
END