
create database college_management;

 use college_management
 
 create table students(
 student_id int primary key,
 student_name varchar(50),
 age int check(age>=18),
 gender char(1) check(gender in ('M','F')),
 course varchar(30),
 city varchar(50),
 marks int,fee decimal(10,2) default 30000);
 
 alter table students add email varchar(100);
 
  alter table students modify course varchar(50);
  
  alter table students rename column student_name to full_name;
  
  alter table students rename to college_students;
  
  alter table college_students drop column email;
  
  
  CREATE TABLE college_students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 18),
    gender CHAR(1) CHECK (gender IN ('M','F')),
    course VARCHAR(30),
    city VARCHAR(50),
    marks INT,
    fee DECIMAL(10,2) DEFAULT 30000
);
  
   insert into college_students values(111,'Ravi',20,'M','python','Hyderabad',80,35000);
   INSERT INTO college_students
VALUES
(112,'Meena',21,'F','Java','Vizag',90,40000),
(113,'Ajay',22,'M','SQL','Guntur',72,30000),
(114,'Pooja',19,'F','Python','Hyderabad',95,42000),
(115,'Vikas',20,'M','Data Science','Warangal',88,45000);
SET SQL_SAFE_UPDATES = 0;

 select * from college_students;
 
 UPDATE college_students
SET fee = fee + 5000
WHERE course = 'Python';
SELECT * FROM college_students;

UPDATE college_students
SET marks = marks + 5
WHERE city='Hyderabad';

UPDATE college_students
SET city='Bengaluru'
WHERE student_id=105;

DELETE FROM college_students
WHERE marks<60;

 use  college_students;
 
SELECT student_name,course,marks
FROM college_students;

SELECT
student_name,
fee,
fee*12 AS yearly_fee
FROM college_students;

SELECT *
FROM college_students
WHERE NOT course='Java';

CREATE TABLE courses(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50) UNIQUE,
    duration VARCHAR(30) NOT NULL,
    fee DECIMAL(10,2) CHECK(fee>0)
);

CREATE TABLE enrollments(
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,

    FOREIGN KEY(student_id)
    REFERENCES college_students(student_id),

    FOREIGN KEY(course_id)
    REFERENCES courses(course_id)
);

ALTER TABLE college_students
ADD email VARCHAR(100);

ALTER TABLE college_students
ADD CONSTRAINT unique_email
UNIQUE(email);

ALTER TABLE college_students
ALTER city SET DEFAULT 'Hyderabad';
select * from college_students;

desc enrollments;
 

