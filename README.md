# MySQL

## 基础篇

- MySQL概述
- SQL
- 函数
- 约束
- 多表查询
- 事务

### MySQL概述

| 名称           | 全程                                                                 | 简称                             |
| -------------- | -------------------------------------------------------------------- | -------------------------------- |
| 数据库         | 存储数据的仓库，数据是有组织的进行存储                               | DataBase(DB)                     |
| 数据库管理系统 | 操纵和管理数据库的大型软件                                           | DataBase Management System(DBMS) |
| SQL            | 操作关系型数据库的编程语言，定义了一套关系型数据库统一**标准** | Structured Query Language(SQL)   |

### MySQL数据库

- MySQL默认端口：`Port3306`
- Windows Service Name：`MySQL80`

**启动与停止**

1. 命令行窗口输入 `services.msc`进入系统服务
2. 点击 `MySQL80`，右键启动/终止

或者

> `net start mysql80`
>
> `net stop mysql80`
>
> 注意：默认mysql是开机自动启动的

**客户端连接**

方式一：MySQL提供的客户端命令行工具 `MySQL 8.0 Command Line Client`

方式二：系统自带的命令行工具执行语句 `mysql [-h 27.0.0.1] [-P 3306] -u root -p`

> 要想在任意路径下使用方式二，需要配置PATH环境变量

**关系型数据库(RDBMS)**

- 概念：建立在关系模型基础上，由多张相互连接的二维表组成的数据库

1. **使用表存储数据**，格式统一，便于维护
2. 使用SQL语言操作，标准统一，使用方便

**数据模型**

![数据模型](image/01_dm.png)

> 通过客户端连接MySQL数据库管理系统，使用SQL语句通过DNMS创建数据库，在指定数据库上创建表

### SQL

#### SQL通用语法

1. SQL语句可以单行或多行书写，以分号结尾
2. SQL语句可以使用空格/缩进来增强语句的可读性
3. MySQL数据库的SQL语句不区分大小写，关键字建议使用大写
4. 注释
   1. 单行注释：`--`注意内容 或 `#`注释内容(MySQL特有)
   2. 多行注释：`/* 注释内容 */`

#### SQL分类

| 分类 | 全称                           | 说明                                                             |
| ---- | ------------------------------ | ---------------------------------------------------------------- |
| DDL  | `Data Definition Language`   | 数据定义语言，用来定义数据库对象(**数据库、表、字段**)     |
| DML  | `Data Manipulation Language` | 数据操作语言，用来对数据库**表中的数据进行增删改**         |
| DQL  | `Data Query Language`        | 数据查询语言，用来**查询数据库中表的记录**                 |
| DCL  | `Data Control Language`      | 数据控制语言，用来**创建数据库用户、控制数据库的访问权限** |

#### DDL

##### DDL-数据库操作

- 查询

查询所有数据库

```sql
SHOW DATABASES;
```

查询当前数据库

```sql
SELECT DATABASE();
```

- 创建

```sql
CREATE DATABASE [IF NOT EXISTS] 数据库名 [DEFAULT CHARSET 字符集] [COLLATE 排序规则]
```

- 删除

```sql
DROP DATABASE [IF EXISTS] 数据库名;
```

- 使用

```sql
USE 数据库名;
```

##### DDL-表操作-查询

- 查询当前数据库所有表

```sql
SHOW TABLES;
```

- 查询表结构

```sql
DESC 表名;
```

- 查询指定表的建表语句

```sql
SHOW CREATE TABLE 表名;
```

##### DDL-表操作-创建

```sql
CREATE TABLE 表明(
	字段1 字段1类型[COMMENT 字段1注释],
	字段2 字段2类型[COMMENT 字段2注释],
	...
	字段n 字段n类型[COMMENT 字段n注释]
)[COMMENT 表注释];
```

> 注意：[...]为可选参数，最后一个字段后面没有逗号 `,`

```sql
-- 使用SQL语句创建如上表，表名`user`
create table user(
	id int comment '编号',
	name varchar(50) comment '姓名',
	age int comment '年龄',
	gender varchar(1) comment '性别'
) comment '用户表';

-- 查看刚创建的表
desc user;

-- 查看创建表的详细SQL指令
show create table user;

```

##### DDL-表操作-数据类型

MySQL中的数据类型有很多，主要分为三类：**数值类型、字符串类型、日期时间类型**。

| 数值类型               | 大小   | 有符号(SIGNED)范围                       | 无符号(UNSIGNED)范围       | 描述               |
| ---------------------- | ------ | ---------------------------------------- | -------------------------- | ------------------ |
| `TINTINT`            | 1 byte | (-128, 127)                              | (0, 255)                   | 小整数值           |
| `SMALLINT`           | 2 byte | (-32768, 32767)                          | (0, 65535)                 | 大整数值           |
| `MEDIUMINT`          | 3 byte |                                          |                            | 大整数值           |
| `INT` 或 `INTEGER` | 4 byte |                                          |                            | 大整数值           |
| `BIGINT`             | 8 byte |                                          |                            | 极大整数值         |
| `FLOAT`              | 4 byte |                                          |                            | 单精度浮点数       |
| `DOUBLE`             | 8 byte |                                          |                            | 双精度浮点值       |
| `DECIMAL`            |        | 依赖于**M(精度)**和**D(标度)**的值 | 依赖于M(精度)和D(标度)的值 | 小数值(精度定点数) |

```sql
CREATE TABLE student(
	age TINYINT UNSIGNED,
	score DOUBLE(4, 1)	-- 4表示精度，最大允许4个数；表示标度，保留一位小数
	-- 例如：100.0, 98.5
);
```

