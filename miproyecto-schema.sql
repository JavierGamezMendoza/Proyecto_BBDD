CREATE DATABASE `Proyecto_personal` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `CLIENTE` (
  `cod_cliente` int NOT NULL AUTO_INCREMENT,
  `DNI` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido1` varchar(100) NOT NULL,
  `apellido2` varchar(100) NOT NULL,
  PRIMARY KEY (`cod_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=502 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `EMPLEADO` (
  `cod_empleado` int NOT NULL AUTO_INCREMENT,
  `DNI` varchar(100) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido1` varchar(100) DEFAULT NULL,
  `apellido2` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`cod_empleado`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `PIEZA` (
  `cod_pieza` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `precio` int DEFAULT NULL,
  `cod_proveedor` int DEFAULT NULL,
  PRIMARY KEY (`cod_pieza`),
  KEY `PIEZA_FK1` (`cod_proveedor`),
  CONSTRAINT `PIEZA_FK` FOREIGN KEY (`cod_proveedor`) REFERENCES `PROVEEDOR` (`cod_proveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `PROVEEDOR` (
  `cod_proveedor` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `localizacion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`cod_proveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `RECLAMA` (
  `cod_cliente` int NOT NULL,
  `cod_reparacion` int NOT NULL,
  `fecha_reclamacion` datetime NOT NULL,
  `descripcion` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `estado` varchar(30) NOT NULL,
  PRIMARY KEY (`cod_cliente`,`cod_reparacion`),
  KEY `RECLAMA_FK` (`cod_reparacion`),
  CONSTRAINT `RECLAMA_FK` FOREIGN KEY (`cod_reparacion`) REFERENCES `REPARACION` (`cod_reparacion`),
  CONSTRAINT `RECLAMA_FK_1` FOREIGN KEY (`cod_cliente`) REFERENCES `CLIENTE` (`cod_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `REPARACION` (
  `cod_reparacion` int NOT NULL AUTO_INCREMENT,
  `num_bastidor` int NOT NULL,
  `cod_empleado` int NOT NULL,
  `fecha_entrada` date NOT NULL,
  `fecha_salida` date DEFAULT NULL,
  `descripcion` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `precio` double NOT NULL,
  PRIMARY KEY (`cod_reparacion`),
  KEY `REPARACION_FK` (`num_bastidor`),
  KEY `REPARACION_FK_1` (`cod_empleado`),
  CONSTRAINT `REPARACION_FK` FOREIGN KEY (`num_bastidor`) REFERENCES `VEHICULO` (`num_bastidor`),
  CONSTRAINT `REPARACION_FK_1` FOREIGN KEY (`cod_empleado`) REFERENCES `EMPLEADO` (`cod_empleado`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `SOLICITA` (
  `fecha_encargo` date NOT NULL,
  `numero` int NOT NULL,
  `cod_pieza` int NOT NULL,
  `cod_reparacion` int NOT NULL,
  PRIMARY KEY (`cod_pieza`,`cod_reparacion`),
  KEY `SOLICITA_FK` (`cod_reparacion`),
  CONSTRAINT `SOLICITA_FK` FOREIGN KEY (`cod_reparacion`) REFERENCES `REPARACION` (`cod_reparacion`),
  CONSTRAINT `SOLICITA_FK_1` FOREIGN KEY (`cod_pieza`) REFERENCES `PIEZA` (`cod_pieza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `VEHICULO` (
  `num_bastidor` int NOT NULL,
  `matricula` varchar(100) DEFAULT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `modelo` varchar(100) DEFAULT NULL,
  `motor` varchar(100) DEFAULT NULL,
  `plazas` varchar(100) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `tipo_bateria` varchar(100) DEFAULT NULL,
  `tiempo_carga` varchar(100) DEFAULT NULL,
  `tipo_combustible` varchar(100) DEFAULT NULL,
  `capacidad` varchar(100) DEFAULT NULL,
  `cod_cliente` int NOT NULL,
  PRIMARY KEY (`num_bastidor`),
  KEY `VEHICULO_FK` (`cod_cliente`),
  CONSTRAINT `VEHICULO_FK` FOREIGN KEY (`cod_cliente`) REFERENCES `CLIENTE` (`cod_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

