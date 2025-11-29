

#Lab 5
# 1.Using the queries below, after making the appropriate changes, create a surrogate primary key for the 'titles' table in your employee schema


# 2.Using the queries below, after making the appropriate changes, create a foreign key constraint for emp_no in the 'titles' with CASCADE option
# Test your knowledge, what do you think will happen in the title table if an emp_no is deleted from the employee table?
# What if you had instead select RESTRICT option rather than CASCADE?

# 3. Using Window functions, write a query that lists emp_no, most recent title, & that employee's second most recent title (using either lead or lag), from_date, and to_date







#Code from Week 5 Lecture
use employees;

#Need to make sure emp_no is VARCHAR
ALTER TABLE employees
MODIFY emp_no VARCHAR(255);

#designate emp_no as natural key
ALTER TABLE employees
ADD PRIMARY KEY (emp_no);

#if you want to drop a primary key
ALTER TABLE employees
DROP PRIMARY KEY;

#what if we added birth_date instead?
ALTER TABLE employees
MODIFY birth_date VARCHAR(255);

ALTER TABLE employees
ADD PRIMARY KEY (birth_date);


#Next we designate a surrogate key in the salaries table

ALTER TABLE salaries 
ADD salary_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

#creating a composite key of emp_no and dept_no for dept_emp table
ALTER TABLE dept_emp
MODIFY emp_no VARCHAR(255);

ALTER TABLE dept_emp
MODIFY dept_no VARCHAR(255);

ALTER TABLE dept_emp 
ADD PRIMARY KEY (emp_no,dept_no);


#Designate emp_no as a FK in the salaries table
#Make sure you first designate it as PK in the employees table

#restrict option
ALTER TABLE salaries
ADD FOREIGN KEY salaries_emp_no_fk(emp_no)
REFERENCES employees(emp_no)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

#dropping an FK
ALTER TABLE salaries
drop foreign key salaries_emp_no_fk;

#set null option
ALTER TABLE salaries
ADD FOREIGN KEY salaries_emp_no_fk(emp_no)
REFERENCES employees(emp_no)
ON DELETE SET NULL
ON UPDATE SET NULL;

#Cascade option
ALTER TABLE dept_emp
ADD FOREIGN KEY dept_emp_emp_no_fk(emp_no)
REFERENCES employees(emp_no)
ON DELETE CASCADE
ON UPDATE CASCADE;