| 字符串类型 | 大小              | 描述                         |
| ---------- | ----------------- | ---------------------------- |
| CHAR       | 0~255 byte        | 定长字符串                   |
| VARCHAR    | 0~65535 byte      | 变长字符串                   |
| TINYBLOB   | 0~255 byte        | 不超过255个字符的二进制数据  |
| TINTTEXT   | 0~255 byte        | 短文本字符串                 |
| TEXT       | 0~65535 byte      | 长文本数据                   |
| BLOB       | 0~65535 byte      | 二进制形式的长文本数据       |
| MEDIUMTEXT | 0~16777215 byte   | 中等长度文本数据             |
| MEDIUMBLOB | 0~16777215 byte   | 二进制形式的中等长度文本数据 |
| LONGTEXT   | 0~4294967295 byte | 极大文本数据                 |
| LONGBLOB   | 0~4294967295 byte | 二进制形式的极大文本数据     |

> `char(10)`：占用固定字符空间，长度不够空格存储。性能好
> `varchar(10)`：10表示最大存储字符串长度，根据内容计算存储空间。性能较差
>
> 性别类型：`char(1)`
>
> 用户名类型：`varchar(50)`

| 日期类型  | 大小 | 范围                                        | 格式                    | 描述                     |
| --------- | ---- | ------------------------------------------- | ----------------------- | ------------------------ |
| DATE      | 3    | 1000-01-01 至 9999-12-21                    | `YYYY-MM-DD`          | 日期值                   |
| TIME      | 3    | -838:59:59 至 838:59:59                     | `HH:MM:SS`            | 时间值或持续时间         |
| YEAR      | 1    | 1901 至 2155                                | `YYYY`                | 年份值                   |
| DATATIME  | 8    | 1000-01-01 00:00:00 至 9999-12-21 23:59:59 | `YYYY-MM-DD HH:MM:SS` | 混合日期和时间值         |
| TIMESTAMP | 4    | 1970-01-01 00:00:00 至 2038-01-19 03:14:07 | `YYYY-MM-DD HH:MM:SS` | 混合日期和时间值，时间戳 |

> 生日类型： `birthday DATE`

**案例：根据需求创建表(设计合理的数据类型、长度)**

![1695286037604](image/1695286037604.png)

```sql
-- 创建员工表
CREATE TABLE emp(
    id INT COMMENT '编号',
    wordNo VARCHAR(10) COMMENT '员工工号',
    name VARCHAR(10) COMMENT '姓名',
    gender CHAR(1) COMMENT '性别',
    age TINYINT UNSIGNED COMMENT '年龄',
    idCard CHAR(18) COMMENT '身份证号',
    entryData DATE COMMENT '入职时间'
) COMMENT '员工表';
```

##### DDL-表操作-修改

- 添加字段

```sql
ALTER TABLE 表名 ADD 字段名 类型(长度) [COMMENT 注释] [约束];
```

```sql
-- 案例：为emp表增加一个新的字段“昵称”为nickname，类型varchar(20)
ALTER TABLE emp ADD nickName VARCHAR(20) COMMENT '昵称';
```

- 修改数据类型

```sql
ALTER TABLE 表名 MODIFY 字段名 新数据类型(长度);
```

- 修改字段名和字段类型

```sql
ALTER TABLE 表名 CHANGE 旧字段名 新字段名 类型(长度) [COMMENT 注释] [约束];
```

```sql
-- 案例：将emp表的nickName字段修改为username，类型为varchar(30)
ALTER TABLE emp CHANGE nickName username VARCHAR(30) COMMENT '用户名';
```

- 删除字段

```sql
ALTER TABLE 表名 DROP 字段名;
```

```sql
-- 案例：将emp表的字段username删除
ALTER TABLE emp DROP username;
```

- 修改表名

```sql
ALTER TABLE 表名 RENAME TO 新表名;
```

```sql
-- 案例：将emp表的表名修改为employee
ALTER TABLE emp RENAME TO employee;
```

##### DDL-表操作-删除

- 删除表

```sql
DROP TABLE [IF EXISTS] 表名;
```

- 删除指定表，并重新创建该表

```sql
TRUNCATE TABLE 表名;
```

> 注意：在删除表时，表中的全部数据也会被删除。

**总结**

1. DDL-数据库操作

```sql
SHOW DATABASES;	-- 查看当前有哪些数据库
CREATE DATABASE 数据库名;	-- 创建数据库
USE 数据库名;	-- 使用指定数据库
SELECT DATABASE();	-- 查看当前处于哪个数据库
DROP DATABASE 数据库名;	-- 删除指定数据库
```

2. DDL-表操作

```sql
SHOW TABLES;	-- 显示当前数据库所有表
CREATE TABLE 表名 (字段1 字段1类型, 字段2 字段2类型);	-- 创建表
DESC 表名;	-- 查看表
SHOW CREATE TABLE 表名;	-- 查看表的建表指令
ALTER TABLE ADD/MODIFY/CHANGE/RENAME TO ...;	-- 向表添加字段/改变字段类型/改变字段名和字段类型/改变表名
DROP TABLE 表名;	-- 删除表
TRUNCATE TABLE 表名;	-- 删除表内容
```

#### DML

##### DML-介绍

DML英文全称是 `Data Manipulation Language(数据操作语言)`，用来对数据库中的数据记录进行增删改操作。

- 添加数据(`INSERT`)
- 修改数据(`UPDATE`)
- 删除数据(`DELETE`)

##### DML-插入数据

1. 给指定字段添加数据

```sql
INSERT INTO 表名 (字段名1, 字段名2, ...) VALUES (值1, 值2, ...);
```

2. 给全部字段添加数据

```sql
INSERT INTO 表名 VALUES (值1, 值2, ...);
```

3. 批量添加数据

```sql
INSERT INTO 表名 (字段名1, 字段名2, ...) VALUES (值1, 值2, ...), (值1, 值2, ...);
INSERT INTO 表名 VALUES (值1, 值2, ...), (值1, 值2, ...);
```

> 注意：
>
> - 插入数据时，指定的字段顺序需要与值的顺序一一对应。
> - 字符串和日期型数据应该包含在引号中。
> - 插入的数据大小，应该在字段的规定范围内。

