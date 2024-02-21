create or replace PROCEDURE "UP_CARGA_DIMENSAO_TEMPO"("ANO_INICIAL" IN NUMBER,  "ANO_FINAL" IN NUMBER)    IS 
--initialize variables here


--/**************************************************************************************
-- **
-- ** TREINAMENTO APRENDA VIRTUAL
-- ** Autor      : GRIMALDO OLIVEIRA
-- ** Parâmetros : ano_inicio smallint    ano inicio da carga
-- **              ano_fim    smallint    ano final da carga
-- **
-- **     
-- **************************************************************************************/

        dtc_dia DATE;
        dtr_data DATE;
        dtc_dia2 varchar(25);
        dia SMALLINT;
        quinzena SMALLINT;
        mes SMALLINT;
        ano smallint;
        dtr_ano_mes int;
        dtr_ano_mes2 varchar(8);
                dtc_mes_ano varchar(8);
                dtc_mes_ano_completo varchar(30);
                dtc_mes_ano_numerico varchar(7);
        nom_quinzena varchar (12);
        nom_mes varchar (15);
        nom_dia varchar (7);
        num_bimestre SMALLINT ;
        num_trimestre SMALLINT ;
        num_quadrimestre SMALLINT ;
        nom_trimestre varchar (12) ;
                nom_bimestre varchar (12) ;
        nom_quadrimestre varchar (12) ;
        num_semestre SMALLINT ;
        nom_semestre varchar (12);
        sts_fim_de_semana CHAR (1);
        num_nivel SMALLINT;
        mes_ant SMALLINT:=0;
        num_trimestre_ant SMALLINT:=0 ;
        num_bimestre_ant SMALLINT:=0 ;
        num_quadrimestre_ant SMALLINT:=0 ;
        num_semestre_ant SMALLINT:=0 ;
        ano_ant smallint:=0;
        num_dia_semana SMALLINT;
        ano_inicio Number;
        cont Number:=1;
-- main body
BEGIN
   
ano_inicio := ano_inicial;

select ( to_Date('01/01/' || ano_inicio,'dd/mm/yyyy') ) into dtc_dia  from dual;

--SELECT dtc_dia2 = substring(convert(char(10),dtc_dia),7,4) + substring(convert(char(10),dtc_dia),4,2) + substring(convert(char(10),dtc_dia),1,2)

delete DIM_TEMPO;

