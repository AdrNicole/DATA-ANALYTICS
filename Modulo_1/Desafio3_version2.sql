DROP TABLE inscritos;
CREATE TABLE INSCRITOS(cantidad INT, fecha DATE, fuente VARCHAR);
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 44, '2021-01-01', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 56, '2021-01-01', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 39, '2021-01-02', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 81, '2021-01-02', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 12, '2021-01-03', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 91, '2021-01-03', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 48, '2021-01-04', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 45, '2021-01-04', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 55, '2021-01-05', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 33, '2021-01-05', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 18, '2021-01-06', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 12, '2021-01-06', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 34, '2021-01-07', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 24, '2021-01-07', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 83, '2021-01-08', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 99, '2021-01-08', 'Página' );


--1. ¿Cuántos registros hay?
SELECT count(*) AS tota_filas FROM inscritos;
--2. ¿Cuántos inscritos hay en total?
SELECT sum(cantidad) FROM INSCRITOS;

--3. ¿Cuál o cuáles son los registros de mayor antigüedad? obs: ocupar subconsultas
SELECT * from inscritos where fecha = (SELECT min(fecha) from inscritos);

--4. ¿Cuántos inscritos hay por día? (Indistintamente de la fuente de inscripción)
SELECT fecha, sum(cantidad) AS inscritos_dia from inscritos group by fecha;

--5. ¿Cuántos inscritos hay por fuente?
SELECT fuente, sum(cantidad) AS inscritos_fuente from inscritos group by fuente;

--6. ¿Qué día se inscribió la mayor cantidad de personas? Y ¿Cuántas personas se
	-- inscribieron en ese día?
-- FORMA 1
WITH subconsulta3 as (
	SELECT fecha, sum(cantidad) AS inscritos_dia 
	FROM inscritos group by fecha
)

SELECT * FROM subconsulta3 where inscritos_dia =(SELECT max(inscritos_dia ) from subconsulta3);

-- FORMA 2
SELECT fecha, sum(cantidad) AS inscritos_dia 
FROM inscritos group by fecha ORDER BY inscritos_dia desc LIMIT 1;

--7. ¿Qué día se inscribieron la mayor cantidad de personas utilizando el blog? ¿Cuántas
	-- personas fueron? (si hay más de un registro con el máximo de personas, considera
	-- solo el primero)
-- FORMA 1
SELECT fecha, cantidad from inscritos 
where fuente='Blog'
order by cantidad desc LIMIT 1;

-- FORMA 2
WITH subconsulta4 AS (
	SELECT * from inscritos
	where fuente='Blog'
)
SELECT fecha, cantidad from subconsulta4 WHERE cantidad = (SELECT max(cantidad) from subconsulta4);

--8. ¿Cuál es el promedio de personas inscritas por día? Toma en consideración que la
	-- base de datos tiene un registro de 8 días, es decir, se obtendrán 8 promedios.
SELECT avg(cantidad) from inscritos group by fecha;

--9. ¿Qué días se inscribieron más de 50 personas?
SELECT fecha, cantidad from inscritos where cantidad>50 ORDER BY cantidad;

--10. ¿Cuál es el promedio por día de personas inscritas?
	-- Considerando sólo calcular desde el tercer día.
SELECT fecha, avg(cantidad) from inscritos group by fecha 
having fecha>'2021-01-03';

