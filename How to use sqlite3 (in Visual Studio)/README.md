# How to use sqlite3 in C++

For this tutorial I am using Visual Studio 2017, on Windows 10 64bit.</br>
If you don't have Visual Studio or sqlite3 downloaded, check out [this](https://github.com/sanyi0411/Tutorials/tree/master/How%20to%20install%20sqlite3) tutorial.</br>
I will also include some screenshots where I use SQLite Studio to visualise the created database and the table within. You can download SQLite Studion [here](https://sqlitestudio.pl/index.rvt)

The full code is in the `main.cpp` but let's go through it step by step.

```C++
	sqlite3 *dataBase;
	std::string dbPath = "myDB.db";

	int errorCode = sqlite3_open(dbPath.c_str(), &dataBase);

	if (errorCode != SQLITE_OK) {
		std::cerr << "Can't open database: " << sqlite3_errmsg(dataBase) << std::endl;
	}
	else {
		std::cout << "Success opening database\n";
	}
```
This is how you open a database(.db) file. If it does not exist, it will be automatically created. The `sqlite3_open` function expects a `const char *` as the first argument, that is why we need to convert the string.</br>
This way the program will look for the .db file next to your main.cpp (or whichever file you are in). If it is somewhere else you can provide relative (e.g `../databases/myDB.db`) or absolute (e.g `D:/Project/myProject/databases/myDB.db`) path.</br>
The function returns an integer. If the database was opened succesfully it returns 0 (SQLITE_OK is defined 0).

```C++
	char *errorMessage;
	std::string createTable = R"(
        CREATE TABLE IF NOT EXISTS myFirstTable(
            id              INTEGER    PRIMARY KEY AUTOINCREMENT,
            name            TEXT       NOT NULL,
	    code    	    INTEGER    NOT NULL,
	    added	    DATETIME   NOT NULL,
            UNIQUE(name));)";

	errorCode = sqlite3_exec(dataBase, createTable.c_str(), callback, nullptr, &errorMessage);

	if (errorCode != SQLITE_OK) {
		std::cerr << "Can't create table: " << sqlite3_errmsg(dataBase) << std::endl;
	}
	else {
		std::cout << "Success creating table\n";
	}
```
To pass any query to sqlite you need to pass it as a string. Raw string literal starts with `R"`. The `sqlite3_exec` function executes the query, returns and integer (same as previously) and also gives back an error message if an error occured. We will talk about the `callback` function later.

```C++
	std::string name = "John Doe";

	const char *insertRun = R"(
        INSERT INTO myFirstTable (name, code, added)
        VALUES(?1, ?2, ?3);)";
	sqlite3_stmt *sqlStatement;

	errorCode = sqlite3_prepare_v2(dataBase, insertRun, -1, &sqlStatement, nullptr);
	if (errorCode) {
		std::cerr << "Can't prepare data: " << sqlite3_errmsg(dataBase) << std::endl;
	}
	else {
		std::cout << "Success preparing data\n";
	}

	sqlite3_bind_text(sqlStatement, 1, name.c_str(), -1, nullptr);
	sqlite3_bind_int(sqlStatement, 2, 123456);
	sqlite3_bind_int64(sqlStatement, 3, time(nullptr));

	errorCode = sqlite3_step(sqlStatement);
	if (errorCode != SQLITE_DONE) {
		std::cerr << "Can't insert data: " << sqlite3_errmsg(dataBase) << std::endl;
	}
	else {
		std::cout << "Success inserting data\n";
	}
```
Inserting data into a table is a bit tricky. We need to take measures against any "SQL Injection attacks". If you don't know what that is, please google it first. Here we are inserting only 3 values even though we have 4 columns. This is because the first column is set to `autoincrement`. The text of the query is now of type `const char *` (unlike in the previous step where it was std::string), so we don't need to call the `c_str()` method on it. I made this on purpose to show you a different way of doing it. We could have done it this way in the previous step too.</br>
In the text of the query the places for the actual data are left open. `?` marks these places. Then we need to prepare the data. This basically tells the program that anything will be inserted in those blank spaces in the next step, it must consider it as the data, not part of the query. This way we can evade any evil attacks.</br>
Then we bind the data to the query. For this you need to call type specific functions (as you can see in the code). To execute the final query we need to call the `sqlite3_step` function, not the `sqlite3_exec` as before. This also returns an integer but in case of a successful run a different value than `sqlite3_exec` so we need to check it against a different defined value.

```C++
static int callback(void *data, int argc, char **argv, char **azColName)
{
	for (int i = 0; i < argc; i++)
	{
		std::cout << azColName[i] << "\t" << argv[i] ? argv[i] : "NULL";
		std::cout << std::endl;
	}
	return 0;
}
```
To read data from the database we need a way to show/print the received data. For this we will use the callback function. The `void *data` parameter now (and usually) stays unused.

```C++
	std::string mySelect = "SELECT * FROM myFirstTable";
	errorCode = sqlite3_exec(dataBase, mySelect.c_str(), callback, nullptr, nullptr);

	sqlite3_close(dataBase);
```

After that, receiving data is pretty simple. In this step we don't need to worry about `injection attacks`.
