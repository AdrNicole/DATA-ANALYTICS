DROP TABLE clientes;

CREATE TABLE clientes (
	ID int,
	email VARCHAR(50),
	nombre VARCHAR,
	telefono VARCHAR(16),
	empresa VARCHAR(50),
	prioridad SMALLINT
);

INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (1,'walejandriasanchez84@gmail.com', 'Alejandro','956497645','Visa Inc',4);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (2,'cesaralbertosullonflores6@gmail.com', 'Cesar','497649565','Revolut',7);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (3,'cesarpasco-65@hotmail.com', 'Cesar','999567645','EY',2);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (4,'contabilidad@peruoverview.com', 'Carlos','936764549','Deloitte',5);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (5,'anyhelo.s.r@gmail.com', 'Anyelo','956159764','PricewaterhouseCoopers',3);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (6,'OLGALOMAS30@GMAIL.COM', 'Olga','956497645','Mitsui Auto Finance',1);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (7,'elizabetvq2116@gamil.com', 'Elizabet','973495645','JPMorgan Chase & Co',9);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (8,'curi664@GMAIL.COM', 'Cole','966645645','Google',10);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (9,'isabel.sanchez7647@gamil.com', 'Isabel','956497645','Audi AG',8);
INSERT INTO clientes (id, email, nombre, telefono, empresa, prioridad) VALUES (10,'dondemoniorest@gmail.com', 'Ulises','997645645','NTT Data',6);

--SELECT * FROM clientes;
--SELECT * FROM clientes WHERE prioridad>=8;
SELECT * FROM clientes WHERE prioridad>=5 ORDER BY prioridad DESC;