```sql
-- 插入指定字段的值
insert into employee (id, wordNo, name, gender, age, idCard, entryData) values (1, 1, '张三', '男', 23, 123415199811047421, '2023-08-31');
select * from employee; -- 查看表中数据
-- 如果不指定字段名，则为表中所有字段赋值，值要与字段名一一对应
-- 插入一条完整数据
insert into employee values (2, 2, '李四', '男', 27, 411415199811047421, '2023-08-31');
-- 插入多条数据，数据间用逗号分隔
insert into employee values (3, 3, '王五', '男', 30, 110415197811047421, '2023-08-31'),
                            (4, 4, '李自成', '男', 42, 100132157305073066, '2023-09-01');
```

##### DML-修改数据

```sql
UPDATE 表名 SET 字段名1=值1, 字段名2=值2, ...[WHERE 条件];
```

> 注意：修改语句的条件可以有，也可以没有，如果没有条件，则会修改整张表的所有数据。

```sql
-- 修改id为1的数据，将name修改为itheima
UPDATE employee SET name = 'itheima' WHERE id = 1;
-- 修改id为1的数据，将name修改为小昭，gender修改为女
UPDATE employee SET name = '小昭', gender = '女' WHERE id = 1;
-- 将所有的员工入职日期改为 2008-01-01
UPDATE employee SET entryData = '2008-01-01';
```

##### DML-删除数据

```sql
DELETE FROM 表名 [WHERE 条件];
```

> 注意：
>
> - DELETE语句的条件可以有，也可以没有，如果没有条件，则会删除整张表的所有数据。
> - DELETE语句不能删除某一个字段的值(可以用UPDATE)

```sql
-- 删除gender为女的员工
DELETE FROM employee WHERE gender = '女';
-- 删除所有员工
DELETE FROM employee;
```

**总结**

1. 添加数据

```sql
-- 为指定字段添加值
INSERT INTO 表名 (字段名1, 字段名2, ...) VALUES (值1, 值2, ...);
-- 添加完整数据
INSERT INOT 表名 VALUES (值1, 值2, 值3, ...);
```

2. 修改数据

```sql
-- 无WHERE条件修改全部数据
UPDATE 表名 SET 字段1 = 值1, 字段2 = 值2 [WHERE 条件];
```

3. 删除数据

```sql
-- 无WHERE条件删除表中所有数据
DELETE FROM 表名 [WHERE 条件];
```

#### DQL

##### DQL-介绍

DQL英文全称为 `Data Query Language(数据查询语言)`，用来查询数据库中表的记录。

查询关键字：`SELECT`

##### DQL-语法

```sql
SELECT 
	字段列表
FROM
	表名列表
WHERE
	条件列表
GROUP BY
	分组字段列表
HAVING
	分组后条件列表
ORDER BY
	排序字段列表
LIMIT
	分页参数
```

##### DQL-基本查询

1. 查询多个字段

```sql
SELECT 字段1, 字段2, 字段3... FROM 表名;
-- 查询并返回所有字段
SELECT * FROM 表名;
```

2. 设置别名

```sql
SELECT 字段1 [AS 别名1], 字段2 [AS 别名2] ... FROM 表名;
```

3. 去除重复记录

```sql
SELECT DISTINCT 字段列表 FROM 表名;
```

```sql
CREATE TABLE IF NOT EXISTS emp(
	id int comment '编号',
	workno int comment '工作编号',
	name varchar(10) comment '姓名',
	age tinyint unsigned comment '年龄',
	workaddress varchar(10) comment '工作地点'
) comment '员工表';
-- 基本查询
-- 1.查询指定字段 name, workno, age 返回
SELECT name, workno, age FROM emp;	-- 只返回指定字段名

-- 2.查询所有字段
SELECT * FROM emp;

-- 3.查询所有员工的工作地点，起别名
SELECT workaddress as '工作地点' FROM emp;

-- 查询所有员工的上班地点(不重复)
SELECT DISTINCT workaddress '工作地点' FROM emp;

```

##### DQL-条件查询

1. 语法

```sql
SELECT 字段列表 FROM 表名 WHERE 条件列表;
```

2. 条件

| 比较运算符       | 功能                                             |
| ---------------- | ------------------------------------------------ |
| >                | 大于                                             |
| >=               | 大于等于                                         |
| <                | 小于                                             |
| <=               | 小于等于                                         |
| =                | 等于                                             |
| <> 或 !=         | 不等于                                           |
| BETWEEN...AND... | 在某个范围之内(含最小、最大值)                   |
| IN(...)          | 在in之后的列表中的值，多选一                     |
| LIKE 占位符      | 模糊匹配(`_`匹配单个字符，`%`匹配任意个字符) |
| IS NULL          | 是 `NULL`                                      |

| 逻辑运算符 | 功能                       |
| ---------- | -------------------------- |
| AND 或 &&  | 并且(多个条件同时成立)     |
| OR 或      | 或者(多个条件任意一个成立) |
| NOT 或 !   | 非，不是                   |

```sql
-- 条件查询
-- 1.查询年龄等于 88 的员工
select * from employee where age = 88;

-- 2.查询年龄小于 20 的员工
select * from employee where age < 20;

-- 3.查询年龄小于等于 20 的员工
select * from employee where age <= 20;

-- 4.查询没有身份证的员工
select * from employee where idCard is NULL;

-- 5.查询有身份证的员工
select * from employee where idCard is not null;

-- 6.查询年龄不等于88的员工
select * from employee where age <> 88; -- !=

-- 7.查询年龄在15~20之间的员工（包含边界）
select * from employee where age >= 15 and age <=20;    -- &&
select * from employee where age between 15 and 20; -- 注意顺序

-- 8.查询性别为 女 且年龄小于 50 的员工
select * from employee where gender = '女' and age < 50;

-- 9.查询年龄等于 18 或 20 或 40 的员工
select * from employee where age = 18 or age = 20 or age = 40;
select * from employee where age in (18, 20, 40);   -- in

-- 10.查询姓名为两个字的员工信息
select * from employee where name like '__';    -- '__'代表两个字符

-- 11.查询身份证号最后一位是X的员工信息
select * from employee where idCard like '%X';  -- % 匹配任意个字符
select * from employee where idCard like '_________________X';
```

