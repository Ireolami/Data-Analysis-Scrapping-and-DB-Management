#STORED PROCEDURE
-- Stored procedure is line of syntax created to help you perform certain operation when the procedure is called
-- Let's assume that we want a procedure that selects some information from a table anytime it is called.

USE ANOTHER;
SHOW TABLES;
SELECT * FROM STAFF;
-- LET'S CREATE A PROCEDURE THAT SELECTS NAME, AGE, DEPARTMENT AND SALARY FROM TABLE STAFF
DROP PROCEDURE Sub_querry;
DELIMITER $$

CREATE PROCEDURE staff_selection()
BEGIN 

	SELECT Name, Age, Department, Salary FROM staff;
END$$
DELIMITER ;

-- IRRESPECTIVE OF ANYTIME WE WANT TO USE IT, WE CAN ALWAYS CALL ON IT. THIS IS THE SAME AS OUR FUNCTION IN PYTHON
CALL staff_selection()

# WE CAN ALSO HAVE PARAMETERIZED PROCEDURE
DELIMITER $$
CREATE PROCEDURE Parameterized(Age int)
BEGIN
	SELECT Name, Age, Department, Salary FROM staff WHERE staff.Age =Age;
END$$
DELIMITER ;

CALL Parameterized(38);

#HOW ABOUT WE CREATE MULITIPLE PARAMETER PROCEDURE
DELIMITER $$
CREATE PROCEDURE Multiple(IN Department VARCHAR(255), Age int)
BEGIN
	SELECT * FROM staff WHERE staff.Department=Department and staff.Age=Age;
END$$
DELIMITER ;


CALL Multiple('UI/UX', '20');

CALL Multiple('UI/UX', 20);

-- LET'S CREATE A PROCEDURE THAT INSERT INTO OUR TABLE
DELIMITER $$
CREATE PROCEDURE InsertData(IN Name VARCHAR(255), Age int, Department VARCHAR(255), Gender VARCHAR(6), Salary int)
BEGIN
	INSERT INTO staff(Name, Age, Department, Gender, Salary) Values(Name, Age, Department, Gender, Salary);
END$$
DELIMITER ;

-- LET'S CALL IT 
CALL InsertData('Fouad Ola', 29, 'Data Science', 'Male', 120000);
CALL InsertData('Faith Chioma', 29, 'AI', 'Female', 100000);
CALL staff_selection();
select * from staff;

-- LET'S CREATE PROCEDURE THAT PERFORMS SUBQUERRY FUNCTION

DELIMITER $$
CREATE PROCEDURE Sub_querry()
BEGIN
	SELECT * FROM staff WHERE Age = 
		(SELECT MAX(Age) FROM staff);
END$$
DELIMITER ;

CALL Sub_querry();

-- LET'S TRY WITH GROUPBY AND HAVING

DELIMITER $$
CREATE PROCEDURE GetAverageAgeByDepartmen()
BEGIN
    SELECT Department, Round(AVG(Age), 1) AS AvgAge
    FROM staff
    GROUP BY Department;
END$$
DELIMITER ;
DROP PROCEDURE GetAverageAgeByDepartment;
CALL GetAverageAgeByDepartmen();
#################################
DELIMITER $$
CREATE PROCEDURE GetOlderThanAverageAge()
BEGIN
    SELECT *
    FROM staff
    WHERE Age > (SELECT AVG(Age) FROM staff);
END$$
DELIMITER ;

CALL GetOlderThanAverageAge();
####################################
DELIMITER $$
CREATE PROCEDURE GetDepartmentsWithEmployeeCoun()
BEGIN
    SELECT Department, COUNT(*) AS EmployeeCount
    FROM (SELECT  Department FROM staff) AS UniqueDepartments
    GROUP BY Department;
END$$
DELIMITER ;

CALL GetDepartmentsWithEmployeeCount();

DELIMITER $$
CREATE PROCEDURE GetDepartmentsWithMoreThanTwoEmployees()
BEGIN
    SELECT Department, COUNT(*) AS EmployeeCount
    FROM staff
    GROUP BY Department
    HAVING EmployeeCount > 2;
END$$
DELIMITER ;

CALL GetDepartmentsWithMoreThanTwoEmployees();

-- THE PREVIOUS PROCEDURE CAN ALSO BE WRITTEN AS
DELIMITER $$
CREATE PROCEDURE GetDepartmentsWithMoreThanTwoEmployeesParameterized(querry int)
BEGIN
    SELECT Department, COUNT(*) AS EmployeeCount
    FROM staff
    GROUP BY Department
    HAVING EmployeeCount > querry;
END$$
DELIMITER ;

CALL GetDepartmentsWithMoreThanTwoEmployeesParameterized(1);

-- UPDATE PROCEDURE

DELIMITER $$

CREATE PROCEDURE UpdateEmployeeAge(IN pEmployeeName VARCHAR(255), IN pNewAge INT)
BEGIN
    UPDATE staff
    SET Age = pNewAge
    WHERE Name = pEmployeeName;
END$$

DELIMITER ;

SET SQL_SAFE_UPDATES =0;

CALL UpdateEmployeeAge('Faith Chioma', 25);
CALL staff_selection();

DELIMITER $$

CREATE PROCEDURE UpdateEmployeeSalar(IN pDepartment VARCHAR(255), IN pSalaryMultiplier DECIMAL(10, 2))
BEGIN
    UPDATE staff
    SET Salary = Salary + (Salary * pSalaryMultiplier)
    WHERE Department = pDepartment;
END$$

DELIMITER ;

CALL UpdateEmployeeSalar('AI', 0.30);
-- DELETE PROCEDURE

DELIMITER $$

CREATE PROCEDURE DeleteEmployeeByName(IN pEmployeeName VARCHAR(255))
BEGIN
    DELETE FROM staff
    WHERE Name = pEmployeeName;
END$$

DELIMITER ;

CALL DeleteEmployeeByName('Cosmoss Taiwo');

CALL staff_selection();







