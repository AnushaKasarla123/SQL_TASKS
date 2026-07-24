create database college;
use college;

create table Student_Details(
name varchar(10),
mobile_no varchar(10));

alter table Student_Details add
column rollno int first;
alter table Student_Details add 
column address varchar(50);



alter table Student_Details add
column email varchar(20) after name;

desc Student_Details;



alter table Student_Details modify
column mobile_no bigint;



alter table Student_Details rename
column rollno to rollNumber;



alter table Student_Details drop
column address;

desc Student_Details;