##### SQL-聚合函数

> 注意：`null`值不参与所有聚合函数运算

1. 介绍

将**一列数据**作为一个整体，进行纵向计算

2. 常见聚合函数

| 函数  | 功能     |
| ----- | -------- |
| count | 统计数量 |
| max   | 最大值   |
| min   | 最小值   |
| avg   | 平均值   |
| sum   | 求和     |

3. 语法

```sql
SELECT 聚合函数(字段列表) FROM 表名;
```

```sql
-- 聚合函数
-- 1.统计员工数量
SELECT COUNT(*) FROM employee;  -- 15
select count(id) from employee; -- 15
select count(idCard) from employee; -- 14 null值不参与所有聚合函数

-- 2.统计员工的平均年龄
select avg(age) from employee;  -- 38.4

-- 3.统计员工的最大年龄
select max(age) from employee;  -- 88

-- 4.统计该企业员工的最小年龄
select min(age) from employee;  -- 12

-- 5.统计成都地区员工的最小年龄
select min(age) from employee where workaddress = '成都'; -- 12
```

##### DQL-分组查询

1. 语法

```sql
SELECT 字段列表 FROM 表名 [WHERE 条件] GROUP BY 分组字段名 [HAVING 分组后过滤条件];
```

2. where和having区别

- 执行时机不同：`where`是分组之前进行过滤，不满足 `where`条件，不参与分组；而 `having`是分组之后对结果进行过滤。
- 判断条件不同：`where`不能对聚合函数进行判断，而 `having`可以。

> 注意：
>
> - 执行顺序：`where` > 聚合函数 > `having`
> - 分组之后，查询的字段一般为聚合函数和分组字段，查询其他字段无任何意义

```sql
-- 分组查询
-- 1.根据性别分组，统计男性员工和女性员工的数量
select gender, count(*) from employee group by gender;

-- 2.根据性别分组，统计男性员工和女性员工的平均年龄
select gender, avg(age) from employee group by gender;

-- 3.查询年龄小于45的员工，并提取工作地址分组，获取员工数量大于等于2的工作地址
select workaddress, count(*) from employee where age < 45 group by workaddress having count(*) >= 2;

```

##### DQL-排序查询

1. 语法

```sql
SELECT 字段列表 FROM 表名 ORDER BY 字段1 排序方式1, 字段2 排序方式2;
```

2. 排序方式

- `ASC`：升序(默认值)
- `DESC`：降序

> 注意：如果是多字段排序，当第一个字段值相同时，才会根据第二个字段进行排序

```sql
-- 排序查询
-- 1.根据年龄对公司的员工进行升序排序
select * from employee order by age;

-- 2.根据入职时间，对员工进行降序排序
select * from employee order by entryData desc;

-- 3.根据年龄对公司的员工进行升序排序，年龄相同，在按照入职时间进行降序排序
select * from employee order by age , entryData desc;
```

##### DQL-分页查询

1. 语法

```sql
SELECT 字段列表 FROM 表名 LIMIT 起始索引, 查询记录数;
```

> 注意：
>
> - 起始索引从0开始，**起始索引 = (查询页码 - 1) * 每页显示记录数**
> - 分页查询是数据库的方言，不同的数据库有不同的实现，MySQL是 `LIMIT`
> - 如果查询的是第一页数据，起始索引可以省略，直接简写为 `limit 10`

```sql
-- 分页查询
-- 1.查询第1页员工数据，每页展示10条记录
select * from employee limit 10;

-- 2.查询第2页员工数据，每页展示10条记录
select * from employee limit 10, 10;
```

![DQL案例](image/1695377563244.png)

```sql
-- DQL案例
select * from employee where gender = '男' and age in (20, 21, 22, 23);
select * from employee where gender = '男' and (age between 20 and 40) and name like '___';
select gender, count(*) from employee where age < 60 group by gender;   -- 年龄小于60岁的，男性员工和女性员工的人数
select name, age from employee where age <= 35 order by age asc, entryData desc;
select * from employee where gender = '男' and age between 20 and 40 order by age, entryData desc limit 5;
```

##### DQL-执行顺序

```mysql
-- 编写顺序
SELECT
	字段名
FROM
	表名
WHERE
	条件列表
GROUP BY
	分组字段列表
HAVING
	分组后条件列表
ORDER BY
	排序字段列表
LIMIT
	分页参数
```

![编写顺序和执行顺序](image/1695379109107.png)

![DQL语句](image/1695379617211.png)

#### DCL

##### DCL-介绍

- DCL英文全称是Data Control Language(数据控制语言)，用来**管理数据库用户、控制数据库的访问权限**。

##### DCL-管理用户

1. 查询用户

```MYSQL
USE mysql;
SELECT * FROM user;
```

2. 创建用户

```sql
CREATE USER '用户名'@'主机名' IDENTIFIED BY '密码';
```

3. 修改用户密码

```sql
ALTER USER '用户名'@'主机名' IDENTIFIED WITH mysql_native_password BY '新密码';
```

4. 删除用户

```sql
DROP USER '用户名'@'主机名';
```

```sql
-- DCL-管理用户
-- 1.创建用户 itcast，只能在当前主机 localhost 访问，密码123456
create user 'itcast'@'localhost' identified by '123456';

-- 2.创建用户 heima，可以在任意主机访问该数据库，密码123456
create user 'heima'@'%' identified by '123456';

-- 3.修改用户 heima 的访问密码 1234
alter user 'heima'@'%' identified with mysql_native_password by '1234';

-- 4.删除 itcast@localhost 用户
drop user 'itcast'@'localhost';
```

