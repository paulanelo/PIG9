-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pig9
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pig9
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pig9` DEFAULT CHARACTER SET utf8 ;
USE `pig9` ;

-- -----------------------------------------------------
-- Table `pig9`.`categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pig9`.`categorias` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `createdAt` DATE NOT NULL,
  `updatedAt` DATE NOT NULL,
  `createdBy` VARCHAR(150) NOT NULL,
  `updatedBy` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pig9`.`dicasgerais`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pig9`.`dicasgerais` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dicaPerfil` VARCHAR(150) NOT NULL,
  `dicaUsuario` VARCHAR(150) NOT NULL,
  `createdAt` DATE NOT NULL,
  `updatedAt` DATE NOT NULL,
  `createdBy` VARCHAR(150) NOT NULL,
  `updatedBy` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pig9`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pig9`.`usuarios` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `nomeCompleto` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `dataNasc` DATE NOT NULL,
  `tipoPerfil` ENUM('CONSERVADOR', 'MODERADO', 'ARROJADO') NOT NULL,
  `hashSenha` VARCHAR(60) NOT NULL,
  `createdAt` DATE NOT NULL,
  `updatedAt` DATE NOT NULL,
  `createdBy` VARCHAR(150) NOT NULL,
  `updatedBy` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `hash_senha_UNIQUE` (`hashSenha` ASC) VISIBLE,
  UNIQUE INDEX `perfil_UNIQUE` (`tipoPerfil` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pig9`.`dicasperfil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pig9`.`dicasperfil` (
  `idUsuarios_fk` BIGINT NOT NULL,
  `idDicasGerais_fk` INT NOT NULL,
  PRIMARY KEY (`idDicasGerais_fk`),
  INDEX `fk_dicas_perfil_usuarios1_idx` (`idUsuarios_fk` ASC) VISIBLE,
  CONSTRAINT `fk_dicas_perfil_dicas_gerais1`
    FOREIGN KEY (`idDicasGerais_fk`)
    REFERENCES `pig9`.`dicasgerais` (`id`),
  CONSTRAINT `fk_dicas_perfil_usuarios1`
    FOREIGN KEY (`idUsuarios_fk`)
    REFERENCES `pig9`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pig9`.`dicasusuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pig9`.`dicasusuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `saldo` DECIMAL(10,0) NOT NULL,
  `dica` VARCHAR(300) NOT NULL,
  `idUsuarios_fk` BIGINT NOT NULL,
  `idDicasGerais_fk` INT NOT NULL,
  `createdAt` DATE NOT NULL,
  `updatedAt` DATE NOT NULL,
  `createdBy` VARCHAR(150) NOT NULL,
  `updatedBy` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`, `idDicasGerais_fk`),
  INDEX `fk_dicas_usuario_usuarios1_idx` (`idUsuarios_fk` ASC) VISIBLE,
  INDEX `fk_dicas_usuario_dicas_gerais1_idx` (`idDicasGerais_fk` ASC) VISIBLE,
  CONSTRAINT `fk_dicas_usuario_dicas_gerais1`
    FOREIGN KEY (`idDicasGerais_fk`)
    REFERENCES `pig9`.`dicasgerais` (`id`),
  CONSTRAINT `fk_dicas_usuario_usuarios1`
    FOREIGN KEY (`idUsuarios_fk`)
    REFERENCES `pig9`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pig9`.`moedas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pig9`.`moedas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `cifra` VARCHAR(3) NOT NULL,
  `createdAt` DATE NOT NULL,
  `updatedAt` DATE NOT NULL,
  `createdBy` VARCHAR(150) NOT NULL,
  `updatedBy` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC) VISIBLE,
  UNIQUE INDEX `cifra_UNIQUE` (`cifra` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pig9`.`lancamentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pig9`.`lancamentos` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(50) NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `dataPagto` DATE NOT NULL,
  `observacao` VARCHAR(200) NULL DEFAULT NULL,
  `tipoLancamento` ENUM('RECEITA', 'DESPESA') NOT NULL,
  `banco` VARCHAR(45) NULL DEFAULT NULL,
  `idUsuarios_fk` BIGINT NOT NULL DEFAULT '0',
  `idMoedas_fk` INT NOT NULL,
  `idCategorias_fk` INT NOT NULL,
  `createdAt` DATE NOT NULL,
  `updatedAt` DATE NOT NULL,
  `updatedBy` VARCHAR(150) NOT NULL,
  `createdBy` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_lancamentos_usuarios_idx` (`idUsuarios_fk` ASC) VISIBLE,
  INDEX `fk_lancamentos_moedas2_idx` (`idMoedas_fk` ASC) VISIBLE,
  INDEX `fk_lancamentos_categorias2_idx` (`idCategorias_fk` ASC) VISIBLE,
  CONSTRAINT `fk_lancamentos_categorias2`
    FOREIGN KEY (`idCategorias_fk`)
    REFERENCES `pig9`.`categorias` (`id`),
  CONSTRAINT `fk_lancamentos_moedas2`
    FOREIGN KEY (`idMoedas_fk`)
    REFERENCES `pig9`.`moedas` (`id`),
  CONSTRAINT `fk_lancamentos_usuarios`
    FOREIGN KEY (`idUsuarios_fk`)
    REFERENCES `pig9`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
