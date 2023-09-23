# C++连接MySQL数据库

## 1.使用SQL创建数据库

```sql
-- demo
create database if not exists test; -- 创建 test 如果数据库不存在
use test;       -- 转到 test数据库
show tables;    -- 查询当前数据库中所有表
create table student(   -- 创建学生表
    id int not null primary key comment '学号',
    name varchar(10) not null comment '姓名',
    class varchar(20) not null comment '班级'
) comment '学生表';
desc student;   -- 查看表信息
insert into student values (1, '张三', '01班'),
                           (2, '李四', '01班'),
                           (3, '王五', '01班'),
                           (4, '赵六', '01班'),
                           (5, '李自成', '02班'),
                           (6, '朱由检', '02班'),
                           (7, '皇太极', '02班'),
                           (8, '张无忌', '03班'),
                           (9, '常遇春', '03班');   -- 插入多条数据

-- TODO
-- 1.查询所有数据
SELECT * FROM student;

-- 2.删除id为6的数据
DELETE FROM student WHERE id = 6;

-- 3.插入数据
INSERT INTO student VALUES (10, '赵敏', '03班');

-- 4.修改id为8的数据
UPDATE student SET name = '张三丰' WHERE id = 8;
```

## 2. 结果展示

![1695433795153](image/README/1695433795153.png)

| 操作                                           | 结果                                           |
| ---------------------------------------------- | ---------------------------------------------- |
| ![1695433775284](image/README/1695433775284.png) | ![1695433782892](image/README/1695433782892.png) |
| ![1695433245209](image/README/1695433245209.png) | ![1695433906916](image/README/1695433906916.png) |
| ![img](image/README/1695433297296.png)           | ![1695433891635](image/README/1695433891635.png) |

## 3. 使用C++连接数据库

```cpp
/* StudentManager.h */
#pragma once
#include <mysql.h>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

struct Student {
	int Id;
	string Name;
	string Class;
};

class StudentManager {
public:
	StudentManager();
	~StudentManager();
	static StudentManager* GetInstance() {	// 单例模式
		static StudentManager StudentManager;
		return &StudentManager;
	}
public:
	bool insertStu(const Student&);	// 插入
	bool updateStu(const Student&);	// 修改
	bool deleteStu(const int&);		// 删除
	vector<Student> selectStu(const string& = "");		// 查找
	void showMenu();	// 显示菜单
private:
	MYSQL* con;
	const char* host = "127.0.0.1";	// IP地址
	const char* user = "root";	// 用户名
	const char* pw = "123456";	// 密码
	const char* database_name = "test";
	const int port = 3306;	// 端口号：默认3306
	const char* table_name = "student";
};
```