> 注意：
>
> - 主机名可以使用 `%`通配符
> - 这类 `SQL`开发人员操作的比较少，主要是 `DBA`(Database Administrator 数据库管理员)使用

##### DCL-权限控制

MySQL中定义了很多权限，但是常用的就以下几种：

| 权限                        | 说明               |
| --------------------------- | ------------------ |
| `ALL`, `ALL PRIVILEGES` | 所有权限           |
| `SELECT`                  | 查询数据           |
| `INSERT`                  | 插入数据           |
| `UPDATE`                  | 修改数据           |
| `DELETE`                  | 删除数据           |
| `ALTER`                   | 修改表             |
| `DROP`                    | 删除数据库/表/视图 |
| `CREATE`                  | 创建数据库/表      |

1. 查询权限

```sql
SHOW GRANTS FOR '用户名'@'主机名';
```

2. 授予权限

```sql
GRANT 权限列表 ON 数据库名.表名 TO '用户名'@'主机名';
```

5. 撤销权限

```sql
REVOKE 权限列表 ON 数据库名.表名 FROM '用户名'@'主机名';
```

> 注意：
>
> - 多个权限之间，使用逗号分隔
> - 授权时，数据库名和表名可以使用 `*` 进行通配，代表所有数据库/表

```sql
-- DCL-权限控制
-- 1.查询权限
show grants for 'heima'@'%';

-- 2.授予权限
grant all on test.* to 'heima'@'%';

-- 3.撤销权限
revoke all on test.* from 'heima'@'%';
```

**总结**

1. 用户管理

```sql
CREATE USER '用户名'@'主机名' IDENTIFIED BY 密码;
ALTER USER '用户名'@'主机名' IDENTIFIED WITH mysql_native_password BY 密码;
DROP USER '用户名'@'主机名';
```

2. 权限控制

```sql
SHOW GRANTS FOR '用户名'@'主机名';
GRANT 权限列表 ON 数据库.表 TO '用户名'@'主机名';
REVOKE 权限列表 ON 数据库.表 FROM '用户名'@'主机名';
```

### 函数

**函数**是指一段可以直接被另一段程序调用的程序或代码

#### 字符串函数

MySQL中内置了很多字符串函数，常用的几个如下：

| 函数                           | 功能                                                      |
| ------------------------------ | --------------------------------------------------------- |
| `CONCAT(S1,S2,...,Sn)`       | 字符串拼接，将S1,S2,...,Sn拼接成一个字符串                |
| `LOWER(str)`                 | 将字符串str全部转为小写                                   |
| `UPPER(str)`                 | 将字符串str全部转为大写                                   |
| `LPAD(str, n, pad)`          | 左填充，用字符串pad对str的左边进行填充，达到n个字符串长度 |
| `RPAD(str, n, pad)`          | 右填充，用字符串pad对str的右边进行填充，达到n个字符串长度 |
| `TRIM(str)`                  | 去掉字符串**头部**和**尾部**的空格            |
| `SUBSTRING(str, start, len)` | 返回从字符串str从start位置起的len个长度的字符串           |

> select 函数(参数);

```MySQL
------------ 函数演示 ---------------
-- concat
select concat('Hello', 'MySQL');	-- Hello MySQL
-- lower
select lower('Hello');	-- hello
-- upper
select upper('Hello');	-- HELLO
-- lpad
select lpad('01', 5, '-');	-- ---01	本身字符串'01'长度为2，填充3个'-'时长度为5
-- rpad
select rpad('01', 5, '-');	-- 01---
-- trim
select trim(' Hello  MySQL ');	-- 'Hello  MySQL'	加上''是为展示头尾部不存在空格
-- substring
select substring('Hello MySQL', 1, 5);	-- Hello 索引从1开始
```

```MySQL
----- 练习：根据需求完成以下SQL编写 -----
/* 由于业务需求变更，企业员工的工号，统一为5位数，目前不足5位数的全部在前面补0.比如：1号员工的工号应该为00001 */
update emp set workNo = lpad(workNo, 5, '0');	-- 修改
```

#### 数值函数

常见的数值函数如下：

| 函数            | 功能                               |
| --------------- | ---------------------------------- |
| `CEIL(x)`     | 向上取整                           |
| `FLOOR(x)`    | 向下取整                           |
| `MOD(x, y)`   | 返回 `x/y`的模                   |
| `RAND()`      | 返回 `0~1`内的随机数             |
| `ROUND(x, y)` | 求参数x的四舍五入的值，保留y位小数 |

```MySQL
----- 数值函数 -----
-- ceil
select ceil(1.1);	-- 2
-- floor
select floor(1.9);	-- 1
-- mod
select mod(10, 3);	-- 1
-- rand
select rand();		-- 0.132654545
-- round
select round(2.344, 2);	-- 2.34
```

```MySQL
--- 通过数据库的函数，生成一个六位数的随机验证码 -----
select rpad(round(rand()*1000000, 0), 6, '0');	-- 当rand()生成0.01989...可以通过补0达到六位数
```

#### 日期函数

常见的日期函数如下：

| 函数                                   | 功能                                                                                                                                      |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `CURDATE()`                          | 返回当前日期                                                                                                                              |
| `CURTIME()`                          | 返回当前时间                                                                                                                              |
| `NOW()`                              | 返回当前日期和时间                                                                                                                        |
| `TEAR(date)`                         | 获取指定date的年份                                                                                                                        |
| `MONTH(date)`                        | 获取指定date的月份                                                                                                                        |
| `DAY(date)`                          | 获取指定date的日期                                                                                                                        |
| `DATE_ADD(date, INTERVAL expr type)` | 返回一个日期/时间值加上一个时间间隔 `expr`后的时间值<br />`INTERVAL`为固定写法<br />`TYPE`为日期单位，如 `DAY`,`MONTH`,`YEAR` |
| `DATEDIFF(date1, date2)`             | 返回起始时间date1和结束时间date2之间的天数                                                                                                |

