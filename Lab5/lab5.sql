drop schema if exists lab5 ;
create schema lab5;
use lab5 ;
 create table dept(
	dnumber INT,
    dname varchar(255),
    founded date,
    mgr_ssn int,
    budget int,
    primary key (dnumber)
 );
 create table EMPLOYEE(
     ssn int,
	dno INT,
    ename varchar(255),
    bdate date,
    salary int,
    primary key (ssn),
    foreign key (dno) REFERENCES dept(dnumber)
);
insert into dept values(4,'dept4','1970-10-30', 444,1200);
insert into dept values(5,'dept5','1980-10-30', 555,1700);
insert into dept values(6,'dept6','1990-10-30', 666,2400);
insert into Employee values(444,4,'ali','1940-10-30', 1600);
insert into Employee values(555,5,'mohaned','1930-10-30', 1800);
insert into Employee values(666,6,'omar','1950-10-30', 2000);
insert into Employee values(100,4,'amr','1930-10-30', 1000);
insert into Employee values(200,5,'salah','1930-10-30', 800);
insert into Employee values(105,4,'sayed','1930-10-30', 600);

alter table dept add foreign key (mgr_ssn) references employee(ssn);

DELIMITER $$

CREATE FUNCTION Count_Emp(
	dnumber int
) 
RETURNS int
DETERMINISTIC
BEGIN
    DECLARE noOfEmp int;
	select count(*) into noOfEmp from employee where dno = dnumber ;
	-- return number of employees in department dnumber
	RETURN (noOfEmp);
END$$
DELIMITER ;

delimiter //

CREATE PROCEDURE DeptYear()
       BEGIN
			update dept set founded = '1960-1-1' 
            where dept.founded < '1960-1-1';
       END//
delimiter ;

delimiter $$
create trigger deptEmpCheck
before insert on Employee
for each row
begin
	declare counter int ;
    select count(*) into counter from Employee where Employee.dno = New.dno ;
  if (counter =8 ) then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'department full';
  end if ;
end
$$
delimiter ;

insert into Employee values(107,4,'sayed','1930-10-30', 600);
insert into Employee values(108,4,'sayed','1930-10-30', 600);
insert into Employee values(109,4,'sayed','1930-10-30', 600);
insert into Employee values(110,4,'sayed','1930-10-30', 600);
insert into Employee values(111,4,'sayed','1930-10-30', 600);
insert into Employee values(112,4,'sayed','1930-10-30', 600);

select Count_Emp(4);

insert into dept values(7,'dept7','1940-10-30', 111,2400);
insert into dept values(8,'dept8','1930-10-30', 110,2400);

CALL DeptYear();
select * from dept where dnumber >6 ;