use employees;

# create table contining the current employees with the condition.
create table comp_emp as 
select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, s.salary, s.from_date, s.to_date, d.dept_name
from employees as e 
join salaries as s on e.emp_no = s.emp_no 
join dept_emp as de on e.emp_no = de.emp_no 
join departments as d on de.dept_no = d.dept_no 
where ( s.to_date between '2000-12-31' and '9999-01-01') and ( s.from_date <= '2000-12-31')
group by e.emp_no
order by e.emp_no;

select * 
from comp_emp;


select ce.emp_no, d.dept_name
from comp_emp as ce 
join dept_emp as de on ce.emp_no = de.emp_no
join departments as d on de.dept_no = d.dept_no
group by ce.emp_no 
order by ce.emp_no; 



# The number of employees by gender. 
select gender, count(*) 
from comp_emp 
group by gender; 



# The number of employees thay hired in last 5 years by gender.
select gender, count(*) 
from comp_emp 
where hire_date between '1995-01-01' and '2000-12-31' 
group by gender;



# The proportion of employees by gender. 
select concat(round(sum(case when gender = 'M' then 1 else 0 end ) / count(*) * 100), '%') as per_M,
concat(round(sum(case when gender = 'F' then 1 else 0 end ) / count(*) * 100), '%') as per_F 
from comp_emp
where hire_date between '1995-01-01' and '2000-12-31' ; 




# The number of employees in each department by gender. 
select ce.gender, d.dept_name, count(*) as emp_count
from comp_emp as ce
join dept_emp as de on ce.emp_no = de.emp_no
join departments as d on de.dept_no = d.dept_no
group by ce.gender, d.dept_name
order by d.dept_name, ce.gender;





# The total number and proportion of employees in each department by gender.
select d.dept_name, count(*) as emp_count, concat(round(sum(case when ce.gender = 'M' then 1 else 0 end ) / count(*) * 100), '%') as per_M,
concat(round(sum(case when ce.gender = 'F' then 1 else 0 end ) / count(*) * 100), '%') as per_F
from comp_emp as ce
join dept_emp as de on ce.emp_no = de.emp_no
join departments as d on de.dept_no = d.dept_no
group by d.dept_name;




select d.dept_name, round(avg(ce.salary)) as avg_salary, ce.gender
from comp_emp as ce
join dept_emp as de on ce.emp_no = de.emp_no
join departments as d on d.dept_no=de.dept_no
group by d.dept_no, ce.gender
order by d.dept_name, ce.gender;




# The number of epmloyees thay hire in each year.
select  date_format(hire_date,'%Y') as Year, gender, count(emp_no) as emp_count
from comp_emp
group by extract(year from hire_date), gender
order by extract(year from hire_date);


#  Table employees only who are a Manager.
CREATE OR REPLACE VIEW v_mang as
SELECT *
FROM comp_emp as ce
WHERE ce.emp_no IN (SELECT dm.emp_no
        FROM dept_manager as dm);
        
select * 
from v_mang;



# Table employees who are not a Manager.
CREATE OR REPLACE VIEW v_emp as
SELECT *
FROM comp_emp as ce
WHERE ce.emp_no NOT IN (SELECT dm.emp_no
        FROM dept_manager as dm);
        
select *
from v_emp;
        


# The average salary from employees who are not a Manager in each department by gender.        
select d.dept_name, round(avg(ve.salary)) as avg_salary, ve.gender
from v_emp as ve
join dept_emp as de on ve.emp_no = de.emp_no
join departments as d on d.dept_no=de.dept_no
group by d.dept_no, ve.gender
order by d.dept_name;



# The sum salary from all employees who are not a Manager in each department. 
select d.dept_name, sum(ve.salary) as sum_salary
from v_emp as ve
join dept_emp as de on ve.emp_no = de.emp_no
join departments as d on d.dept_no=de.dept_no
group by d.dept_no
order by sum(ve.salary) desc;


# The number of manager by gender.
select gender, count(*) as Manager_count
from v_mang
group by gender;


# Table containing the manager name, gender and salary in each department.
select vm.first_name, vm.gender, d.dept_name, vm.salary
from v_mang as vm 
join dept_emp as de on vm.emp_no = de.emp_no
join departments as d on de.dept_no = d.dept_no
group by vm.first_name
order by dept_name;
 

 










