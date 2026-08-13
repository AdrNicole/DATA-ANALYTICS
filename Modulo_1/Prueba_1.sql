--1.	Revisa el tipo de relación y crea el modelo correspondiente. 
--Respeta las claves primarias, foráneas y tipos de datos.
DROP TABLE IF EXISTS RelacionPelis;
DROP TABLE IF EXISTS Peliculas;
DROP TABLE IF EXISTS Tags;

CREATE TABLE Peliculas (
	pelis_id SERIAL PRIMARY KEY,
	nombre VARCHAR(255),
	anno INTEGER
);

CREATE TABLE Tags (
	tags_id SERIAL PRIMARY KEY,
	tag VARCHAR(32)
);

--2.	Inserta 5 películas y 5 tags; la primera película debe tener 
--3 tags asociados, la segunda película debe tener 2 tags asociados. 

	-- Crear la tabla intermedia RelacionPelis (Peliculas ↔ Tags)

CREATE TABLE RelacionPelis (
	pelis_id INTEGER references Peliculas(pelis_id) ON DELETE CASCADE,
	tags_id INTEGER references Tags(tags_id) ON DELETE CASCADE,
	PRIMARY KEY (pelis_id, tags_id)
);

SELECT * FROM Peliculas;
SELECT * FROM Tags;
SELECT * FROM RelacionPelis;
	--entidades
INSERT INTO Peliculas(nombre, anno) VALUES ('Avatar: El camino del agua',2022);
INSERT INTO Peliculas(nombre, anno) VALUES ('Conclave', 2025);
INSERT INTO Peliculas(nombre, anno) VALUES ('Flow',2025);
INSERT INTO Peliculas(nombre, anno) VALUES ('Sueño de fuga',1994);
INSERT INTO Peliculas(nombre, anno) VALUES ('Toy Story',1995);

INSERT INTO Tags (tag) VALUES ('Ciencia ficción');
INSERT INTO Tags (tag) VALUES ('Thriller');
INSERT INTO Tags (tag) VALUES ('Drama');
INSERT INTO Tags (tag) VALUES ('Animacion');
INSERT INTO Tags (tag) VALUES ('Familia');

	--relaciones
INSERT INTO RelacionPelis(pelis_id,tags_id) VALUES --((1),(1))
((Select pelis_id from peliculas where nombre='Avatar: El camino del agua'),
(Select tags_id from Tags where tag='Ciencia ficción'));

INSERT INTO RelacionPelis(pelis_id,tags_id) VALUES --((1),(4))
((Select pelis_id from peliculas where nombre='Avatar: El camino del agua'),
(Select tags_id from Tags where tag='Animacion'));

INSERT INTO RelacionPelis(pelis_id,tags_id) VALUES 
((Select pelis_id from peliculas where nombre='Avatar: El camino del agua'),
(Select tags_id from Tags where tag='Familia'));

INSERT INTO RelacionPelis(pelis_id,tags_id) VALUES
((Select pelis_id from peliculas where nombre='Conclave'),
(Select tags_id from Tags where tag='Thriller'));

INSERT INTO RelacionPelis(pelis_id,tags_id) VALUES
((Select pelis_id from peliculas where nombre='Conclave'),
(Select tags_id from Tags where tag='Drama'));

--DELETE from RelacionPelis;
--DELETE from Tags;



--3.	Cuenta la cantidad de tags que tiene cada película. Si una 
---película no tiene tags debe mostrar 0. 
SELECT Peliculas.nombre, count(RelacionPelis.pelis_id) 
from Peliculas left join RelacionPelis
	on Peliculas.pelis_id=RelacionPelis.pelis_id
	group by Peliculas.nombre;

--4.	Crea las tablas correspondientes respetando los nombres, tipos, 
--claves primarias y foráneas y tipos de datos. 
DROP TABLE RESPUESTAS;
DROP TABLE PREGUNTAS;
DROP TABLE USUARIOS;

CREATE TABLE Preguntas (
	preguntas_id SERIAL PRIMARY KEY,
	pregunta VARCHAR(255),
	respuesta_correcta VARCHAR
);

CREATE TABLE Usuarios (
	usuarios_id SERIAL PRIMARY KEY,
	nombre VARCHAR(255),
	edad INTEGER
);

CREATE TABLE Respuestas (
	PRIMARY KEY (usuario_id, pregunta_id),
	respuesta VARCHAR(255),
	usuario_id INT REFERENCES usuarios(usuarios_id) ON DELETE CASCADE,
	pregunta_id INT REFERENCES Preguntas(preguntas_id) ON DELETE CASCADE
);

-- 5.	Agrega 5 usuarios y 5 preguntas.