WHILE ano_inicio <= ano_final loop



    dia := EXTRACT (DAY FROM dtc_dia);
    mes := EXTRACT (MONTH FROM dtc_dia);
    ano := EXTRACT (YEAR FROM dtc_dia);

    num_trimestre := TO_CHAR(dtc_dia,'Q');
        
    nom_trimestre := num_trimestre || 'º Tri/' || ano;

    dtr_ano_mes := (ano*100) + mes;
         
     
    dtc_dia2 := to_char((dtr_ano_mes*100) + dia);


    /* Coloca o bimestre */
    IF (mes <= 2) then
        num_bimestre := 1;
    ELSIF (mes >2 and mes< 5) then
        num_bimestre := 2;
        ELSIF (mes >=5 and mes< 7) then
        num_bimestre := 3;
    ELSIF (mes >=7 and mes< 9) then
        num_bimestre := 4;
   ELSIF (mes >=9 and mes<11) then
        num_bimestre := 5;
    ELSE  
        num_bimestre := 6;
    END IF;


        nom_bimestre := num_bimestre || 'º Bim/' ||  ano;

    /* Coloca o quadrimestre */
    IF (num_bimestre <= 2) then
        num_quadrimestre := 1;
    ELSIF (num_bimestre >2  and num_bimestre <5) then
        num_quadrimestre := 2;
        ELSE 
         num_quadrimestre := 3;
    end if;

        nom_quadrimestre := num_quadrimestre || 'º Qim/' || ano;

        /* Coloca o semestre */
    IF (num_trimestre < 3) then
        num_semestre := 1;
    ELSE
        num_semestre := 2;
    end if;

    nom_semestre := num_semestre || 'º Sem/' ||  ano;

    num_dia_semana :=  TO_CHAR(dtc_dia,'D');


    IF num_dia_semana = 1 or num_dia_semana = 7 THEN
        sts_fim_de_semana := 1;
    ELSE
        sts_fim_de_semana := 0;
    END IF; 

    SELECT CASE mes
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
            END into nom_mes from dual;


        IF (dia <16) THEN
        quinzena := 1;
    ELSE  
        quinzena := 2;
    end if;

    nom_quinzena := quinzena || 'º Quin/' || SUBSTR(nom_mes,1,3);

    SELECT   CASE num_dia_semana
                WHEN 1 THEN 'Domingo'
                WHEN 2 THEN 'Segunda'
                WHEN 3 THEN 'Terça'
                WHEN 4 THEN 'Quarta'
                WHEN 5 THEN 'Quinta'
                WHEN 6 THEN 'Sexta'
                WHEN 7 THEN 'Sábado'
            END into nom_dia from dual;

        IF (mes <10) THEN
       dtc_mes_ano_numerico:='0'||to_char(mes)||'/'||substr(to_char(dtr_ano_mes),1,4);
    ELSE  
       dtc_mes_ano_numerico:=to_char(mes)||'/'||substr(to_char(dtr_ano_mes),1,4);
    end if;

        dtc_mes_ano:=substr(nom_mes,1,3)||'/'||substr(to_char(dtr_ano_mes),1,4);
        dtc_mes_ano_completo:=nom_mes||'/'||substr(to_char(dtr_ano_mes),1,4);
                      
    num_nivel  := 1;
    dtr_ano_mes2 := to_char(dtr_ano_mes);
    dtr_data:= to_date(dtc_dia2,'yyyymmdd');

    INSERT INTO DIM_TEMPO (DTC_DATA,NUM_ANO, NUM_DIA, NUM_MES, SK_TEMPO, DES_ANO_MES,DES_MES_ANO_NUMERICO,DES_MES_ANO_COMPLETO,DES_MES_ANO,DES_DATA_DIA,DES_DIA, DES_MES, DES_QUINZENA, DES_SEMESTRE, DES_TRIMESTRE, NUM_NIVEL, NUM_QUINZENA, NUM_SEMESTRE, NUM_TRIMESTRE, IND_FINAL_SEMANA, DES_BIMESTRE, DES_QUADRIMESTRE, NUM_BIMESTRE, NUM_QUADRIMESTRE)
    VALUES ( dtr_data,ano, dia, mes, cont,dtr_ano_mes2,dtc_mes_ano_numerico,dtc_mes_ano_completo,dtc_mes_ano,dtc_dia2,nom_dia, nom_mes, nom_quinzena, nom_semestre, nom_trimestre, num_nivel, quinzena, num_semestre, num_trimestre, sts_fim_de_semana, nom_bimestre, nom_quadrimestre, num_bimestre, num_quadrimestre);
    cont := cont + 1;
        commit;
           IF (mes_ant != mes) THEN
        mes_ant := mes;
        num_nivel := 2;
            INSERT INTO DIM_TEMPO (DTC_DATA,NUM_ANO, NUM_DIA, NUM_MES, SK_TEMPO,DES_ANO_MES,DES_MES_ANO_NUMERICO,DES_MES_ANO_COMPLETO,DES_MES_ANO,DES_DATA_DIA,DES_DIA, DES_MES, DES_QUINZENA, DES_SEMESTRE, DES_TRIMESTRE, NUM_NIVEL, NUM_QUINZENA, NUM_SEMESTRE, NUM_TRIMESTRE, IND_FINAL_SEMANA, DES_BIMESTRE, DES_QUADRIMESTRE, NUM_BIMESTRE, NUM_QUADRIMESTRE)
        VALUES ( NULL,ano, NULL, mes, cont,dtr_ano_mes2,dtc_mes_ano_numerico,dtc_mes_ano_completo,dtc_mes_ano, NULL, NULL,nom_mes, NULL, nom_semestre, nom_trimestre, num_nivel, NULL, num_semestre, num_trimestre, 0, nom_bimestre, nom_quadrimestre, num_bimestre, num_quadrimestre);
        cont := cont + 1;
                commit;
    END IF;
                
        /* Acrescenta um dia à data */
    dtc_dia := dtc_dia + 1;
    --SELECT dtc_dia2 = substring(convert(char(10),dtc_dia),7,4) + substring(convert(char(10),dtc_dia),4,2) + substring(convert(char(10),dtc_dia),1,2)
    /* Atualiza a condição de saída do LOOP */
    ano_inicio := EXTRACT (YEAR FROM dtc_dia); 
END LOOP;                        


   EXCEPTION
        WHEN OTHERS THEN 
            NULL;  -- informe aqui quaisquer códigos de exceção
END;