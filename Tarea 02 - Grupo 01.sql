-- TAREA 02 - Grupo 01 --

/*
Se crearán 5 tablas para el proceso de compras solicitadas por el área de producción.

TABLA			tb_responsables

COLUMNA					DESCRIPCION
resp_id					tinyint, restriccion de llave primaria que no acepte nulos
resp_dni				char(8), DNI del responsable
resp_name				varchar(100), no acepta nulos
resp_correo				varchar(80)

TABLA			tb_produccion

COLUMNA					DESCRIPCION
linea_id				tinyint, restriccion de llave primaria que no acepte nulos 
linea_name				varchar(50), no acepta nulos
resp_id					char(8), restriccion de llave foranea que referencie a la columna resp_id de la tabla tb_responsables

TABLA			tb_articulos

COLUMNA					DESCRIPCION
articulo_id				smallint, restriccion de llave primaria que no acepte nulos
art_name				varchar(100), no acepta nulos
art_categoria			varchar(80), no acepta nulos

TABLA			tb_solicitudes

COLUMNA					DESCRIPCION
sol_id					int, restriccion de llave foranea que referencie a la columna au_id de la tabla tb_autores
sol_date				date, no acepta nulos
sol_cantidad			int, no acepta nulos
sol_um					varchar(3) no acepta nulos
articulo_id				smallint, restriccion de llave foranea que referencie a la columna articulo_id de la tabla tb_articulos
linea_id				tinyint, restriccion de llave foranea que referencie a la columna linea_id de la tabla tb_produccion

TABLA			tb_compras

COLUMNA					DESCRIPCION
compra_id				int, restriccion de llave foranea que referencie a la columna au_id de la tabla tb_autores
factura_nro				varchar(15), no acepta nulos
factura_date			date, no acepta nulos
factura_monto			decimal (12,2), no acepta nulos
sol_id					int, restriccion de llave foranea que referencie a la columna sol_id de la tabla tb_solicitudes
--
*/

IF OBJECT_ID('T2_tb_responsables') is not null
	drop table T2_tb_responsables
go	
create table T2_tb_responsables
(
	resp_id				tinyint			not null constraint pk_T2_tb_responsables primary key (resp_id),
	resp_dni			char(8)			not null,
	resp_name			varchar(100)	not null,
	resp_correo			varchar(80)
)
go

alter table T2_tb_responsables
add constraint ck_T2_tb_responsables_resp_dni check (resp_dni like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
go
exec sp_helpconstraint T2_tb_responsables


go
insert into T2_tb_responsables (resp_id, resp_dni, resp_name, resp_correo) values (1,'07550037','Kristhoffer Cruz','')
insert into T2_tb_responsables (resp_id, resp_dni, resp_name, resp_correo) values (2,'75986548','Juan Perez','juanp@gmail.com')
insert into T2_tb_responsables (resp_id, resp_dni, resp_name, resp_correo) values (3,'18416479','Rosa Arias','')


go
select * from T2_tb_responsables


go
IF OBJECT_ID('T2_tb_produccion') is not null
	drop table T2_tb_produccion
go	
create table T2_tb_produccion
(
	linea_id				tinyint			not null constraint pk_T2_tb_produccion primary key (linea_id), 
	linea_name				varchar(50)		not null,
	resp_id					tinyint			not null constraint fk_T2_tb_produccion_resp_id foreign key (resp_id) references T2_tb_responsables (resp_id)
)
go

insert into T2_tb_produccion (linea_id, linea_name, resp_id) values (1,'Línea de Pisos',2)
insert into T2_tb_produccion (linea_id, linea_name, resp_id) values (2,'Línea de Decking',1)
insert into T2_tb_produccion (linea_id, linea_name, resp_id) values (3,'Línea de Deck Tile',1)


go
select * from T2_tb_produccion


go
IF OBJECT_ID('T2_tb_articulos') is not null
	drop table T2_tb_articulos
go	
create table T2_tb_articulos
(
	articulo_id				smallint		not null constraint pk_T2_tb_articulos primary key (articulo_id),
	art_name				varchar(max)	not null,
	art_categoria			varchar(80)		not null
)
go


insert into T2_tb_articulos (articulo_id, art_name, art_categoria) values (101,'Banda de Lija GR100','Suministros')
insert into T2_tb_articulos (articulo_id, art_name, art_categoria) values (102,'Banda de Lija GR150','Suministros')
insert into T2_tb_articulos (articulo_id, art_name, art_categoria) values (103,'Banda de Lija GR220','Suministros')
go
select * from T2_tb_articulos


go
IF OBJECT_ID('T2_tb_solicitudes') is not null
	drop table T2_tb_solicitudes
go	
create table T2_tb_solicitudes
(
	sol_id					int				not null constraint pk_T2_tb_solicitudes primary key (sol_id),
	sol_date				date			not null,
	sol_cantidad			int				not null,
	sol_um					varchar(3)		not null,
	articulo_id				smallint		not null constraint fk_T2_tb_solicitudes_articulo_id foreign key (articulo_id) references T2_tb_articulos (articulo_id),
	linea_id				tinyint			not null constraint fk_T2_tb_solicitudes_linea_id foreign key (linea_id) references T2_tb_produccion (linea_id)
)
go


insert into T2_tb_solicitudes (sol_id, sol_date, sol_cantidad, sol_um, articulo_id,linea_id) values (7704,'2022-01-30T00:00:00',45,'und',101,1)
insert into T2_tb_solicitudes (sol_id, sol_date, sol_cantidad, sol_um, articulo_id,linea_id) values (7705,'2022-01-30T00:00:00',55,'und',102,1)
insert into T2_tb_solicitudes (sol_id, sol_date, sol_cantidad, sol_um, articulo_id,linea_id) values (7706,'2022-01-30T00:00:00',120,'und',103,1)

go
select * from T2_tb_solicitudes


go
IF OBJECT_ID('T2_tb_compras') is not null
	drop table T2_tb_compras
go	
create table T2_tb_compras
(
	compra_id				int				not null constraint pk_T2_tb_compras primary key (compra_id),
	fact_nro				varchar(15)		not null,
	fact_date				date			not null constraint ck_T2_tb_compras_fact_date check (fact_date < getdate()),
	fact_monto				decimal (12,2)	not null,
	sol_id					int				not null constraint fk_T2_tb_compras_sol_id foreign key (sol_id) references T2_tb_solicitudes (sol_id)
)
go


insert into T2_tb_compras (compra_id, fact_nro, fact_date, fact_monto, sol_id) values (9988,'EF01-0000356','2022-01-30T00:00:00',485.15,7704)
insert into T2_tb_compras (compra_id, fact_nro, fact_date, fact_monto, sol_id) values (9989,'EF01-0000356','2022-01-30T00:00:00',595.80,7705)
insert into T2_tb_compras (compra_id, fact_nro, fact_date, fact_monto, sol_id) values (9990,'EF01-0000356','2022-01-30T17:45:00',1200.78,7706)

go
select * from T2_tb_compras