```MySQL
----- 日期函数 -----
-- curdate
select curdate();	-- 2023-09-24
-- curtime
select curtime();	-- 22:36:37
-- now
select now();		-- 2023-09-24 22:36:55
-- year(), month(), day()
select year(now());	-- 2023
select month(now());	-- 09
select day(now());	-- 24
-- DATE_ADD(date, INTERVAL expr TYPE)
select date_add(now(), INTERVAL 70 YEAR);	-- 2073-09-24 22:39:40	往后推70年
-- DATEDIFF(date1, date2)
select datediff('2021-12-01', '2021-10-01');	-- 61	第一个时间减去第二个时间
```

```MySQL
----- 查询所有员工的入职天数，并根据入职天数倒序排序 -----
select name, datediff(curdate(), entryDate) as 'entrydays' from emp order by entrydays desc;
```

#### 流程函数

流程函数也是常用的一类函数，可以在SQL语句中实现条件筛选，从而提高语句的效率。

| 函数                                                          | 功能                                                     |
| ------------------------------------------------------------- | -------------------------------------------------------- |
| `IF(value, t, f)`                                           | 如果value为true，则返回t，否则返回f                      |
| `IFNULL(value1, value2)`                                    | 如果value1不为空，返回value1，否则返回value2             |
| `CASE WHEN [val1] THEN [res1] ...ELSE [default] END`        | 如果val1为true，返回res1，...否则返回default默认值       |
| `CASE [expr] WHEN [val1] THEN [res1] ...ELSE [default] END` | 如果expr的值等于val1，返回res1，...否则返回default默认值 |

```MySQL
----- 流程返回函数 -----
-- if
select if(false, 'OK', 'Error');	-- Error
-- ifnull
select ifnull('OK', 'Default');		-- OK
select ifnull('', 'Default');	-- '' 空字符串
select ifnull(null, 'Default');		-- Default
-- case when then else
-- 需求：查询emp表的员工姓名和工作地址（北京/上海 ---> 一线城市，其他 ---> 二线城市）
select
	name,
	(case workAddress when '北京' then '一线城市' when '上海' then '一线城市' else '二线城市' end) as '工作地址'
from emp;

-- 案例：统计班级各个学员的成绩，展示的规则如下：
-- >= 85，展示优秀
-- >= 60，展示及格
-- 否则，展示不合格
create table student(
	id int comment '学号',
	name varchar(10) comment '姓名',
	score tinyint unsigned comment '总分'
) comment '学生表';

insert into student values
	(1, '张三', 59),
	(2, '李华', 86),
	(3, '小明', 77),
	(4, '小美', 80);

select
	id,
	name,
	(case when score >= 85 when '优秀' when score >= 60 then '及格' else '不及格' end) as '成绩'
from student;

```

#### 总结

1. 字符串函数
   - `CONCAT LOWER UPPER LPAD RPAD TRIM SUBSTRING`
2. 数值函数
   - `CEIL FLOOR MOD RADN ROUND`
3. 日期函数
   - `CURDATE CURTIME NOW YEAR MONTH DAY DATE_ADD DATEDIFF`
4. 流程函数
   - `IF; IFNULL; CASE [...] WHEN ... THEN ... ELSE ... END;`

### 约束

#### 概述

1. 概念：约束是作用于表中字段上的规则，用于限制存储在表中的数据
2. 目的：保证数据库中数据的正确性、有效性和完整性。
3. 分类：

| 约束                     | 描述                                               | 关键字          |
| ------------------------ | -------------------------------------------------- | --------------- |
| 非空约束                 | 限制该字段的数据不能为 `null`                    | `NOT NULL`    |
| 唯一约束                 | 保证该字段的所有数据都是唯一、不重复的             | `UNIQUE`      |
| 主键约束                 | **主键是一行数据的唯一标识，要求非空且唯一** | `PRIMARY KEY` |
| 默认约束                 | 保存数据时，如果未指定该字段的值，则采用默认值     | `DEFAULT`     |
| 检查约束(8.0.16版本之后) | 保证该字段值满足某一条件                           | `CHECK`       |
| 外键约束                 | 用来让两张表之间建立连接，保证数据的一致性和完整性 | `FOREIGN KEY` |

> 注意：约束时作用于表中字段上的，可以在创建表/修改表的时候添加约束。

#### 约束演示

案例：根据需求，完成表结构的创建

| 字段名     | 字段含义   | 字段类型        | 约束条件                  | 约束关键字                        |
| ---------- | ---------- | --------------- | ------------------------- | --------------------------------- |
| `id`     | ID唯一标识 | `int`         | 主键，并且自动增长        | `PRIMARY KEY    AUTO_INCREMENT` |
| `name`   | 姓名       | `varchar(10)` | 不为空，并且唯一          | `NOT NULL    UNIQUE`            |
| `age`    | 年龄       | `int`         | 大于0，并且小于等于120    | `CHECK`                         |
| `status` | 状态       | `char(1)`     | 如果没有指定该值，默认为1 | `DEFAULT`                       |
| `gender` | 性别       | `char(1)`     | 无                        |                                   |

```MySQL
----- 约束展示 -----
create table user(
	id int primary key auto_increment comment 'ID唯一标识',
	name varchar(10) not null unique comment '姓名',
	age int check(age > 0 and age <= 120) comment '年龄',
	status char(1) default '1' comment '状态',
	gender char(1) comment '性别'
) comment '用户表';

-- 插入数据
insert into user (name, age, status, gender) values ('Tom1', 19, '1', '男'), ('Tom2', 25, '0', '男');
insert into user (name, age, status, gender) values ('Tom3', 20, '0', '男');

```

#### 外键约束

- 概念
  - 外键是用来让两张表的数据之间建立连接，从而保证数据的一致性和完整性

![1695624366218](image/1695624366218.png)

> 注意：目前上述两张表，在数据库层面，并未建立外键关联，所以时无法保证数据的一致性和完整性的。

