-- ----- 外键约束 ----- --
-- 准备数据
create table dept(
    id int auto_increment primary key comment 'ID',
    name varchar(50) not null comment '部门名称'
) comment '部门表';

INSERT INTO dept (id, name) VALUES (1, '研发部'), (2, '市场部'), (3, '财务部'), (4, '销售部'), (5, '总经办');

create table emp(
    id int auto_increment primary key comment 'ID',
    name varchar(50) not null comment '姓名',
    age int comment '年龄',
    job varchar(20) comment '职位',
    salary int comment '薪资',
    entryDate date comment '入职时间',
    managerId int comment '直属领导',
    dept_id int comment '部门ID'
) comment '员工表';

INSERT INTO emp (id, name, age, job, salary, entrydate, managerid, dept_id) VALUES
	(1, '金庸', 66, '总裁', 20000, '2000-01-01', null, 5), (2, '张无忌', 20, '项目经理', 12500, '2005-12-05', 1, 1),
	(3, '杨逍', 33, '开发', 8400, '2000-11-03', 2, 1), (4, '韦一笑', 48, '开发', 11000, '2002-02-05', 2, 1),
	(5, '常遇春', 43, '开发', 10500, '2004-09-07', 3, 1), (6, '小昭', 19, '程序员鼓励师', 6600, '2004-10-12', 2, 1);

-- 添加外键
alter table emp constraint fk_emp_dept_id foreign key (dept_id) references dept(id);

-- 删除外键
alter table emp drop foreign key fk_emp_dept_id;

-- 删除/更新行为
-- cascade检查外键是否有对应子表记录，如果有，则也删除/更新外键在子表中的记录
alter table emp add constraint fk_emp_dept_id foreign key (dept_id)
references dept(id) on update cascade on delete cascade;
