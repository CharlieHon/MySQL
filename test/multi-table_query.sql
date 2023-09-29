-- ----- 多表查询 ----- --
-- 一对多（多对一）：在多的一方建立外键，指向一的一方的主键
alter table emp add constraint fk_emp_dept_id foreign key (dept_id)
references dept(id) on update set null on delete set null;


-- 多对多：建立第三张中间表，中间表至少包含两个外键，分别关联两方主键
create table student(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) not null comment '姓名',
    no varchar(10) not null comment '学号'
) comment '学生表';
insert into student (id, name, no) values
    (null, '林黛玉', '2023246001'), (null, '薛宝钗', '2023246002'),
    (null, '贾宝玉', '2023246003'), (null, '王熙凤', '2023246004');

create table course(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '课程名称'
) comment '课程表';
insert into course (id, name) values
    (null, 'Java'), (null, 'C++'), (null, 'MySQL'), (null, 'Python');


create table student_course(    -- 中间表
    id int auto_increment primary key comment '主键',
    studentId int not null comment '学生ID',    -- 
    courseId int not null comment '课程ID',
    constraint fk_studentId foreign key (studentId) references student(id),
    constraint fk_courseId foreign key (courseId) references course(id)
) comment '学生课程中间表';
insert into student_course values   (null, 1, 1), (null, 1, 2),
                                    (null, 1, 3), (null, 2, 2),
                                    (null, 2, 3), (null, 3, 4);


-- 一对一：在任意一方加入外键，关联另外一方的主键，并且设置外键为唯一的(UNIQUE)
create table tb_user(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    age int comment '年龄',
    gender char(1) comment '1：男，2：女',
    phone char(11) comment '手机号'
) comment '用户基本信息表';

create table tb_user_edu(
    id int auto_increment primary key comment '主键ID',
    degree varchar(20) comment '学历',
    major varchar(50) comment '专业',
    primarySchool varchar(50) comment '小学',
    middleSchool varchar(50) comment '中学',
    university varchar(50) comment '大学',
    userId int unique comment '用户ID',
    constraint fk_userid foreign key (userId) references tb_user(id)
) comment '用户教育信息表';

insert into tb_user (id, name, age, gender, phone) values
    (null, '黄渤', 45, '1', '12356684226'),
    (null, '冰冰', 30, '2', '14452236885'),
    (null, '码云', 55, '1', '16577702225'),
    (null, '李彦宏', 58, '1', '17795532556')
;

insert into tb_user_edu (id, degree, major, primarySchool, middleSchool, university, userId) values
    (null, '本科', '舞蹈', '静安区第一小学', '静安区第一中学', '北京舞蹈大学', 1),
    (null, '本科', '舞蹈', '静安区第一小学', '静安区第一中学', '北京舞蹈大学', 2),
    (null, '本科', '舞蹈', '静安区第一小学', '静安区第一中学', '北京舞蹈大学', 3),
    (null, '本科', '舞蹈', '静安区第一小学', '静安区第一中学', '北京舞蹈大学', 4);



-- 多表查询
-- 内连接演示
-- 1.查询每一个员工的姓名，及关联的部门的名称（隐式内连接完成）
-- 表结构：emp, dept
-- 连接条件：emp.dept_id = dept.id
select e.name, d.name from emp e, dept d where e.dept_id = d.id;    -- 取别名后，必须使用别名获取字段

-- 2.查询每一个员工的姓名，及关联的部门的名称（显式内连接完成）
select emp.name, dept.name from emp inner join dept on emp.dept_id = dept.id;    -- 也可以同上进行取别名

-- ----- 外连接演示 ----- --
-- 1.查询emp表的所有数据，和对应的部门信息（左外连接）
-- 表结构：emp，dept
select e.*, d.name from emp e left outer join dept d on e.dept_id = d.id;

-- 2.查询dept表的所有数据，和对应的员工信息（右外连接）
select d.*, e.* from emp e right outer join dept d on e.dept_id = d.id;
select d.*, e.* from dept d left outer join emp e on d.id = e.dept_id;  -- 与上等价


-- 自连接
-- 1.查询员工 及其 所属领导的姓名
-- 表结构：emp 将emp表看成两张表a, b
select a.name, b.name from emp a, emp b where a.managerId = b.id;   -- 使用内连接，查询交集内容
select a.name, b.name from emp a inner join emp b on a.managerId = b.id;    -- 与上等价

-- 2.查询所有员工 emp 及其领导的名字 emp，如果员工没有领导，也需要查询出来
select a.name '员工', b.name '领导' from emp a left outer join emp b on a.managerId = b.id;   -- 使用外连接，查询所有内容


-- union all, union
-- 1.将 薪资低于5000 的员工，和 年龄大于50岁 的员工全部查询出来
select * from emp where salary < 5000
union all
select * from emp where age > 50;

-- 去除重复值
select * from emp where salary < 5000
union
select * from emp where age > 50;


-- ----- 标量子查询 ----- --
-- 1.查询“销售部”的所有员工信息
-- a.查询”销售部“的部门ID
select id from dept where name = "销售部"; -- 4

-- b.根据”销售部“部门ID，查询员工信息
select * from emp where dept_id = (select id from dept where name = "销售部");

-- 2.查询在“赵敏”入职之后的员工信息
-- a.查询“赵敏”的入职日期
select entryDate from emp where name = "赵敏";    -- 2004-12-20

-- b.查询指定入职日期之后的员工信息
select * from emp where entryDate > (select entryDate from emp where name = "赵敏");