```MySQL
----- 约束（外键） -----
-- 准备数据
create table dept(
	id int auto_increment comment 'ID' primary key,
	name varchar(50) not null comment '部门名称'
);

INSERT INTO dept (id, name) VALUES (1, '研发部'), (2, '市场部'), (3, '财务部'), (4, '销售部'), (5, '总经办');

create table emp(
	id int auto_increment comment 'ID' primary key,
	name varchar(50) not null comment '姓名',
	age int comment '年龄',
	job varchar(20) comment '职位',
	salary int comment '薪资',
	entrydate date comment '入职时间',
	managerid int comment '直属领导ID',
	dept_id int comment '部门ID'
) comment '员工表';

INSERT INTO emp (id, name, age, job, salary, entrydate, managerid, dept_id) VALUES
	(1, '金庸', 66, '总裁', 20000, '2000-01-01', null, 5), (2, '张无忌', 20, '项目经理', 12500, '2005-12-05', 1, 1),
	(3, '杨逍', 33, '开发', 8400, '2000-11-03', 2, 1), (4, '韦一笑', 48, '开发', 11000, '2002-02-05', 2, 1),
	(5, '常遇春', 43, '开发', 10500, '2004-09-07', 3, 1), (6, '小昭', 19, '程序员鼓励师', 6600, '2004-10-12', 2, 1);
```

- 语法
  - 添加外键

```MySQL
-- 1.在创建表时
CREATE 表名(
	字段名 数据类型,
	...
	[CONSRRAINT] [外键名称] FOREIGN KEY (外键字段名) REFERENCES 主表(主表列名)
);

-- 2.在创建表后
ALTER TABLE 表名 ADD CONSTRAINT 外键名称 FOREIGN KEY (外键字段名) REFERENCES 主表(主表列名);
```

- 删除外键
  `ALTER TABLE 表名 DROP FOREIGN KEY 外键名称;`

```MySQL
-- 添加外键
alter table emp add constraint fk_emp_dept_id foreign key (dept_id) references dept(id);

-- 删除外键
alter table emp drop foreign key fk_emp_dept_id;
```

- 删除/更新行为

| 行为            | 说明                                                                                                                                |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `NO ACTION`   | 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除/更新。(与 `RESTRICT`一致)                         |
| `RESTRICT`    | 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，**如果有则不允许删除/更新**。(与 `NO ACTION`一致)              |
| `CASCADE`     | 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有，则也删除/更新外键在子表中的记录。                              |
| `SET NULL`    | 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有则设置子表中该外键值为 `null`(这就要求该外键允许取 `null`)。 |
| `SET DEFAULT` | 父表有变更时，子表将外键列设置称一个默认的值(`Innodb`不支持)                                                                      |

```MySQL
-- 删除/更新行为
ALTER TABLE 表名 ADD CONSTRAINT 外键名称 FOREIGN KEY (外键字段) REFERENCES 主表名(主表字段名) ON UPDATE CASCADE ON DELETE CASCADE;

alter table emp add constraint fk_emp_dept_id foreign key (dept_id) references dept(id) on update set null on delete set null;
```

#### 总结

1. 非空约束：`NOT NULL`
2. 唯一约束：`UNIQUE`
3. 主键约束：`PRIMARY KEY` (自增：`AUTO_INCREMENT`)
4. 默认约束：`DEFAULT`
5. 检查约束：`CHECK`
6. 外键约束：`FOREIGN KEY`

### 多表查询

#### 多表关系

- 概述

项目开发中，在进行数据库表结构设计时，会根据业务需求及业务模块之间的关系，分析并设计表结构，由于业务之间相互关联，所以各个表结构之间也存在着各种联系，基本上分为三种：

| 一对多（多对一） | 多对多 | 一对一 |
| ---------------- | ------ | ------ |

- **一对多（多对一）**

> 案例：部门与员工的关系
>
> 关系：一个部门对应多个员工，一个员工对应一个部门
>
> 实现：**在多的一方建立外键，指向一的一方的主键**

![1695628271442](image/1695628271442.png)

- **多对多**

> 案例：学生 与 课程的关系
>
> 关系：一个学生可以选修多门课程，一门课程也可以供多个学生选择
>
> 实现：**建立第三张中间表，中间表至少包含两个外键，分别关联两方主键**

![1695628347135](image/1695628347135.png)

> 右键 `student_course`->`Diagrams`->`Show Diagram...`可视化多表关系

![1695629373126](image/1695629373126.png)

- 一对一

> 案例：用户 与 用户 详情的关系
>
> 关系：一对一关系，多用于单表拆分，将一张表的基础字段放在一张表中，其他详情字段放在另一张表中，以提升操作效率。
>
> 实现：**在任意一方加入外键，关联另外一方的主键，并设置外键为唯一的(`UNIQUE`)**

| ![1695629531351](image/1695629531351.png) |
| --------------------------------------- |
| ![1695629607099](image/1695629607099.png) |

```MySQL
-- 一对一
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
```

#### 多表查询概述

- 概述：指从多张表中查询数据
- 笛卡尔积：笛卡尔乘积是指在数学上，两个集合A集合和B集合的所有组合情况。(在多表查询时，需要消除无效的笛卡尔积)

![1695638571020](image/1695638571020.png)

```MySQL
-- 多表查询 --
select * from emp, dept;	-- 产生笛卡尔积，包含无效查询
select * from emp, dept where dept_id = dept.id;
```

- 多表查询分类
  - 连接查询
    - 内连接：相当于查询A、B交集部分数据
    - 外连接：
      - 左外连接：查询**左表**所有数据，包含两张表交集部分数据
      - 右外连接：查询**右表**所有数据，包含两张表交集部分数据
    - 自连接：当前表与自身的连接查询，**自连接必须使用表别名**
  - 子查询
  - ![1695638993351](image/1695638993351.png)

#### 内连接

**内连接查询的是两张表交集的部分**

内连接查询语法：

- 隐式内连接

```MySQL
SELECT 字段列表 FROM 表1, 表2 WHERE 条件...;
```

