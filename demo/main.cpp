#include "StudengtManager.h"

int main()
{

	Student stu1{10, "小昭", "03班"};
	StudentManager::GetInstance()->updateStu(stu1);	// 修改指定id数据
	
	Student stu2{ 11, "韩信", "04班" };
	// StudentManager::GetInstance()->insertStu(stu2);	// 插入数据，id不能重复

	StudentManager::GetInstance()->deleteStu(stu2.Id);	// 根据id，删除数据

	// 查询
	auto res = StudentManager::GetInstance()->selectStu();
	for (const auto& s : res) {
		cout << "学号：" << s.Id << " 姓名：" << s.Name
			<< " 班级：" << s.Class << endl;
	}

	return 0;
}