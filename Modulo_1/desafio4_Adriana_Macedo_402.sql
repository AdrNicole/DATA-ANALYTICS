drop table usuarios;
drop table posts;
drop table comentarios;

-- usuarios
CREATE TABLE usuarios(
	id INT,
	email VARCHAR(50),
	nombre VARCHAR(16),
	apellido VARCHAR(16),
	rol VARCHAR
);

-- posts (artículos)
CREATE TABLE posts(
	id INT,
	titulo VARCHAR,
	contenido TEXT,
	fecha_creacion TIMESTAMP,
	fecha_actualizacion TIMESTAMP,
	destacado BOOLEAN,
	usuario_id BIGINT
);

--comentarios
CREATE TABLE comentarios(
	id INT,
	contenido VARCHAR,
	fecha_creacion TIMESTAMP,
	usuario_id BIGINT,
	post_id BIGINT
);

INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (1, 'Marco@example.com', 'Aurelio','Marco','Usuario');
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (2, 'Cole@example.com', 'Nicole','Nusbaumer','Administrador');
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (3, 'Luis@example.com', 'Luis','Borges','Usuario');
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (4, 'Vins@example.com', 'Vins','Jose','Administrador');
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES (5, 'Cortaza@example.com', 'Helena','DeTroya','Usuario');
--select * from usuarios;

INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (1, 'Libro Propio','StoryTelling with data','2016-08-01','2025-10-28','True', 2); --admin
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (2, 'Frase','No nacemos como un lienzo en blanco','2020-09-25','2025-09-22','True', 4); --admin
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (3, 'Frase','No es facil que le vaya mal a alguno por no entrometerse en lo que ocurre en el ánimo de otro; pero es imposible el que deje de irle mal a quien no escudriña lo que pasa en el suyo','2017-02-23','2019-05-11', 'False',1); --NO admin
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (4, 'Cuento','El jardin de los caminos que se bifurcan','1941-08-29' ,'1944-07-13','True',1); --NO admin
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
VALUES (5, 'Fragmentos en la Iliada y en la Odisea','Guerra de Troya','2002-04-05', '2008-12-01','False', null); --sin usuario asignado
--select * from posts

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
--select * from comentarios

--1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
	--pedido.
select * from usuarios;
select * from posts;
select * from comentarios;

--2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
	--nombre y email del usuario junto al título y contenido del post.
select usuarios.nombre, usuarios.email, posts.titulo, posts.contenido 
from usuarios cross join posts;

--3. Muestra el id, título y contenido de los posts de los administradores.
	--a. El administrador puede ser cualquier id
SELECT posts.id, posts.titulo, posts.contenido
from posts left join usuarios on usuarios.id= posts.usuario_id
where usuarios.rol ='Administrador';
--select * from usuarios;

--4. Cuenta la cantidad de posts de cada usuario.
	--a. La tabla resultante debe mostrar el id e email del usuario junto con la
	--cantidad de posts de cada usuario.
	
SELECT usuarios.id, usuarios.email, count(posts.usuario_id)  AS cantidad_posts
from usuarios left join posts on usuarios.id=posts.usuario_id 
where usuarios.rol ='Usuario'
group by usuarios.id, usuarios.email;

--5. Muestra el email del usuario que ha creado más posts.
	--a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
-- FORMA 1
SELECT usuarios.email
from usuarios left join posts on usuarios.id=posts.usuario_id
where usuarios.rol ='Usuario' 
group by usuarios.email 
ORDER BY count(posts.usuario_id) desc LIMIT 1;

-- FORMA 2: subconsula
SELECT email FROM (
	SELECT usuarios.email, count(posts.usuario_id) AS cant_posts 
	from usuarios left join posts on usuarios.id=posts.usuario_id
	where usuarios.rol ='Usuario' 
	group by usuarios.email
	ORDER BY cant_posts desc 
	LIMIT 1
) AS subconsulta;

--6. Muestra la fecha del último post de cada usuario
SELECT usuario_id, max(posts.fecha_creacion) AS ultimo_posts from posts 
left join usuarios on usuarios.id= posts.usuario_id 
where usuario_id IS NOT NULL group by usuario_id;

--7. Muestra el título y contenido del post (artículo) con más comentarios.
-- FORMA 1
WITH subconsulta2 AS (
	SELECT posts.titulo, posts.contenido, count(comentarios.post_id) AS conteo_comentarios
	FROM posts left join comentarios on posts.id=comentarios.post_id
	group by posts.titulo, posts.contenido
)
select titulo, contenido, conteo_comentarios FROM subconsulta2
WHERE conteo_comentarios = (SELECT MAX(conteo_comentarios) FROM subconsulta2);

-- FORMA 2
select posts.titulo, posts.contenido, 
count(comentarios.post_id) AS conteo_comentarios 
from comentarios right join posts on posts.id=comentarios.post_id 
group by posts.titulo, posts.contenido order by conteo_comentarios desc LIMIT 1;

--8. Muestra en una tabla el título de cada post, 
	--el contenido de cada post y 
	--el contenido de cada comentario asociado a los posts mostrados, 
	--junto con el email del usuario que lo escribió.

WITH subconsulta3 AS (
	SELECT posts.titulo, posts.contenido, comentarios.contenido AS comentarios, 
	posts.usuario_id, posts.id AS id_
	FROM posts left join comentarios on posts.id=comentarios.post_id
)

SELECT titulo, contenido, comentarios, usuarios.email 
FROM subconsulta3 left join usuarios on subconsulta3.id_=usuarios.id
where usuarios.rol='Usuario';

--9. Muestra el contenido del último comentario de cada usuario
SELECT comentarios.contenido, max(comentarios.fecha_creacion) AS fecha_final from comentarios
left join usuarios on  comentarios.usuario_id=usuarios.id
where usuarios.rol='Usuario' group by comentarios.contenido;

/*
--muestra el nombre del usuario y contenido cuyo comentario tiene la fecha mas reciente
WITH subconsulta4 AS (
	SELECT comentarios.contenido, usuarios.nombre, usuarios.rol, comentarios.fecha_creacion AS fecha_ultima 
	FROM comentarios left join usuarios 
	on comentarios.usuario_id=usuarios.id
	where usuarios.rol='Usuario'
)

SELECT nombre, contenido, fecha_ultima
FROM subconsulta4
WHERE fecha_ultima=(SELECT MAX(fecha_ultima) FROM subconsulta4);
*/

--10. Muestra los emails de los usuarios que no han escrito ningún comentario

-- FORMA 1
SELECT usuarios.id, usuarios.email, comentarios.contenido
FROM usuarios left join comentarios
on usuarios.id=comentarios.usuario_id
WHERE usuarios.rol='Usuario'
GROUP BY usuarios.id, usuarios.email, comentarios.contenido
HAVING comentarios.contenido is null; 

-- FORMA 2
SELECT usuarios.id, usuarios.email, comentarios.contenido
FROM usuarios left join comentarios
on usuarios.id=comentarios.usuario_id
where usuarios.rol='Usuario' and comentarios.contenido is null;