-- ----- 列子查询 ----- --
-- 1.查询“销售部”和“市场部”的所有员工信息
-- a.查询“销售部”和“市场部”的部门ID
select id from dept where name = "市场部" or name = "销售部";
-- b.根据部门ID，查询员工信息
select * from emp where emp.dept_id in (select id from dept where name = "市场部" or name = "销售部");

-- 2.查询比财务部所有人工资都高的员工信息
-- a.查询财务部的所有员工工资
select id from dept where name = "财务部";
select salary from emp where dept_id = (select id from dept where name = "财务部");    -- 财务部所有人员工资
-- b.比财务部所有人工资都高的员工信息
select * from emp where salary > all (select salary from emp where dept_id = (select id from dept where name = "财务部"));

-- 3.查询比研发部其中任意一人工资高的员工信息
select * from emp where salary > any (select salary from emp where dept_id = (select id from dept where name = "研发部"));


-- ----- 行子查询 ----- --
-- 1.查询与“张无忌”的薪资及直属领导相同的员工信息
-- a.查询张无忌的薪资及直属领导
select salary, managerId from emp where name = "张无忌";
-- b.查询员工
select * from emp where (salary, managerId) = (select salary, managerId from emp where name = "张无忌");


-- ---- 表子查询 ----- --
-- 1.查询与“鹿杖客”、“宋远桥”的职位和薪资相同的员工信息
-- a.查询“鹿杖客”、“宋远桥”的职位和薪资
select job, salary from emp where name = "鹿杖客" or name = "宋远桥";
-- 查询的条件是多行数据，所以用 IN
select * from emp where (job, salary) in (select job, salary from emp where name = "鹿杖客" or name = "宋远桥");

-- 2.查询入职日期是“2006-01-01”之后的员工信息，及其部门信息
-- a.查询员工信息
select * from emp where entryDate > "2006-01-01";
-- b.对应部门信息 因为要保留所有信息，所以采用外连接
select e.*, d.* from (select * from emp where entryDate > "2006-01-01") e left join dept d on e.dept_id = d.id;



-- ----- 多表查询案例 ----- --
-- 0.创建薪资表
create table salgrade
(
    grade int,
    losal int,
    hisal int
) comment "薪资表";
insert into salgrade
values (1, 0, 3000),
       (2, 3001, 5000),
       (3, 5001, 8000),
       (4, 8001, 10000),
       (5, 10001, 15000),
       (6, 15001, 20000),
       (7, 20001, 25000),
       (8, 25001, 30000);

-- 1.查询员工的姓名、年龄、职位、部门信息
-- select e.name, e.age, e.job, d.name from (select name, age, job, managerId from emp) e left join dept d on e.managerId = d.id;
select e.name, e.age, e.job, d.name
from emp e,
     dept d
where e.dept_id = d.id;

-- 2.查询年龄小于30岁的员工姓名、年龄、职位、部门信息（显式内连接）
-- select e.name, e.age, e.job, d.name from (select name, age, job, managerId from emp where age < 30) e left join dept d on e.managerId = d.id;
select e.name, e.age, e.job, d.name
from emp e
         inner join dept d on e.dept_id = d.id
where age < 30;

-- 3.查询拥有员工的部门ID、部门名称
select distinct d.id, d.name
from dept d
         inner join emp e
where d.id = e.dept_id;
-- distinct 去重！！！

-- 4.查询所有年龄大于40岁的员工，及其归属的部门名称；如果员工没有分配部门，也需要展示出来
select e.*, d.name
from emp e
         left outer join dept d on e.dept_id = d.id
where e.age > 40;

-- 5.查询所有员工的工资等级
-- 表：emp salgrade
-- 连接田间：emp.salary >= salgrade.losal and emp.salary <= salgrade.hisal;
select e.*, s.grade
from emp e,
     salgrade s
where e.salary >= s.losal
  and e.salary <= s.hisal;
select e.*, s.grade
from emp e,
     salgrade s
where e.salary between s.losal and s.hisal;
-- 同上

-- 6.查询“研发部”所有员工的信息及工资等级
-- select e.*, s.grade from emp e, salgrade s where e.dept_id = (select id from dept d where d.name = "研发部") and e.salary between s.losal and s.hisal;
-- 连接n张表，至少需要n-1个条件
select e.*, s.grade
from emp e,
     dept d,
     salgrade s
where e.dept_id = d.id
  and (e.salary between s.losal and s.hisal)
  and d.name = "研发部";

-- 7.查询“研发部”员工的平均工资
select d.name, avg(e.salary) from emp e, dept d where e.dept_id = d.id and d.name = "研发部";

-- 8.查询工资比“灭绝”高的员工信息
select * from emp e where e.salary > (select salary from emp e2 where e2.name = "灭绝");

-- 9.查询比平均薪资高的员工信息
select * from emp e where e.salary > (select avg(salary) from emp);

-- 10.查询低于本部门平均工资的员工信息
-- a.查询本部门平均工资
select * from emp e1 where e1.dept_id = 1;
-- b.查询低于本部门平均工资低的员工信息
select e2.* from emp e2 where e2.salary < (select avg(e1.salary) from emp e1 where e1.dept_id= e2.dept_id);

-- 11.查询所有的部门信息，并统计部门的员工人数
select d.id, d.name, (select count(*) from emp e where e.dept_id = d.id) "员工人数" from dept d;

-- 12.查询所有学生的选课情况，展示出学生名称，学号，课程名称
-- 表：student、course、studentCourse
-- 连接条件：student.id = student_course.studentId and course.id = student_course.courseId
select s.name, s.no, c.name from student s, course c, student_course sc where s.id = sc.studentId and c.id = sc.courseID;