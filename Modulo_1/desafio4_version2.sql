DROP TABLE usuarios;
DROP TABLE posts;
DROP TABLE comentarios;

CREATE TABLE usuarios(
	id INT,
	email VARCHAR(50),
	nombre VARCHAR(16),
	apellido VARCHAR(16),
	rol VARCHAR
);

CREATE TABLE posts (
	id INT,
	titulo VARCHAR,
	contenido TEXT,
	fecha_creacion TIMESTAMP,
	fecha_actualizacion TIMESTAMP,
	destacado BOOLEAN,
	usuario_id BIGINT
);

CREATE TABLE comentarios (
	id INT,
	contenido TEXT,
	fecha_creacion TIMESTAMP,
	usuario_id BIGINT,
	post_id BIGINT
);


INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (1, 'Marco@example.com', 'Aurelio','Marco','Usuario');
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (2, 'Cole@example.com', 'Nicole','Nusbaumer','Administrador');
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (3, 'Luis@example.com', 'Luis','Borges','Usuario');
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (4, 'Vins@example.com', 'Vins','Jose','Administrador');
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (5, 'Cortaza@example.com', 'Helena','DeTroya','Usuario');


INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (1, 'Libro Propio','StoryTelling with data','2016-08-01','2025-10-28', TRUE, 2); --admin
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (2, 'Frase','No nacemos como un lienzo en blanco','2020-09-25','2025-09-22', TRUE, 4); --admin
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (3, 'Frase','No es facil que le vaya mal a alguno por no entrometerse en lo que ocurre en el ánimo de otro; pero es imposible el que deje de irle mal a quien no escudriña lo que pasa en el suyo','2017-02-23','2019-05-11', FALSE,1); --NO admin
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (4, 'Cuento','El jardin de los caminos que se bifurcan','1941-08-29' ,'1944-07-13',TRUE,1); --NO admin
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (5, 'Fragmentos en la Iliada y en la Odisea','Guerra de Troya','2002-04-05', '2008-12-01',FALSE, null); --sin usuario asignado


INSERT INTO comentarios(id, contenido, fecha_creacion, usuario_id, post_id)
VALUES (1, 'Es una invitación por parte del escritor a dejarnos llevar por la imaginación y no necesitar que lo que se dice sea una verdad irrefutable','2025-01-13',1,1);
INSERT INTO comentarios(id, contenido, fecha_creacion, usuario_id, post_id)
VALUES (2, 'Una postura estoica sigue siendo práctica y realista','2023-11-09' ,1,2);
INSERT INTO comentarios(id, contenido, fecha_creacion, usuario_id, post_id)
VALUES (3, 'Utilizar textos simples para comunicar pocas cifras','2025-10-06' ,1,3);
INSERT INTO comentarios(id, contenido, fecha_creacion, usuario_id, post_id)
VALUES (4, 'Se destaca la necesidad de comunicar datos de manera efectiva en un mundo donde la información es abundante pero la atención es limitada.','2018-03-19',2,1);
INSERT INTO comentarios(id, contenido, fecha_creacion, usuario_id, post_id)
VALUES (5, 'Emplear tablas para audiencias mixtas que busquen datos específicos','2024-09-10' ,2,2);
SELECT * FROM comentarios;

--1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
	--pedido.
SELECT * FROM usuarios;
SELECT * FROM posts;
SELECT * FROM comentarios;

--2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
	--nombre y email del usuario junto al título y contenido del post.
SELECT usuarios.nombre, usuarios.email, posts.titulo, posts.contenido 
FROM usuarios CROSS JOIN posts;

--3. Muestra el id, título y contenido de los posts de los administradores.
	--a. El administrador puede ser cualquier id
SELECT posts.id, posts.titulo, posts.contenido
FROM posts LEFT JOIN usuarios ON usuarios.id=posts.usuario_id
WHERE usuarios.rol='Administrador';

--4. Cuenta la cantidad de posts de cada usuario.
	--a. La tabla resultante debe mostrar el id e email del usuario junto con la
	--cantidad de posts de cada usuario.
SELECT usuarios.id, usuarios.email, count(posts.id) AS Cantidad_post
FROM usuarios LEFT JOIN posts on usuarios.id=posts.usuario_id
GROUP BY usuarios.id, usuarios.email;

--5. Muestra el email del usuario que ha creado más posts.
	--a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
WITH subconsulta AS(
	SELECT usuarios.id, usuarios.email, count(posts.id) AS Cantidad_post
	FROM usuarios LEFT JOIN posts on usuarios.id=posts.usuario_id
	GROUP BY usuarios.id, usuarios.email
)
SELECT email FROM subconsulta where Cantidad_post = (SELECT MAX(Cantidad_post) from subconsulta);

--6. Muestra la fecha del último post de cada usuario
SELECT usuarios.nombre, max(posts.fecha_creacion)
from posts left join usuarios ON posts.usuario_id=usuarios.id
where usuarios.nombre IS NOT NULL
GROUP BY posts.usuario_id, usuarios.nombre;

--7. Muestra el título y contenido del post (artículo) con más comentarios.
WITH subconsulta2 as (
	SELECT posts.titulo, posts.contenido, count(comentarios.contenido) AS conteo_coments
	from posts left join comentarios ON posts.id=comentarios.post_id
	GROUP BY posts.titulo, posts.contenido
)
SELECT titulo, contenido FROM subconsulta2 
WHERE conteo_coments = (SELECT MAX(conteo_coments) FROM subconsulta2);

--8. Muestra en una tabla el título de cada post, 
	--el contenido de cada post y 
	--el contenido de cada comentario asociado a los posts mostrados, 
	--junto con el email del usuario que lo escribió.
WITH subconsulta3 as(
	SELECT posts.usuario_id, posts.titulo, posts.contenido AS post_contenido, comentarios.contenido AS comentario_contenido
	FROM posts left join comentarios
	on posts.id=comentarios.post_id
)
SELECT titulo, post_contenido, comentario_contenido, usuarios.email 
FROM subconsulta3 left join usuarios on subconsulta3.usuario_id=usuarios.id;

--9. Muestra el contenido del último comentario de cada usuario

WITH subconsulta4 AS (
	SELECT max(comentarios.fecha_creacion) AS fecha, usuarios.id
	FROM comentarios left join usuarios 
	ON comentarios.usuario_id= usuarios.id
	group by usuarios.id
)

SELECT comentarios.contenido FROM subconsulta4 left join comentarios
on subconsulta4.id=comentarios.id;

--10. Muestra los emails de 
	--los usuarios que no han escrito ningún comentario

-- FORMA1
WITH subconsulta5 AS(
	SELECT usuarios.id, usuarios.email, comentarios.contenido from usuarios left join comentarios
	ON usuarios.id=comentarios.usuario_id
	WHERE comentarios.contenido IS NULL
)
SELECT email from subconsulta5;

-- FORMA2
SELECT usuarios.email from usuarios left join comentarios
ON usuarios.id=comentarios.usuario_id
WHERE comentarios.contenido IS NULL

