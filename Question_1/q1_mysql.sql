create table gender_data(CountryName varchar(50),CountryCode varchar(20),
IndicatorName varchar(500),IndicatorCode varchar(30),`1960` varchar(100),
`1961` varchar(100),`1962` varchar(100),`1963` varchar(100),`1964` varchar(100),`1965` varchar(100),`1966` varchar(100),
`1967` varchar(100),`1968` varchar(100),`1969` varchar(100),`1970` varchar(100),`1971` varchar(100),`1972` varchar(100),
`1973` varchar(100),`1974` varchar(100),`1975` varchar(100),`1976` varchar(100),`1977` varchar(100),`1978` varchar(100),
`1979` varchar(100),`1980` varchar(100),`1981` varchar(100),`1982` varchar(100),`1983` varchar(100),`1984` varchar(100),
`1985` varchar(100),`1986` varchar(100),`1987` varchar(100),`1988` varchar(100),`1989` varchar(100),`1990` varchar(100),
`1991` varchar(100),`1992` varchar(100),`1993` varchar(100),`1994` varchar(100),`1995` varchar(100),`1996` varchar(100),
`1997` varchar(100),`1998` varchar(100),`1999` varchar(100),`2000` varchar(100),`2001` varchar(100),`2002` varchar(100),
`2003` varchar(100),`2004` varchar(100),`2005` varchar(100),`2006` varchar(100),`2007` varchar(100),`2008` varchar(100),
`2009` varchar(100),`2010` varchar(100),`2011` varchar(100),`2012` varchar(100),`2013` varchar(100),`2014` varchar(100),
`2015` varchar(100),`2016` varchar(100));

--TRANSPOSE THE TABLE FOR EASIER READING AND ACCESING

CREATE TABLE GENDER_STAT_DB.TRANSPOSE_DATA (CountryName varchar(50), IndicatorCode varchar(30), YearsByCountry INTEGER, Data FLOAT );

DELIMITER $$
CREATE PROCEDURE GENDER_STAT_DB.TRANSPOSE(MIN_VALUE INTEGER, MAX_VALUE INTEGER)
BEGIN

DECLARE YEAR INTEGER;
DECLARE COLNAME varchar(50);
SET YEAR = MIN_VALUE;

WHILE YEAR <= MAX_VALUE 
DO

SET @COLNAME = CONCAT('`',YEAR,'`');
SET @STATEMENT = CONCAT(
    'INSERT INTO GENDER_STAT_DB.TRANSPOSE_DATA (CountryName, IndicatorCode, YearsByCountry, Data)',
    ' SELECT CountryName, IndicatorCode, ', YEAR,',', @COLNAME,
    ' FROM GENDER_STAT_DB.gender_data',
    ' WHERE ', @COLNAME,
    ' IS NOT NULL'
);

PREPARE STMT FROM @STATEMENT;
EXECUTE STMT;
DEALLOCATE PREPARE STMT;

SET YEAR = YEAR + 1;
END WHILE;
END$$
DELIMITER ;

CALL GENDER_STAT_DB.TRANSPOSE(2010,2016);

-- VIEWS for Hive and Pig (respectively)

CREATE VIEW question_1_hive AS
SELECT CountryName, IndicatorCode, YearsByCountry, Data
FROM TRANSPOSE_DATA
WHERE IndicatorCode = 'SE.TER.CMPL.FE.ZS';