DROP TABLE INSCRITOS;
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
	--select count(*) AS total_registros from inscritos;

--2. ¿Cuántos inscritos hay en total?
	--select sum(cantidad) AS total_inscritos from inscritos;

--3. ¿Cuál o cuáles son los registros de mayor antigüedad? obs: ocupar subconsultas
	--select min(fecha) AS fecha_antigua from inscritos;
	--select * from inscritos where fecha='2021-01-01';

--4. ¿Cuántos inscritos hay por día? (Indistintamente de la fuente de inscripción)
	--select fecha, sum(cantidad) AS inscritosXdia from inscritos 
	--group by fecha order by fecha;

--5. ¿Cuántos inscritos hay por fuente?
	--select fuente, sum(cantidad) AS inscritosXfuente 
	--from inscritos group by fuente;

--6. ¿Qué día se inscribió la mayor cantidad de personas? Y ¿Cuántas personas se
	-- inscribieron en ese día?
	--select fecha, sum(cantidad) AS inscritosXdia from inscritos group by fecha 
	--order by inscritosXdia desc LIMIT 1;

--7. ¿Qué día se inscribieron la mayor cantidad de personas utilizando el blog? ¿Cuántas
	-- personas fueron? (si hay más de un registro con el máximo de personas, considera
	-- solo el primero)
	--select fecha, cantidad, fuente from inscritos where fuente='Blog' order by cantidad desc LIMIT 1; */

--8. ¿Cuál es el promedio de personas inscritas por día? Toma en consideración que la
	-- base de datos tiene un registro de 8 días, es decir, se obtendrán 8 promedios.
	-- select fecha, avg(cantidad) AS promedio from inscritos group by fecha;

--9. ¿Qué días se inscribieron más de 50 personas?
	--select fecha, sum(cantidad) AS inscritosXdia from inscritos group by fecha having sum(cantidad)>50 order by fecha;

--10. ¿Cuál es el promedio por día de personas inscritas?
	-- Considerando sólo calcular desde el tercer día.
	--select fecha, avg(cantidad) from inscritos group by fecha order by fecha;






