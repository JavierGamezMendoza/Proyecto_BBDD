use Proyecto_personal;

-- Muestra los datos de todos los empleados que hayan realizado reparaciones a vehiculos Ford 
-- y cuantos vehículos han arreglado en ordern descendente.

SELECT e.cod_empleado, e.nombre, e.apellido1, COUNT(v.marca)  as VEH_REPARADOS FROM EMPLEADO e
INNER JOIN REPARACION r ON r.cod_empleado = e.cod_empleado 
INNER JOIN VEHICULO v  ON r.num_bastidor  = v.num_bastidor 
WHERE v.marca = "Ford"
GROUP BY e.cod_empleado
ORDER BY VEH_REPARADOS DESC;

-- Muestra los datos de los vehiculos y cuantas piezas han sido compradas para cada uno de ellos.

SELECT v.num_bastidor, v.marca, v.modelo, COUNT(p.nombre) FROM VEHICULO v
INNER JOIN REPARACION r on v.num_bastidor = r.num_bastidor 
INNER JOIN SOLICITA s on s.cod_reparacion = r.cod_reparacion 
INNER JOIN PIEZA p on p.cod_pieza = s.cod_pieza 
GROUP BY v.num_bastidor; 

-- Muestra la media de precios de reparacion de los vehiculos por marca

SELECT v.marca, ROUND(AVG(r.precio), 2) AS precio_promedio 
FROM VEHICULO v 
INNER JOIN REPARACION r ON v.num_bastidor = r.num_bastidor 
GROUP BY v.marca;

-- Muestra el numero de piezas solicitadas por cada cliente en un rango de fechas determinado

SELECT c.nombre, COUNT(s.cod_pieza) AS numero_piezas 
FROM CLIENTE c 
INNER JOIN VEHICULO v ON c.cod_cliente = v.cod_cliente 
INNER JOIN REPARACION r ON v.num_bastidor = r.num_bastidor 
INNER JOIN SOLICITA s ON r.cod_reparacion = s.cod_reparacion 
WHERE s.fecha_encargo BETWEEN '2022-01-01' AND '2022-12-31' 
GROUP BY c.nombre

-- Muestra el numero de reclamaciones abiertas por cada cliente (solo si supera 0).

SELECT c.nombre, COUNT(rc.cod_reparacion) AS num_reclamaciones_pendientes 
FROM CLIENTE c 
RIGHT JOIN RECLAMA rc ON c.cod_cliente = rc.cod_cliente AND rc.estado = 'pendiente' 
GROUP BY c.nombre


-- Vista que muestra el precio promedio de lo vehiculos por marca.

CREATE VIEW precio_promedio_reparaciones AS 
SELECT v.marca, ROUND(AVG(r.precio), 2) AS precio_promedio 
FROM VEHICULO v 
INNER JOIN REPARACION r ON v.num_bastidor = r.num_bastidor 
GROUP BY v.marca;

-- Vista que muestra el número de vehiculos reparados atendiendo a una marca especificada.

CREATE VIEW vehiculos_por_empleado AS 
SELECT e.cod_empleado, e.nombre, e.apellido1, COUNT(v.marca)  as VEH_REPARADOS FROM EMPLEADO e
INNER JOIN REPARACION r ON r.cod_empleado = e.cod_empleado 
INNER JOIN VEHICULO v  ON r.num_bastidor  = v.num_bastidor 
WHERE v.marca = "Ford"
GROUP BY e.cod_empleado
ORDER BY VEH_REPARADOS DESC;



-- funcion 1: Devuelve el precio promedio de las reparaciones por marcas.
SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION precio_promedio_reparaciones_marca(marca_vehiculo VARCHAR(50)) 
RETURNS DECIMAL(10,2)
BEGIN
  DECLARE precio DECIMAL(10,2);
  SELECT AVG(r.precio) INTO precio 
  FROM VEHICULO v 
  INNER JOIN REPARACION r ON v.num_bastidor = r.num_bastidor 
  WHERE v.marca = marca_vehiculo;
  RETURN precio;
END; $$
DELIMITER ;
SELECT precio_promedio_reparaciones_marca("Ford");

-- Funcion 2: Devuelve el numero de piezas que vende un proveedor
DELIMITER $$
CREATE FUNCTION num_piezas_proveedor(cod_prov INT) 
RETURNS INT
BEGIN
  DECLARE num_piezas INT;
  SELECT COUNT(*) INTO num_piezas 
  FROM PIEZA 
  WHERE cod_proveedor = cod_prov;
  RETURN num_piezas;
END;$$
DELIMITER ;

SELECT num_piezas_proveedor(243);


-- Procedimiento 1: Actualiza el precio de la pieza con el codigo especificado.
DELIMITER $$
CREATE PROCEDURE actualizar_precio_pieza(cod_pza INT, nuevo_precio DECIMAL(10,2))
BEGIN
  UPDATE PIEZA 
  SET precio = nuevo_precio 
  WHERE cod_pieza = cod_pza;
END;$$
DELIMITER ;

CALL actualizar_precio_pieza(1, 5.2);


-- Procedimiento 2:
DELIMITER $$
CREATE PROCEDURE mostrar_precio_promedio_reparaciones_marca(marca_vehiculo VARCHAR(50))
BEGIN
  DECLARE precio DECIMAL(10,2);
  SET precio = precio_promedio_reparaciones_marca(marca_vehiculo);
  SELECT CONCAT('El precio promedio de las reparaciones para la marca de vehículo ', marca_vehiculo, ' es: ', precio) AS mensaje;
END;$$
DELIMITER ;

CALL mostrar_precio_promedio_reparaciones_marca ("Toyota");


-- Procedimiento 3 (cursor): Muestra la informacion de todas las piezas de un proveedor.
DELIMITER $$
CREATE PROCEDURE mostrar_piezas_proveedor(IN cod_prov INT)
BEGIN
  DECLARE pieza_nombre VARCHAR(50);
  DECLARE pieza_precio DECIMAL(10,2);
  DECLARE done INT DEFAULT FALSE;
  DECLARE cur CURSOR FOR SELECT nombre, precio FROM PIEZA WHERE cod_proveedor = cod_prov;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN cur;
  
  read_loop: LOOP
    FETCH cur INTO pieza_nombre, pieza_precio;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SELECT CONCAT('Pieza: ', pieza_nombre, ' | Precio: ', pieza_precio) AS mensaje;
  END LOOP;
  
  CLOSE cur;
END;$$
DELIMITER ;

CALL mostrar_piezas_proveedor(260);


-- Trigger 1: Muestra mensaje al borrar proveedor
DELIMITER $$
CREATE TRIGGER actualizar_precio_piezas_proveedor
BEFORE DELETE ON PROVEEDOR
FOR EACH ROW
BEGIN
  UPDATE PIEZA
  SET precio = 0
  WHERE cod_proveedor = OLD.cod_proveedor;
END;
DELIMITER ;
