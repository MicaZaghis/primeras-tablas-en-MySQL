# ---> Ejercicio 1. Realice la creación de las tablas que conforman esta base de datos.
create database prueba; 
use prueba;
create table empleados 
(
elegajo char(6) primary key, 
edni int unique not null, 
enombre varchar(100) not null, 
etel varchar(20) not null,
edireccion varchar(100) not null, 
eciudad varchar(100) not null, 
efecha_nac date not null, 
efecha_ing date not null
); 
select *
from empleados
where elegajo= 'CAA100' or elegajo= 'TRE325';

create table areas
(
acod char(6) primary key,
anombre varchar(100) not null
);
select *
from areas;

create table productos 
(
pcod char(6)not null , 
pnombre varchar(100) not null,
ppeso_maximo float not null,  
ptipo varchar(100) not null, 
acod char(6) not null,
primary key(pcod,acod),
foreign key(acod) references areas (acod)
);
select *
from productos;
 
create table trabaja
(
elegajo char(6) not null,
acod char(6) not null,
tanio_asing int not null,
tcant_horas int not null,
primary key(elegajo,acod),
foreign key(elegajo) references empleados(elegajo),
foreign key(acod) references areas(acod)
);
select* 
from trabaja

# ---> Ejercicio 2 - 6). 
alter table empleados 
add ehijos int default 0;

# ---> Ejercicio 2 - 7). 
UPDATE empleados SET ehijos = 1 WHERE elegajo = 'DRT456' or elegajo = 'ZXC753' or elegajo = 'XCV357';
UPDATE empleados SET ehijos = 2 WHERE elegajo = 'EPA315' or elegajo = 'TGB124' or elegajo = 'IKM985'; 
UPDATE empleados SET ehijos = 3 WHERE elegajo = 'POI951' or elegajo = 'LKJ325';
UPDATE empleados SET ehijos = 5 WHERE elegajo = 'ASD423';
UPDATE empleados SET ehijos = 6 WHERE elegajo = 'WER852';

#EJERCICIOS DEL PUNTO 3. 
/* 1. Obtener un listado con la información completa de todos los productos que produce la empresa. */
select *
from productos; 

/*2. Obtener un listado con nombre, dirección y teléfono de todos los empleados ordenados alfabéticamente por nombre.*/
SELECT enombre, edireccion, etel
FROM empleados
ORDER BY enombre; 

/*3. Obtener un listado con legajo, nombre y dirección de todos los empleados en orden descendente según su antigüedad en la empresa.*/
SELECT elegajo, enombre, edireccion, efecha_ing
FROM empleados
ORDER BY efecha_ing DESC;

/*4. Listar el nombre y tipo de todos los productos junto con el nombre y código del área que los produce.*/
SELECT pnombre, ptipo, anombre, areas.acod
FROM productos, areas 
WHERE productos.acod = areas.acod;

/*5. Obtener código y nombre de todos los productos de tipo “LACTEOS”, junto al código y nombre del área a la cual pertenecen. 
El listado debe mostrarse ordenado alfabéticamente por nombre del producto.*/
SELECT pcod, pnombre, areas.acod, areas.anombre
FROM productos, areas
WHERE productos.ptipo LIKE 'LACTEOS' and productos.acod= areas.acod
ORDER BY pnombre; 

/*6. Obtener el nombre y código de las áreas que producen productos de tipo “CARNES”.*/
SELECT DISTINCT anombre, areas.acod, productos.ptipo
FROM areas, productos
WHERE productos.ptipo LIKE 'CARNES' and areas.acod = productos.acod;

/*7. Dar el nombre, legajo y dirección completa de los empleados cuya dirección contenga la palabra “RIVADAVIA”.*/
SELECT enombre, elegajo, edireccion
FROM empleados
WHERE empleados.edireccion LIKE '%RIVADAVIA%'; 

/*8. Dar el código y nombre de los productos que sea de tipo “LEGUMBRES” o “LACTEOS” cuyo peso máximo sea inferior a 2,5 kg.*/
SELECT pcod, pnombre, ppeso_maximo
FROM productos
WHERE (productos.ptipo LIKE 'LEGUMBRES' or productos.ptipo LIKE 'LACTEOS') and productos.ppeso_maximo < 2.5;

/*9. Dar el nombre y legajo de los empleados que trabajan en algún área en la cual 
se realice algún producto cuyo peso máximo sea superior a 5 kg.*/
SELECT enombre, trabaja.elegajo
FROM empleados, areas, trabaja, productos
WHERE areas.acod = trabaja.acod and trabaja.elegajo = empleados.elegajo and productos.acod = areas.acod and ppeso_maximo > 5;

/*10. Obtener el legajo y nombre de todos los empleados cuyo nombre empiece con la letra “S” 
y hayan ingresado a la empresa antes del 15/10/2015.*/
SELECT elegajo, enombre 
FROM empleados
WHERE empleados.enombre LIKE 'S%' and CAST(efecha_ing AS DATE) < CAST("2015-10-15" AS DATE) ;

