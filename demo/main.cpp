#include "StudengtManager.h"

int main()
{
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
			// res = StuManager->selectStu();	// 查询所有数据
			res = StuManager->selectStu("where class = '01班'", "limit 2, 2");
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