```cpp
/* StudentManager.cpp */
#include "StudengtManager.h"

StudentManager::StudentManager()
{
	con = mysql_init(NULL);
	// 设置字符编码
	mysql_options(con, MYSQL_SET_CHARSET_NAME, "GBK");
	if (!mysql_real_connect(con, host, user, pw, database_name, port, NULL, 0)) {	// 建立连接
		printf("%s\n", "Failed to connect...");
		exit(1);
	}
}

StudentManager::~StudentManager()
{
	mysql_close(con);	// 关闭连接
}

bool StudentManager::insertStu(const Student& stu)
{
	char sql[1024];
	sprintf_s(sql, "insert into %s values (%d, '%s', '%s');",	// 插入数据
		table_name, stu.Id, stu.Name.c_str(), stu.Class.c_str());

	if (mysql_query(con, sql)) {
		fprintf(stderr, "Failed to insert data: Error: %s\n",
			mysql_error(con));
		return false;
	}
	return true;
}

bool StudentManager::updateStu(const Student& stu)
{
	char sql[1024];
	sprintf_s(sql, "update %s set name = '%s', class = '%s' where id = %d;",
		table_name, stu.Name.c_str(), stu.Class.c_str(), stu.Id);

	if (mysql_query(con, sql)) {
		fprintf(stderr, "Failed to update data: Error: %s\n",
			mysql_error(con));
		return false;
	}
	return true;
}

bool StudentManager::deleteStu(const int &id)
{
	char sql[1024];
	sprintf_s(sql, "delete from %s where id = %d",
		table_name, id);

	if (mysql_query(con, sql)) {	// 成功返回0
		fprintf(stderr, "Failed to delete data: Error: %s\n",
			mysql_error(con));
		return false;
	}
	return true;
}

vector<Student> StudentManager::selectStu(const string& condition)
{
	vector<Student> stuList;
	char sql[1024];
	sprintf_s(sql, "select * from %s %s", table_name, condition.c_str());

	if (mysql_query(con, sql)) {
		fprintf(stderr, "Failed to select data: Error: %s\n",
			mysql_error(con));
		return {};
	}

	MYSQL_RES* res = mysql_store_result(con);	// 读取结果
	MYSQL_ROW row;
	while (row = mysql_fetch_row(res)) {	// 每一行数据
		Student Stu;
		Stu.Id = atoi(row[0]);	// string -> int
		Stu.Name = row[1];
		Stu.Class = row[2];
		stuList.push_back(Stu);
	}

	return stuList;
}

void StudentManager::showMenu()
{
	cout << "***************************" << endl;
	cout << "*****使用C++连接MySQL******" << endl;
	cout << "****** 1.查询所有数据 *****" << endl;
	cout << "****** 2.修改数据   *******" << endl;
	cout << "****** 3.插入数据   *******" << endl;
	cout << "****** 4.删除数据   *******" << endl;
	cout << "****** 0.退出程序  *******" << endl;
	cout << "**************************" << endl;
	cout << endl;
}


```

```cpp
/* main.cpp */
#include "StudengtManager.h"
int main()
{

	// Student stu1{10, "小昭", "03班"};
	// StudentManager::GetInstance()->updateStu(stu1);	// 修改指定id数据

	// Student stu2{ 11, "韩信", "04班" };
	// // StudentManager::GetInstance()->insertStu(stu2);	// 插入数据，id不能重复

	// StudentManager::GetInstance()->deleteStu(stu2.Id);	// 根据id，删除数据

	// // 查询
	// auto res = StudentManager::GetInstance()->selectStu();
	// for (const auto& s : res) {
	// 	cout << "学号：" << s.Id << " 姓名：" << s.Name
	// 		<< " 班级：" << s.Class << endl;
	// }

	auto StuManager = StudentManager::GetInstance();
	vector<Student> res;	// 查询结果
	Student stu;			// 一个Student对象
	int select = 0;
	while (true) {
		StuManager->showMenu();	// 显示菜单
		cout << "请输入您的选择：";
		cin >> select;
		switch (select)
		{
		case 1:
			res = StuManager->selectStu();	// 查询所有数据
			for (const auto& s : res) {
				cout << "学号：" << s.Id << " 姓名：" << s.Name
					<< " 班级：" << s.Class << endl;
			}
			system("pause");
			system("cls");
			break;
		case 2:
			cout << "请输入修改数据的信息（学号，姓名，班级）：" << endl;
			cin >> stu.Id >> stu.Name >> stu.Class;
			StuManager->updateStu(stu);
			system("pause");
			system("cls");
			break;
		case 3:
			cout << "请输入插入数据信息（学号不可重复）：" << endl;
			cin >> stu.Id >> stu.Name >> stu.Class;
			StuManager->insertStu(stu);
			system("pause");
			system("cls");
			break;
		case 4:
			cout << "根据学号删除指定数据：" << endl;
			int id;
			cin >> id;
			StuManager->deleteStu(id);
			system("pause");
			system("cls");
			break;
		case 0:
			cout << "欢迎下次使用" << endl;
			exit(0);
			break;
		default:
			break;
		}
	}

	return 0;
}
```
