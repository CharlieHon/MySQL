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