/*11. Obtener un detalle completo de todos los empleados, en el que se muestre: nombre, legajo y ciudad, áreas en las que trabaja 
junto a la fecha de asignación y cantidad de horas asignadas en cada área. 
El listado deberá estar ordenado por la cantidad de horas asignadas.*/
SELECT enombre, empleados.elegajo, eciudad, areas.anombre, tanio_asing, tcant_horas
FROM empleados, areas, trabaja
WHERE trabaja.elegajo = empleados.elegajo and trabaja.acod = areas.acod
ORDER BY tcant_horas;    

/*12. Obtener el nombre de los productos que tengan un peso máximo entre 2 y 7 kilos o que sean de tipo “CARNES”.*/
SELECT pnombre, ppeso_maximo, ptipo
FROM productos    
WHERE (productos.ptipo LIKE '%CARNES%') or (productos.ppeso_maximo > 2 and productos.ppeso_maximo < 7);

/*13. Dar la cantidad total de productos que son fabricados en la empresa.*/
SELECT count(productos.acod)
FROM productos;

/*14. Dar la cantidad de empleados que fabrican alimentos de tipo “LEGUMBRES”.*/
SELECT count(empleados.elegajo)
FROM empleados, productos, trabaja
WHERE trabaja.acod = productos.acod and productos.ptipo LIKE '%LEGUMBRES%';

/*15. Para cada tipo de producto, mostrar la cantidad de productos de ese tipo que son elaborados en la empresa.*/
SELECT ptipo, count(pnombre)
FROM productos
GROUP BY ptipo;

/*16. Dar los tipos de productos que tengan un peso máximo promedio superior a 5 kilos.*/
SELECT ptipo, avg(ppeso_maximo) 
FROM productos
GROUP BY ptipo 
HAVING avg(ppeso_maximo)>4.5;

/*17. Dar nombre, dni y teléfono de los empleados ordenados de mayor a menor según su edad.*/
SELECT enombre, edni, etel
FROM empleados
ORDER BY efecha_nac; 

/*18. Listar nombre y número de legajo de los empleados que trabajen solamente en el área cuyo código es “AAA123”.*/
SELECT enombre, empleados.elegajo
FROM empleados, trabaja
WHERE empleados.elegajo = trabaja.elegajo and acod = 'AAA123' 
EXCEPT
SELECT enombre, empleados.elegajo
FROM empleados, trabaja
WHERE empleados.elegajo = trabaja.elegajo and acod != 'AAA123'

/*19. Listar nombre, dni y teléfono de los empleados junto al nombre del área 
en las que tienen asignadas más de 4 horas de trabajo diarias.*/
SELECT enombre, edni, etel, anombre 
FROM empleados, trabaja, areas
WHERE trabaja.elegajo = empleados.elegajo and areas.acod = trabaja.acod and tcant_horas > 4; 

/*20. Mostrar el legajo y nombre de los empleados que trabajan en más de 2 áreas.*/
SELECT empleados.elegajo, enombre
FROM empleados, trabaja, areas
WHERE empleados.elegajo = trabaja.elegajo and trabaja.acod = areas.acod
GROUP BY trabaja.elegajo 
HAVING count(areas.acod)> 2; 

/*21. Listar nombre y dni de todos los empleados que trabajan tanto en el área con código “AAA147” 
como en el área con código “AAA985”.*/
SELECT enombre, edni
FROM empleados, trabaja
WHERE trabaja.elegajo = empleados.elegajo and (trabaja.acod = 'AAA147' or trabaja.acod = 'AAA985')
GROUP BY edni; 

/*22. Obtener nombre y código de aquellos productos que pertenecen a la misma área que el producto llamado “QUESO FETA”.*/
SELECT pnombre, pcod
FROM productos
WHERE acod = (SELECT acod FROM productos WHERE pnombre = 'QUESO FETA');

/*23. Para cada área, mostrar su nombre junto con la cantidad de productos que produce.
 El listado debe mostrarse ordenado alfabéticamente por nombre de área.*/
 SELECT anombre, count(pnombre)
 FROM areas, productos
 WHERE areas.acod = productos.acod
 GROUP BY areas.anombre
 ORDER BY anombre; 

/*24. Listar nombre y número de legajo de todos los empleados que trabajan en el área con código “AAA789” 
y no trabajan en el área con código “AAA852”. */
SELECT enombre, empleados.elegajo, trabaja.acod 
FROM empleados, trabaja 
WHERE empleados.elegajo = trabaja.elegajo and trabaja.acod = 'AAA789' and trabaja.acod != 'AAA852';

/*25. Listar nombre y fecha de ingreso de todos los empleados que trabajen en áreas que produzcan productos de tipo “CARNES” 
o que el peso máximo del producto sea superior a 5 kilos. El listado debe mostrarse ordenado por nombre de empleado. */
SELECT distinct enombre, efecha_ing
FROM empleados, trabaja, productos
WHERE trabaja.elegajo = empleados.elegajo and trabaja.acod = productos.acod and (ptipo = 'CARNES' or ppeso_maximo > 5)

/*26. Listar la información de todos los empleados, Para aquellos empleados que trabajan 
en algún área dar también el nombre del área, año de ingreso y cantidad de horas asignadas. */

#left join 