# How to install sqlite3 with Visual Studio

For this tutorial I am using Visual Studio 2017 Community edition on Windows 10 64bit.<br/>
<br/>
I assume you already have Visual Studio downloaded and installed.

### Install vcpkg

- Create a new folder where you want to put the files
- In command line navigate into this folder
- Go to the vcpkg repo [here](https://github.com/microsoft/vcpkg) and clone it in this folder
- Run this command: `.\bootstrap-vcpkg.bat`
- You will see several new files created
- Run this command: `.\vcpkg integrate install`
- At this point vcpkg is installed and available for Visual Studio

### Install sqlite3

- To check if sqlite3 is available for install run: `.\vcpkg search sqlite3`
- If you see sqlite in the list run this: `.\vcpkg install sqlite3:x64-windows`
- If you need the 32bit version run: `.\vcpkg install sqlite3`

### Run SQL in your project

- Create a new project
- You should be able to `#include <sqlite3>`
- Run this code to test if it works ok:
```C++
#include <iostream>
#include <sqlite3.h>

int main() {
	sqlite3 *db;
	int fd = sqlite3_open("mydb.db", &db);

	if (fd == SQLITE_OK) {
		std::cout << "Success opening the database.\n";
	}
	else {
		std::cerr << "Error:\n";
		std::cerr << sqlite3_errmsg(db) << '\n';
		exit(1);
	}

	sqlite3_close(db);
}
```
