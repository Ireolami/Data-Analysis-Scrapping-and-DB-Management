#TRIGGERS IN SQL
#TRIGGERS MEANS TO PERFORM AN OPERATION IF A CERTAIN THING HAPPENED.
#If you are alergic to something, and there is always a reaction that follows that alergy,
#You will notice that such alergy won't show up until you come in contact with that thing you are alergic to
#Immediately you come in contact with it, it triggers the alergy
#So also in SQL, You can write syntax that will trigger if a certain condition is meant
# TRIGGER CAN BE BEFORE AND AFTER, 
#Let's create a database and call it Triggered

DROP TABLE Student_Record;
CREATE DATABASE Triggered;
USE Triggered;

# BEFORE INSERT
CREATE TABLE Student_Record(id int primary key auto_increment, name varchar(40),
age int);

# Let's now create a trigger that will check if the age is less than a condition and set what the value should be

delimiter //

CREATE TRIGGER verify_age BEFORE INSERT ON Student_Record
FOR EACH ROW
BEGIN
    IF new.age > 30 THEN
        SET new.age = 30;
    END IF;
END; //

delimiter ;

INSERT INTO Student_Record(id, name, age)
VALUES (200,'Seun', 22);

INSERT INTO Student_Record(name, age)
VALUES ('Ire', 34), ('Gbenga', 38), ('Ajihun', 43), ('Fouad', 40),
('Kolade', 28), ('Ay', 37), ('Victoria', 48);
SELECT * FROM Student_Record;

#LET'S WORK ON Something more technical
Drop table Car;
Create table IF NOT EXISTS Car(id int primary key, name varchar (30), model varchar (40), production_date date, type_year varchar (40));



DELIMITER //
DROP TRIGGER IF EXISTS Type_verification;
CREATE TRIGGER Type_verification
BEFORE INSERT ON Car
FOR EACH ROW
BEGIN
    IF YEAR(new.production_date) < 2020 THEN
        SET new.type_year = 'Old';
    ELSEIF YEAR(new.production_date) >= 2021 THEN
        SET new.type_year = 'New';
    END IF;
END; //

DELIMITER ;

SELECT * FROM Car;

INSERT INTO Car (id, name, model, production_date)
VALUES(100,'Mercedes Benz', 'GLE', 20210101);

#After Insert
#This triggers when you have already insert into your table
#Let's create a table that have student record, and if the student has paid for his school fee, after insert should
#help us get the information of the student info and put it in a new table
-- Create Student_Info table
DROP TABLE Paid_student;
CREATE TABLE IF NOT EXISTS Student_Info (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40),
    Department VARCHAR(40),
    payment_status VARCHAR(20)
);

-- Create Paid_student table
CREATE TABLE IF NOT EXISTS Paid_student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    name VARCHAR(40),
    Department VARCHAR(40),
    date_paid TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Trigger Pull_paid_student
DELIMITER //

CREATE TRIGGER Pull_paid_student
AFTER INSERT ON Student_Info
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'paid' THEN
        INSERT INTO Paid_student(student_id, name, Department)
        VALUES (NEW.student_id, NEW.name, NEW.Department);
    END IF;
END //

DELIMITER ;



INSERT INTO Student_Info(name,Department, payment_status)
VALUES('Ireola Gbenga', 'Data Analysis', 'unpaid');
SHOW ERRORS;
SELECT * FROM Paid_student;
SELECT * FROM Student_Info;

#BEFORE UPDATE
#Before Update can be written to trigger a code to run if value is updated to certain condition
DROP TABLE Exam_Records;
CREATE TABLE IF NOT EXISTS Exam_Records(id int primary key auto_increment, 
name varchar (50), score int, status varchar (20));
#INSERT INTO THE TABLE

INSERT INTO Exam_Records(name, score, status)
VALUES ('Olayele', 50, 'pending'),('Ireola', 40, 'pending'), ('Seun', 60, 'pending'), ('Victoria', 80, 'pending')

DELIMITER //
CREATE TRIGGER Update_score
BEFORE UPDATE ON Exam_Records
FOR EACH ROW
BEGIN 
	IF new.score >=60 THEN
	SET new.status ='Passed';
    ELSEIF new.score < 60 THEN
    SET new.status ='Failed';
    END IF;
END //
DELIMITER ;

UPDATE Exam_Records SET score = 80 WHERE id =1;

#BEFORE DELETE
#Before Delete means before you delete this information from a certain table, kindly put the information in another table
#Let's create Staff details table 
CREATE TABLE IF NOT EXISTS Staff(sid int primary key auto_increment, name varchar (25), date_joined date,
gender varchar (6), salary int);

INSERT INTO Staff(name, date_joined, gender, salary)
VALUES ('Ibrahim Titilayo', 20180122, 'Female', 2000000), ('Victoria Aderinoyw', 20220122, 'Female', 100000);

CREATE TABLE IF NOT EXISTS Resigned_Staff(id int primary key auto_increment,
sid int, name varchar (25), date_joined date, gender varchar (6), salary int, date_resigned timestamp default now())

#LET'S CREATE TRIGGER FOR THIS

DELIMITER //

CREATE TRIGGER Staff_Resignation
BEFORE DELETE
ON Staff 
FOR EACH ROW
BEGIN
    INSERT INTO Resigned_Staff(sid, name, date_joined, gender, salary)
    VALUES (OLD.sid, OLD.name, OLD.date_joined, OLD.gender, OLD.salary);
END //

DELIMITER ;


DELETE FROM Staff where sid =2;
SELECT * FROM Resigned_Staff;

    


        
        