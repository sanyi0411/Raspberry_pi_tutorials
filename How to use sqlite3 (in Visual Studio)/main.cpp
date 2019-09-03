#include "sqlite3.h"
#include <iostream>
#include <time.h>

static int callback(void *data, int argc, char **argv, char **azColName)
{
	for (int i = 0; i < argc; i++)
	{
		std::cout << azColName[i] << "\t" << argv[i] ? argv[i] : "NULL";
		std::cout << std::endl;
	}
	return 0;
}

int main()
{
	/*Opening database file*/
	/*If it does not exist, it will create a new one*/
	sqlite3 *dataBase;
	std::string dbPath = "myDB.db";

	int errorCode = sqlite3_open(dbPath.c_str(), &dataBase);

	if (errorCode != SQLITE_OK) {
		std::cerr << "Can't open database: " << sqlite3_errmsg(dataBase) << std::endl;
	}
	else {
		std::cout << "Success opening database\n";
	}

	/*Create a new table*/
	char *errorMessage;
	std::string createTable = R"(
        CREATE TABLE IF NOT EXISTS myFirstTable(
            id              INTEGER    PRIMARY KEY AUTOINCREMENT,
            name            TEXT       NOT NULL,
	    code	    INTEGER    NOT NULL,
	    added           DATETIME   NOT NULL,
            UNIQUE(name));)";

	errorCode = sqlite3_exec(dataBase, createTable.c_str(), callback, nullptr, &errorMessage);

	if (errorCode != SQLITE_OK) {
		std::cerr << "Can't create table: " << sqlite3_errmsg(dataBase) << std::endl;
	}
	else {
		std::cout << "Success creating table\n";
	}

	/*Insert data into existing table*/
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
	
	/*Read data from database*/
	std::string mySelect = "SELECT * FROM myFirstTable";
	errorCode = sqlite3_exec(dataBase, mySelect.c_str(), callback, nullptr, nullptr);

	sqlite3_close(dataBase);

	return 0;
}
