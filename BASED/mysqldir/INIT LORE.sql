-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LAP_SDO_WORKBENCH
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LAP_SDO_WORKBENCH
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LAP_SDO_WORKBENCH` DEFAULT CHARACTER SET utf8 ;
USE `LAP_SDO_WORKBENCH` ;

-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`Students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`Students` (
  `id_student` INT NOT NULL AUTO_INCREMENT,
  `name_student` VARCHAR(50) NOT NULL,
  `pass_student` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id_student`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`Courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`Courses` (
  `id_course` INT NOT NULL AUTO_INCREMENT,
  `name_course` VARCHAR(50) NOT NULL,
  `passingScore_course` INT NOT NULL,
  PRIMARY KEY (`id_course`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`Subjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`Subjects` (
  `id_subject` INT NOT NULL AUTO_INCREMENT,
  `name_subject` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_subject`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`CourseToSubjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`CourseToSubjects` (
  `id_course` INT NOT NULL,
  `id_subject` INT NOT NULL,
  `passingScore_subject` INT NOT NULL,
  PRIMARY KEY (`id_course`, `id_subject`),
  INDEX `fk_CourseToSubjects_Subjects1_idx` (`id_subject` ASC) VISIBLE,
  CONSTRAINT `fk_CourseToSubjects_Courses`
    FOREIGN KEY (`id_course`)
    REFERENCES `LAP_SDO_WORKBENCH`.`Courses` (`id_course`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CourseToSubjects_Subjects1`
    FOREIGN KEY (`id_subject`)
    REFERENCES `LAP_SDO_WORKBENCH`.`Subjects` (`id_subject`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`Tasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`Tasks` (
  `id_task` INT NOT NULL AUTO_INCREMENT,
  `name_task` VARCHAR(50) NOT NULL,
  `text_task` VARCHAR(500) NOT NULL,
  `score_task` INT NOT NULL,
  PRIMARY KEY (`id_task`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`SubjectToTasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`SubjectToTasks` (
  `id_subject` INT NOT NULL,
  `id_task` INT NOT NULL,
  `deadline_task` DATETIME NOT NULL,
  PRIMARY KEY (`id_subject`, `id_task`),
  INDEX `fk_SubjectToTasks_Tasks1_idx` (`id_task` ASC) VISIBLE,
  CONSTRAINT `fk_SubjectToTasks_Subjects1`
    FOREIGN KEY (`id_subject`)
    REFERENCES `LAP_SDO_WORKBENCH`.`Subjects` (`id_subject`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SubjectToTasks_Tasks1`
    FOREIGN KEY (`id_task`)
    REFERENCES `LAP_SDO_WORKBENCH`.`Tasks` (`id_task`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`Answers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`Answers` (
  `id_task` INT NOT NULL,
  `id_student` INT NOT NULL,
  `attempt_answer` INT NOT NULL,
  `date_answer` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `text_answer` VARCHAR(500) NULL DEFAULT NULL,
  `score_answer` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_task`, `id_student`, `attempt_answer`),
  INDEX `fk_Answers_Students1_idx` (`id_student` ASC) VISIBLE,
  INDEX `fk_Answers_Tasks1_idx` (`id_task` ASC) VISIBLE,
  CONSTRAINT `fk_Answers_Students1`
    FOREIGN KEY (`id_student`)
    REFERENCES `LAP_SDO_WORKBENCH`.`Students` (`id_student`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Answers_Tasks1`
    FOREIGN KEY (`id_task`)
    REFERENCES `LAP_SDO_WORKBENCH`.`Tasks` (`id_task`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`Teachers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`Teachers` (
  `id_teacher` INT NOT NULL AUTO_INCREMENT,
  `name_teacher` VARCHAR(50) NOT NULL,
  `pass_teacher` VARCHAR(10) NOT NULL,
  `id_course` INT NOT NULL,
  PRIMARY KEY (`id_teacher`),
  CONSTRAINT `fk_Teachers_Courses1`
    FOREIGN KEY (`id_course`)
    REFERENCES `LAP_SDO_WORKBENCH`.`Courses` (`id_course`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `LAP_SDO_WORKBENCH`.`Admins`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LAP_SDO_WORKBENCH`.`Admins` (
  `id_admin` INT NOT NULL AUTO_INCREMENT,
  `name_admin` VARCHAR(50) NOT NULL,
  `pass_admin` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id_admin`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

USE LAP_SDO_WORKBENCH;

ALTER TABLE Students ADD CONSTRAINT valid_pass1 CHECK(LENGTH(pass_student) > 9);

ALTER TABLE Students DROP COLUMN name_student;
ALTER TABLE Students ADD name_student VARCHAR(50) NOT NULL CHECK(name_student RLIKE '^[А-Я].* [А-Я].* [А-Я].*') AFTER id_student;

ALTER TABLE Students ADD CONSTRAINT valid_all1 CHECK((LENGTH(pass_student) NOT BETWEEN 0 AND 9) AND (LENGTH(name_student) NOT BETWEEN 0 AND 4));

ALTER TABLE Teachers ADD CONSTRAINT valid_pass2 CHECK(LENGTH(pass_teacher) > 9);

ALTER TABLE Teachers DROP COLUMN name_teacher;
ALTER TABLE Teachers ADD name_teacher VARCHAR(50) NOT NULL CHECK(name_teacher RLIKE '^[А-Я].* [А-Я].* [А-Я].*') AFTER id_teacher;

ALTER TABLE Teachers ADD CONSTRAINT valid_all2 CHECK((LENGTH(pass_teacher) NOT BETWEEN 0 AND 9) AND (LENGTH(name_teacher) NOT BETWEEN 0 AND 4));

ALTER TABLE Admins ADD CONSTRAINT valid_pass3 CHECK(LENGTH(pass_admin) > 9);

ALTER TABLE Admins DROP COLUMN name_admin;
ALTER TABLE Admins ADD name_admin VARCHAR(50) NOT NULL CHECK(name_admin RLIKE '^[А-Я].* [А-Я].* [А-Я].*') AFTER id_admin;

ALTER TABLE Admins ADD CONSTRAINT valid_all3 CHECK((LENGTH(pass_admin) NOT BETWEEN 0 AND 9) AND (LENGTH(name_admin) NOT BETWEEN 0 AND 4));

ALTER TABLE Courses ADD CONSTRAINT un_name1 UNIQUE(name_course);
ALTER TABLE Students ADD CONSTRAINT un_name2 UNIQUE(name_student);
ALTER TABLE Teachers ADD CONSTRAINT un_name3 UNIQUE(name_teacher);
ALTER TABLE Admins ADD CONSTRAINT un_name4 UNIQUE(name_admin);

ALTER TABLE Courses CONVERT TO CHARACTER SET utf8mb4;
ALTER TABLE Students CONVERT TO CHARACTER SET utf8mb4;
ALTER TABLE Teachers CONVERT TO CHARACTER SET utf8mb4;
ALTER TABLE Admins CONVERT TO CHARACTER SET utf8mb4;

DELIMITER //
CREATE FUNCTION getStudentID(name_student_ VARCHAR(50), pass_student_ VARCHAR(10)) 
RETURNS INT 
READS SQL DATA
BEGIN
	DECLARE id INT;
    SELECT id_student INTO id FROM Students WHERE name_student = name_student_ AND pass_student = pass_student_;
    RETURN id;
END
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION getCourseID(name_course_ VARCHAR(50)) 
RETURNS INT 
READS SQL DATA
BEGIN
	DECLARE id INT;
    SELECT id_course INTO id FROM Courses WHERE name_course = name_course_;
    RETURN id;
END
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION getSubjectID(name_subject_ VARCHAR(50)) 
RETURNS INT 
READS SQL DATA
BEGIN
	DECLARE id INT;
    SELECT id_subject INTO id FROM Subjects WHERE name_subject = name_subject_;
    RETURN id;
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ADD_STUDENT(id_course_ INT, name_student_ VARCHAR(50), pass_student_ VARCHAR(10))
BEGIN
	DECLARE cur_task INT;
    DECLARE id INT;
	DECLARE is_end INT DEFAULT 0;
    	DECLARE taskList CURSOR FOR
		SELECT id_task FROM
			(SELECT id_subject FROM CourseToSubjects WHERE CourseToSubjects.id_course = id_course_) AS CS
			JOIN
			(SELECT id_subject, id_task FROM SubjectToTasks) AS ST
			ON CS.id_subject = ST.id_subject;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
	OPEN taskList;
    INSERT INTO Students (name_student, pass_student) VALUES (name_student_, pass_student_);
    SET id = getStudentID(name_student_, pass_student_);
	FETCH taskList INTO cur_task;
    WHILE is_end = 0 DO
		IF cur_task IS NULL THEN
			SET is_end = 1;
		ELSE
            INSERT INTO Answers (id_task, id_student, attempt_answer, score_answer) VALUES (cur_task, id, 0, 0);
            FETCH taskList INTO cur_task;
		END IF;
    END WHILE;
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE INSERT_COURSETOSUBJECTS(id_course_ INT, id_subject_ INT, passingScore_subject_ INT)
BEGIN
	DECLARE is_end INT DEFAULT 0;
    DECLARE C INT;
    DECLARE S INT;
	DECLARE CS CURSOR FOR
    SELECT id_course, id_student FROM
	(
		SELECT DISTINCT id_student, id_course, (COUNT(id_course)) as SubjectsInCourse FROM
		(
			(SELECT DISTINCT id_task, id_student FROM Answers) as TS
			JOIN 
			(SELECT id_subject, id_task FROM SubjectToTasks) as STT
			ON TS.id_task = STT.id_task
			JOIN
			(SELECT id_course, id_subject FROM CourseToSubjects) as CTS
			ON STT.id_subject = CTS.id_subject
		)
		GROUP BY id_student, id_course
		ORDER BY SubjectsInCourse DESC
	)
	AS temp
    WHERE (@i:=@i+1) < ((SELECT COUNT(*) FROM Students) + 1)
	ORDER BY id_student;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end=1;
    OPEN CS;
    FETCH CS INTO C, S;
	INSERT INTO CourseToSubjects (id_course, id_subject, passingScore_subject) VALUES (id_course_, id_subject_, passingScore_subject_);
    WHILE is_end = 0 DO
		IF C IS NULL THEN
			SET is_end = 1;
		ELSE
			IF C = id_course_ THEN
				INSERT INTO Answers (id_task, id_student, attempt_answer, score_answer) SELECT id_task, (SELECT(S)), 0, 0 FROM SubjectToTasks WHERE id_subject = id_subject_;
			END IF;
            FETCH CS INTO C, S;
		END IF;
    END WHILE;
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE INSERT_COURSETOSUBJECTS_WRAP(id_course_ INT, id_subject_ INT, passingScore_subject_ INT)
BEGIN
	SET @i = 0;
    CALL INSERT_COURSETOSUBJECTS(id_course_, id_subject_, passingScore_subject_);
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ADD_COURSE(name_course_ VARCHAR(50), passingScore_course_ INT, name_subject_ VARCHAR(50), passingScore_subject_ INT)
BEGIN
	IF EXISTS (SELECT * FROM Subjects WHERE name_subject = name_subject_) THEN
		SIGNAL SQLSTATE '45000' SET message_text = "Дисциплина не является уникальной и уже есть на другом направлении.";
	END IF;
	INSERT INTO Courses (name_course, passingScore_course) VALUES (name_course_, passingScore_course_);
    INSERT INTO Subjects (name_subject) VALUES (name_subject_);
    INSERT INTO CourseToSubjects (id_course, id_subject, passingScore_subject) VALUES (getCourseID(name_course_), getSubjectID(name_subject_), passingScore_subject_);
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DELETE_COURSE(id_course_ INT)
BEGIN
	DELETE Teachers FROM Teachers JOIN Courses ON Teachers.id_course = Courses.id_course WHERE Teachers.id_course = id_course_;
	SET @i = 0;
	DELETE Students, Answers FROM
	(
		SELECT id_course, id_student FROM
		(
			SELECT DISTINCT id_student, id_course, (COUNT(id_course)) as SubjectsInCourse FROM
			(
				(SELECT DISTINCT id_task, id_student FROM Answers) as TS
				JOIN 
				(SELECT id_subject, id_task FROM SubjectToTasks) as STT
				ON TS.id_task = STT.id_task
				JOIN
				(SELECT id_course, id_subject FROM CourseToSubjects) as CTS
				ON STT.id_subject = CTS.id_subject
			)
			GROUP BY id_student, id_course
			ORDER BY SubjectsInCourse DESC
		)
		AS temp
		WHERE (@i:=@i+1) < ((SELECT COUNT(*) FROM Students) + 1)
		ORDER BY id_student
	) as CS JOIN Students ON CS.id_student = Students.id_student JOIN Answers ON Answers.id_student = Students.id_student WHERE CS.id_course = id_course_;
	DELETE Courses, CourseToSubjects, Subjects, SubjectToTasks, Tasks FROM Courses JOIN CourseToSubjects ON Courses.id_course = CourseToSubjects.id_course JOIN Subjects ON CourseToSubjects.id_subject = Subjects.id_subject JOIN SubjectToTasks ON Subjects.id_subject = SubjectToTasks.id_subject JOIN Tasks ON SubjectToTasks.id_task = Tasks.id_task WHERE Subjects.id_subject IN (SELECT ids FROM (SELECT id_subject AS ids FROM CourseToSubjects GROUP BY id_subject HAVING COUNT(*) = 1) as CTS) AND Courses.id_course = id_course_;
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE COURSE_STUDENT()
BEGIN
	SET @i = 0;
	SELECT id_course, id_student FROM
	(
		SELECT DISTINCT id_student, id_course, (COUNT(id_course)) as SubjectsInCourse FROM
		(
			(SELECT DISTINCT id_task, id_student FROM Answers) as TS
			JOIN 
			(SELECT id_subject, id_task FROM SubjectToTasks) as STT
			ON TS.id_task = STT.id_task
			JOIN
			(SELECT id_course, id_subject FROM CourseToSubjects) as CTS
			ON STT.id_subject = CTS.id_subject
		)
		GROUP BY id_student, id_course
		ORDER BY SubjectsInCourse DESC
	)
	AS temp
	WHERE (@i:=@i+1) < ((SELECT COUNT(*) FROM Students) + 1)
	ORDER BY id_student;
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE COURSE_STUDENT_VERBOSE()
BEGIN
	SET @i = 0;
    SELECT Courses.id_course AS 'Шифр курса', Students.id_student AS 'Шифр студента', Courses.name_course AS 'Название курса', Students.name_student AS 'ФИО студента' FROM
    (
	SELECT id_course, id_student FROM
		(
			SELECT DISTINCT id_student, id_course, (COUNT(id_course)) as SubjectsInCourse FROM
			(
				(SELECT DISTINCT id_task, id_student FROM Answers) as TS
				JOIN 
				(SELECT id_subject, id_task FROM SubjectToTasks) as STT
				ON TS.id_task = STT.id_task
				JOIN
				(SELECT id_course, id_subject FROM CourseToSubjects) as CTS
				ON STT.id_subject = CTS.id_subject
			)
			GROUP BY id_student, id_course
			ORDER BY SubjectsInCourse DESC
		)
		AS temp
		WHERE (@i:=@i+1) < ((SELECT COUNT(*) FROM Students) + 1)
		ORDER BY id_student
    ) AS tmp JOIN Students ON tmp.id_student = Students.id_student JOIN Courses ON tmp.id_course = Courses.id_course ORDER BY Courses.id_course, Students.id_student;
END
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER insertAnswer
	BEFORE INSERT
    ON Answers
    FOR EACH ROW
BEGIN
	IF NOT EXISTS (SELECT * FROM Answers WHERE id_task = NEW.id_task AND id_student = NEW.id_student) AND ((NEW.text_answer IS NOT NULL) OR NEW.attempt_answer != 0) THEN
        SIGNAL SQLSTATE '45000' SET message_text = "No answers exist for this task-student relation. Only a NULL answer can be inserted.";
	END IF;
	IF EXISTS (SELECT * FROM Answers WHERE id_task = NEW.id_task AND id_student = NEW.id_student AND text_answer IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET message_text = "A NULL answer exists for this task-student relation. UPDATE it instead.";
    END IF;
	IF EXISTS (SELECT * FROM Answers WHERE id_task = NEW.id_task AND id_student = NEW.id_student) AND NEW.text_answer IS NULL THEN
		SIGNAL SQLSTATE '45000' SET message_text = "NOT NULL answers exist for this task-student relation. A NULL answer can not be inserted.";
    END IF;
	IF NEW.attempt_answer != (SELECT (MAX(attempt_answer) + 1) FROM Answers WHERE id_task = NEW.id_task AND id_student = NEW.id_student) THEN
		SIGNAL SQLSTATE '45000' SET message_text = "The answer attempt number is not the successor of the current number of attempts.";
    END IF;
END
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER deleteCourse
	BEFORE DELETE
    ON Courses
    FOR EACH ROW
BEGIN

END
//
DELIMITER ;

INSERT INTO Courses (name_course, passingScore_course) VALUES
("Программная инженерия", 4000),
("Прикладная информатика", 3500),
("Прикладная математика", 3000),
("Вычислительная техника", 2500);

INSERT INTO Subjects (name_subject) VALUES
("Программирование"),
("Базы данных"),
("Информатика"),
("Математика"),
("Схемотехника");

INSERT INTO Tasks (name_task, text_task, score_task) VALUES
("Переменные","Как называется целочисленный тип в С++?",1000),
("Функции","Как называется функция точка-входа в C++?",1000),
("Выборка","Какой запрос следует выполнить для получения всей таблицы?",1000),
("Обновление записи","Как называется оператор обновления записи?",1000),
("Системы счисления","Перевести число 16 в двоичную систему.",500),
("IP-Адресация","Узел 192.168.64.117 находится в сети с маской 255.255.255.0. Найти адрес сети.",1500),
("Производная","(x^2)' = ?",500),
("Интеграл","S(2xdx) = ?",1500),
("Базовая логика","Напишите значения функции И для двух переменных в виде двоичного вектора.",500),
("Дешифратор","Сколько выходов имеет полный дешифратор с 4 входами?",1500);

INSERT INTO CourseToSubjects (id_course, id_subject, passingScore_subject) VALUES
(1, 1, 2000),
(2, 1, 1000),
(3, 1, 1000),
(4, 1, 1000),
(1, 2, 2000),
(2, 3, 1500),
(3, 4, 1500),
(4, 5, 1500);

INSERT INTO SubjectToTasks (id_subject, id_task, deadline_task) VALUES
(1, 1, "20221031235959"),
(1, 2, "20221130120000"),
(2, 3, "20221031235959"),
(2, 4, "20221130120000"),
(3, 5, "20221031235959"),
(3, 6, "20221130120000"),
(4, 7, "20221031235959"),
(4, 8, "20221130120000"),
(5, 9, "20221031235959"),
(5, 10, "20221130120000");

CALL ADD_STUDENT(1, "Кулаков Евдоким Игоревич", "tbSuZWgurE");
CALL ADD_STUDENT(1, "Мартынов Дональд Русланович", "xmWKBLl1PR");
CALL ADD_STUDENT(2, "Беляев Святослав Игнатьевич", "oTslx1CbPy");
CALL ADD_STUDENT(2, "Мамонтов Иннокентий Богуславович", "AiPcbEpHok");
CALL ADD_STUDENT(3, "Максимов Нелли Лаврентьевич", "bP92aFgVTd");
CALL ADD_STUDENT(3, "Блинов Егор Олегович", "IAjF5I2GAJ");
CALL ADD_STUDENT(4, "Александров Герасим Викторович", "PGpkaZUv7R");
CALL ADD_STUDENT(4, "Кудрявцев Захар Андреевич", "Ges7DsUwhF");

UPDATE Answers SET attempt_answer = 1, text_answer = "integer", score_answer = 50 WHERE id_task = 1 AND id_student = 1;
UPDATE Answers SET attempt_answer = 1, text_answer = "integer", score_answer = 50 WHERE id_task = 1 AND id_student = 3;
UPDATE Answers SET attempt_answer = 1, text_answer = "integer", score_answer = 50 WHERE id_task = 1 AND id_student = 5;
UPDATE Answers SET attempt_answer = 1, text_answer = "integer", score_answer = 50 WHERE id_task = 1 AND id_student = 7;
UPDATE Answers SET attempt_answer = 1, text_answer = "enter", score_answer = 0 WHERE id_task = 2 AND id_student = 1;
UPDATE Answers SET attempt_answer = 1, text_answer = "enter", score_answer = 0 WHERE id_task = 2 AND id_student = 3;
UPDATE Answers SET attempt_answer = 1, text_answer = "enter", score_answer = 0 WHERE id_task = 2 AND id_student = 5;
UPDATE Answers SET attempt_answer = 1, text_answer = "enter", score_answer = 0 WHERE id_task = 2 AND id_student = 7;
UPDATE Answers SET attempt_answer = 1, text_answer = "select all", score_answer = 250 WHERE id_task = 3 AND id_student = 1;
UPDATE Answers SET attempt_answer = 1, text_answer = "renew", score_answer = 0 WHERE id_task = 4 AND id_student = 1;
UPDATE Answers SET attempt_answer = 1, text_answer = "100", score_answer = 50 WHERE id_task = 5 AND id_student = 3;
UPDATE Answers SET attempt_answer = 1, text_answer = "192.168.64.255", score_answer = 500 WHERE id_task = 6 AND id_student = 3;
UPDATE Answers SET attempt_answer = 1, text_answer = "x", score_answer = 25 WHERE id_task = 7 AND id_student = 5;
UPDATE Answers SET attempt_answer = 1, text_answer = "2x^2", score_answer = 500 WHERE id_task = 8 AND id_student = 5;
UPDATE Answers SET attempt_answer = 1, text_answer = "1000", score_answer = 0 WHERE id_task = 9 AND id_student = 7;
UPDATE Answers SET attempt_answer = 1, text_answer = "8", score_answer = 50 WHERE id_task = 10 AND id_student = 7;

INSERT INTO Answers (id_task, id_student, attempt_answer, text_answer, score_answer) VALUES
(1, 1, 2, "int", 1000),
(2, 1, 2, "main", 1000),
(1, 3, 2, "int", 1000),
(2, 3, 2, "main", 1000),
(1, 5, 2, "int", 1000),
(2, 5, 2, "main", 1000),
(1, 7, 2, "int", 1000),
(2, 7, 2, "main", 1000),
(3, 1, 2, "select *", 1000),
(4, 1, 2, "update", 1000),
(5, 3, 2, "1000", 500),
(6, 3, 2, "192.168.64.0", 1500),
(7, 5, 2, "2x", 500),
(8, 5, 2, "x^2", 1500),
(9, 7, 2, "0001", 500),
(10, 7, 2, "16", 1500);