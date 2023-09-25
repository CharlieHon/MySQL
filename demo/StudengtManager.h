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
	vector<Student> selectStu(const string& = "", const string &limit="");		// 查找
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