- 显式内连接

```MySQL
SELECT 字段列表 FROM 表1 [INNER] JOIN 表2 ON 连接条件...;
```

```MySQL
-- 内连接演示
-- 1.查询每一个员工的姓名，及关联的部门的名称（隐式内连接完成）
-- 表结构：emp, dept
-- 连接条件：emp.dept_id = dept.id
select e.name, d.name from emp e, dept d where e.dept_id = d.id;    -- 取别名后，必须使用别名获取字段

-- 2.查询每一个员工的姓名，及关联的部门的名称（显式内连接完成）
select emp.name, dept.name from emp inner join dept on emp.dept_id = dept.id;    -- 也可以同上进行取别名

```

#### 外连接

外连接查询语法：

- 左外连接

```MySQL
SELECT 字段列表 FROM 表1 LEFT [OUTER] JOIN 表2 ON 条件...;
```

> 相当于查询表1(左表)的所有数据 包含 表1和表2交集部分的数据

- 右外连接

```MySQL
SELECT 字段列表 FROM 表1 RIGHT [OUTER] JOIN 表2 ON 条件...;
```

> 相当于查询表2(右表)的所有数据 包含 表1和表2交集部分的数据

```MySQL
-- ----- 外连接演示 ----- --
-- 1.查询emp表的所有数据，和对应的部门信息（左外连接）
-- 表结构：emp，dept
select emp.*, dept.name from emp left outer join dept on emp.dept_id = dept.id;

-- 2.查询dept表的所有数据，和对应的员工信息（右外连接）
select d.*, e.* from emp e right outer join dept d on e.dept_id = d.id;

select d.*, e.* from dept d left outer join emp e on d.id = e.dept_id;  -- 与上添加
```

#### 自连接

自连接查询语法：

```MySQL
SELECT 字段列表 FROM 表A 别名A JOIN 表A 别名B ON 条件 ..;
```

> **自连接查询，可以是内连接查询，也可以是外连接查询。**

```MySQL
-- 自连接
-- 1.查询员工 及其 所属领导的姓名
-- 表结构：emp 将emp表看成两张表a, b
select a.name, b.name from emp a, emp b where a.managerId = b.id;   -- 使用内连接，查询交集内容
select a.name, b.name from emp a inner join emp b on a.managerId = b.id;    -- 与上等价

-- 2.查询所有员工 emp 及其领导的名字 emp，如果员工没有领导，也需要查询出来
select a.name, b.name from emp a left outer join emp b on a.managerId = b.id;   -- 使用外连接，查询所有内容
```

#### 联合查询-union, union all

对于 `union`查询，就是把多次查询的结果合并起来，形成一个新的查询结果集。

```MySQL
SELECT 字段列表 FROM 表A ...
UNION [ALL]
SELECT 字段列表 FROM 表B ...;
```

```MySQL
-- union all, union
-- 1.将 薪资低于5000 的员工，和 年龄大于50岁 的员工全部查询出来
select * from emp where salary < 5000
union all
select * from emp where age > 50;

-- 去除重复值
select * from emp where salary < 5000
union
select * from emp where age > 50;
```

> **对于联合查询的多张表的列数必须保持一致，字段类型也必须保持一致。**
>
> `union all`会将全部的数据直接合并在一起，`union`会对合并之后的数据去重。

#### 子查询

- 概念：SQL语句中嵌套SELECT语句，称为**嵌套查询**，又称**子查询**

```MySQL
SELECT * FROM t1 WHERE column1 = (SELECT column1 FROM t2);
```

> 子查询外部的语句可以是 `INSERT/UPDATE/DELETE/SELECT`的任何一个

- 根据子查询结果不同，分为：
  - 标量子查询（子查询结果为单个值）
  - 列子查询（子查询结果为一列）
  - 行子查询（子查询结果为一行）
  - 表子查询（子查询结果为多行多列）
- 根据子查询位置，分为 `WHERE`之后，`FROM`之后，`SELECT`之后


- 标量子查询
  - 子查询返回的结果是单个值（数字、字符串、日期等），最简单的形式，这种子查询称为**标量子查询**
  - 常用的操作符：`= <> > >= < <=`

```MySQL
-- ----- 子查询 ----- --
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

```

- 列子查询
  - 子查询的结果是一列（可以是多行），这种子查询称为列子查询
  - 常用的操作符：`IN, NOT IN, ANY, SOME, ALL`

| 操作符     | 描述                                                  |
| ---------- | ----------------------------------------------------- |
| `IN`     | 在指定的集合范围之内，多选一                          |
| `NOT IN` | 不在指定的集合范围之内                                |
| `ANY`    | 子查询返回列表中，有任意一个满足即可                  |
| `SOME`   | 与 `ANY`等同，使用 `SOME`的地方都可以使用 `ANY` |
| `ALL`    | 子查询返回列表的所有值都必须满足                      |

```MySQL
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
```

- 行子查询
  - 子查询返回的结果是一行（可以是多列），这种子查询称为行子查询
  - 常用的操作负：`=, <>, IN, NOT IN`

```MySQL
-- ----- 行子查询 ----- --
-- 1.查询与“张无忌”的薪资及直属领导相同的员工信息
-- a.查询张无忌的薪资及直属领导
select salary, managerId from emp where name = "张无忌";
-- b.查询员工
select * from emp where (salary, managerId) = (select salary, managerId from emp where name = "张无忌");

```

- 表子查询
  - 子查询返回的结果是多行多列，这种子查询称为表子查询
  - 常用的操作符：`IN`

```MySQL
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
```

#### 多表查询案例

![1695907942670](image/1695907942670.png)

```MySQL

```



4

### 事务

5

## 进阶篇

- 存储引擎
- 索引
- SQL优化
- 视图/存储过程/触发器
- 锁
- InnoD核心
- MySQL管理

## 运维篇

- 日志
- 主从复制
- 分库分表
- 读写分离