INSERT INTO Preguntas(pregunta,respuesta_correcta) VALUES ('¿Cuál es el animal terrestre más grande del mundo?','El elefante africano');
INSERT INTO Preguntas(pregunta,respuesta_correcta) VALUES ('¿Cuál es el océano más grande de la Tierra?','El Océano Pacífico');
INSERT INTO Preguntas(pregunta,respuesta_correcta) VALUES ('¿Cuántos días tiene un año (si no es bisiesto)?','365 días');
INSERT INTO Preguntas(pregunta,respuesta_correcta) VALUES ('¿Cuál es el órgano más grande del cuerpo?','La piel');
INSERT INTO Preguntas(pregunta,respuesta_correcta) VALUES ('¿Cómo se llama el proceso por el cual las plantas fabrican su propio alimento?','Fotosíntesis');

INSERT INTO Usuarios(nombre,edad) VALUES ('Usuario1',18);
INSERT INTO Usuarios(nombre,edad) VALUES ('Usuario2',20);
INSERT INTO Usuarios(nombre,edad) VALUES ('Usuario3',21);
INSERT INTO Usuarios(nombre,edad) VALUES ('Usuario4',19);
INSERT INTO Usuarios(nombre,edad) VALUES ('Usuario5',27);

--DROP TABLE IF EXISTS usuarios;
SELECT * FROM PREGUNTAS;
SELECT * FROM USUARIOS;
SELECT * FROM RESPUESTAS;
--DELETE FROM PREGUNTAS WHERE PREGUNTAS_ID=1

INSERT INTO Respuestas(respuesta,usuario_id,pregunta_id) VALUES --('',(),())
('El elefante africano',
(select usuarios_id from usuarios where nombre='Usuario1'),
(select preguntas_id from preguntas where pregunta='¿Cuál es el animal terrestre más grande del mundo?'));

INSERT INTO Respuestas(respuesta,usuario_id,pregunta_id) VALUES ('El elefante africano',
(select usuarios_id from usuarios where nombre='Usuario2'),
(select preguntas_id from preguntas where pregunta='¿Cuál es el animal terrestre más grande del mundo?'));

INSERT INTO Respuestas(respuesta,usuario_id,pregunta_id) VALUES ('El Océano Pacífico',
(select usuarios_id from usuarios where nombre='Usuario3'),
(select preguntas_id from preguntas where pregunta='¿Cuál es el océano más grande de la Tierra?'));

INSERT INTO Respuestas(respuesta,usuario_id,pregunta_id) VALUES ('no se',
(select usuarios_id from usuarios where nombre='Usuario4'),
(select preguntas_id from preguntas where pregunta='¿Cuántos días tiene un año (si no es bisiesto)?'));

INSERT INTO Respuestas(respuesta,usuario_id,pregunta_id) VALUES ('-',
(select usuarios_id from usuarios where nombre='Usuario5'),
(select preguntas_id from preguntas where pregunta='¿Cuál es el órgano más grande del cuerpo?'));

	--delete from respuestas where respuesta='-';
-- 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la 
--pregunta).

select respuestas.usuario_id, count(*) AS Toral_correctas from preguntas 
inner join respuestas 
	on preguntas.preguntas_id=respuestas.pregunta_id
inner join usuarios
	on respuestas.usuario_id=usuarios.usuarios_id
WHERE preguntas.respuesta_correcta=respuestas.respuesta
GROUP BY respuestas.usuario_id;

-- 7.	Por cada pregunta, en la tabla preguntas, cuenta cuántos 
--usuarios respondieron correctamente.

select preguntas.preguntas_id, count(*) AS Cant_usuarios from preguntas
left join respuestas 
	on preguntas.preguntas_id=respuestas.pregunta_id
left join usuarios
	on usuarios.usuarios_id=respuestas.usuario_id
WHERE preguntas.respuesta_correcta=respuestas.respuesta
GROUP BY preguntas.preguntas_id;

-- 8.	Implementa un borrado en cascada de las respuestas al borrar 
--un usuario. Prueba la implementación borrando el primer usuario. 
DELETE from usuarios where usuarios_id=1;
	--verificar si ssigue en la tabla usuarios
select * from Usuarios where usuarios_id=1;
	--verificar si sigue en ña tabla respuestas
select * from respuestas where usuario_id=1;
	--consulta para verificar respuestas correctas;
	
--9.	Crea una restricción que impida insertar usuarios menores 
-- de 18 años en la base de datos. 
DROP TABLE usuarios_1;
CREATE TABLE Usuarios_1 (
	usuarios_1_id SERIAL PRIMARY KEY,
	nombre VARCHAR(255),
	edad INT CHECK (edad>=18)
);
select * from usuarios_1;
INSERT INTO usuarios_1(nombre,edad) VALUES ('ALEXANDER',17);
--10.	Altera la tabla existente de usuarios agregando el campo email.
--Debe tener la restricción de ser único.

ALTER TABLE usuarios_1
ADD COLUMN email VARCHAR(100) UNIQUE;



