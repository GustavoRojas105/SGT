-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema SGT
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema SGT
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `SGT` DEFAULT CHARACTER SET utf8 ;
USE `SGT` ;

-- -----------------------------------------------------
-- Table `mydb`.`Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SGT`.`Clientes` (
  `CL_CVE` INT NOT NULL,
  `CL_TYPE` ENUM('DOMICILIO', 'MESA', 'PERSONA') NULL DEFAULT 'MESA',
  `MESA` INT NULL,
  `CL_NOMBRE` VARCHAR(45) NULL,
  `CL_APELLIDOS` VARCHAR(45) NULL,
  `CL_DIRECCION` VARCHAR(45) NULL,
  `CL_LONGITUD` VARCHAR(45) NULL,
  `CL_LATITUD` VARCHAR(45) NULL,
  PRIMARY KEY (`CL_CVE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SGT`.`Pedido` (
  `PE_CVE` INT NOT NULL,
  `PE_CVE_SUB` INT NOT NULL,
  `PE_CL_CVE` INT NOT NULL,
  `PE_HRS` DATETIME NULL,
  PRIMARY KEY (`PE_CVE`, `PE_CVE_SUB`, `PE_CL_CVE`),
  INDEX `fk_Pedido_Clientes1_idx` (`PE_CL_CVE` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Clientes1`
    FOREIGN KEY (`PE_CL_CVE`)
    REFERENCES `mydb`.`Clientes` (`CL_CVE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SGT`.`Producto` (
  `PRD_CVE` INT NOT NULL,
  `PRD_NOMBRE` VARCHAR(45) NULL,
  `PRD_DISPONIBILIDAD` CHAR(1) NULL DEFAULT '1',
  PRIMARY KEY (`PRD_CVE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ingrediente Primario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SGT`.`Ingrediente Primario` (
  `ING_PRIM_CVE` INT NOT NULL,
  `ING_PRIM_NOMBRE` VARCHAR(45) NULL,
  `ING_PRIM_DISPONIBILIDAD` CHAR(1) NULL DEFAULT '1',
  PRIMARY KEY (`ING_PRIM_CVE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Base`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SGT`.`Base` (
  `BA_PRD_CVE` INT NOT NULL,
  `BA_ING_PRIM_CVE` INT NOT NULL,
  PRIMARY KEY (`BA_PRD_CVE`, `BA_ING_PRIM_CVE`),
  INDEX `fk_Producto_has_Ingrediente_Producto_idx` (`BA_PRD_CVE` ASC) VISIBLE,
  INDEX `fk_Receta_Ingrediente1_idx` (`BA_ING_PRIM_CVE` ASC) VISIBLE,
  CONSTRAINT `fk_Producto_has_Ingrediente_Producto`
    FOREIGN KEY (`BA_PRD_CVE`)
    REFERENCES `SGT`.`Producto` (`PRD_CVE`),
  CONSTRAINT `fk_Receta_Ingrediente1`
    FOREIGN KEY (`BA_ING_PRIM_CVE`)
    REFERENCES `SGT`.`Ingrediente Primario` (`ING_PRIM_CVE`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Orden`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SGT`.`Orden` (
  `OR_CVE` INT NOT NULL,
  `OR_BA_PRD_CVE` INT NOT NULL,
  `OR_BA_ING_PRIM_CVE` INT NOT NULL,
  `OR_PE_CVE` INT NOT NULL,
  `OR_PE_CVE_SUB` INT NOT NULL,
  `OR_QTY` INT NULL,
  PRIMARY KEY (`OR_CVE`, `OR_BA_PRD_CVE`, `OR_BA_ING_PRIM_CVE`, `OR_PE_CVE`, `OR_PE_CVE_SUB`),
  INDEX `fk_Orden_Base1_idx` (`OR_BA_PRD_CVE` ASC, `OR_BA_ING_PRIM_CVE` ASC) VISIBLE,
  INDEX `fk_Orden_Pedido1_idx` (`OR_PE_CVE` ASC, `OR_PE_CVE_SUB` ASC) VISIBLE,
  CONSTRAINT `fk_Orden_Base1`
    FOREIGN KEY (`OR_BA_PRD_CVE` , `OR_BA_ING_PRIM_CVE`)
    REFERENCES `SGT`.`Base` (`BA_PRD_CVE` , `BA_ING_PRIM_CVE`),
  CONSTRAINT `fk_Orden_Pedido1`
    FOREIGN KEY (`OR_PE_CVE` , `OR_PE_CVE_SUB`)
    REFERENCES `SGT`.`Pedido` (`PE_CVE` , `PE_CVE_SUB`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ingrediente Secundario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SGT`.`Ingrediente Secundario` (
  `ING_SEG_CVE` INT NOT NULL,
  `ING_SEG_NOMBRE` VARCHAR(45) NULL,
  `ING_SEG_DISPONIBILIDAD` CHAR(1) NULL DEFAULT '1',
  PRIMARY KEY (`ING_SEG_CVE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Receta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Receta` (
  `RE_PRD_CVE` INT NOT NULL,
  `RE_ING_PRIM_CVE` INT NOT NULL,
  `RE_ING_SEG_CVE` INT NOT NULL,
  `RE_ING_SEC_DISP` CHAR(1) NULL DEFAULT '1',
  PRIMARY KEY (`RE_PRD_CVE`, `RE_ING_PRIM_CVE`, `RE_ING_SEG_CVE`),
  INDEX `fk_Receta_has_Ingrediente Secundario_Ingrediente Secundario_idx` (`RE_ING_SEG_CVE` ASC) VISIBLE,
  INDEX `fk_Receta_has_Ingrediente Secundario_Receta1_idx` (`RE_PRD_CVE` ASC, `RE_ING_PRIM_CVE` ASC) VISIBLE,
  CONSTRAINT `fk_Receta_has_Ingrediente Secundario_Receta1`
    FOREIGN KEY (`RE_PRD_CVE` , `RE_ING_PRIM_CVE`)
    REFERENCES `SGT`.`Base` (`BA_PRD_CVE` , `BA_ING_PRIM_CVE`),
  CONSTRAINT `fk_Receta_has_Ingrediente Secundario_Ingrediente Secundario1`
    FOREIGN KEY (`RE_ING_SEG_CVE`)
    REFERENCES `SGT`.`Ingrediente Secundario` (`ING_SEG_CVE`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
