# dbmod
Database modification script
<br>
<br>
This script is used to make database automation easier on small scale operations.
<br>
This script relies on sqlite3 and is not compatible with other variants of sql databases.

# Usage

## get
### Will read from selected column
Syntax is the following: `get table modifier1 modifier-value1 modifierN modifier-valueN column1 columnN`

Where modifier is any of the following: WHERE, AND, OR, IN and their corresponding NOT(such as WHERE NOT)
Where modifier-value is a declaration of a variable, such as `LastName='Smith'`

#### Examples

Return all information about the user with id 5, if his name is Adam.<br>
`dbmod.sh "database.db" "get" "myTable" "WHERE" "id=5" "AND" "FirstName='Adam'" "*"`<br><br>

Return only id and lastname from any user named Ethan.<br>
`dbmod.sh "database.db" "get" "myTable" "WHERE" "FirstName='Ethan'" "id" "LastName"`<br><br>

## insert
### Will insert value(s) into column.
Syntax is the following: `insert Table column1 column2 columnN value1 value2 valueN`<br><br>

#### Example
Create a new entry containing address, first and lastname.<br>
`dbmod.sh "database.db" "insert" "myTable" "FirstName" "LastName" "Address" "John" "Smith" "387 6th Ave"`<br><br>

## update
### Will update information.
Syntax is the following: `update table modifier1 modifier-value1 modifier2 modifier-value2 modifierN modifier-valueN column1 column2 columnN value1 value2 valueN`

Where modifier is any of the following: WHERE, AND, OR, IN and their corresponding NOT(such as WHERE NOT)
Where modifier-value is a declaration of a variable, such as `LastName='Smith'`

#### Example
Change username of a user with id 233 to 'Example'<br>
`dbmod.sh "database.db" "myTable" "update" "test" "WHERE" "id=233" "Username='Example'"`<br><br>


## delete
### Deletes specified information
Syntax is the following: `delete table modifier1 modifier-value1 modifier2 modifier-value2 modifierN modifier-valueN`

Where modifier is any of the following: WHERE, AND, OR, IN and their corresponding NOT(such as WHERE NOT)
Where modifier-value is a declaration of a variable, such as `LastName='Smith'`

#### Examples

Remove any entry where id equals 7.<br>
`dbmod.sh "database.db" "delete" "test" "WHERE" "id=7"`<br><br>

Remove any entry where first name equals John and last name equal Smith.<br>
`dbmod.sh "database.db" "delete" "test" "WHERE" "FirstName='John'" "AND" "LastName='Smith'"`<br><br>


## createTable
### Creates table with given attributes
Syntax is the following: `createTable table "column1 datatype" "column2 datatype" "columnN datatype"`

#### Example
Create a table named 'Customers' with three columns: id(primary key), last and first name. <br>
`dbmod.sh "database.db" "createTable" "Customers" "id INTEGER PRIMARY KEY" "FirstName TEXT" "LastName TEXT"`<br><br>

## prune
### drops specified table
Syntax is the following: `prune table`

#### Example
Drop the table Customers<br>
`dbmod.sh "database.db" "myTable" "prune" "Customers"`<br><br>

## executeCustomQuery
### Will execute any query given.
Syntax should be formatted for sqlite3

#### Example
List everything from Customers<br>
`dbmod.sh "database.db" "executeCustomQuery" "SELECT * FROM myTable"`<br><br>

## getTables
### lists tables in database
This function uses no input (other than database path)
Lists all tables in database whitespace separated.


#### Example
Get tables from <br>
`dbmod.sh "database.db"`<br><br>

## getTableInfo
### lists information about specified table
Syntax is the following: `getTableInfo table`
Lists information about all columns in an table.

#### Examples
Get info about the table myTable<br>
`dbmod.sh "database.db" "getTableInfo" "myTable"`<br><br>


# Exit codes
<br>
0: Everything went well<br>
1: Unknown function called in main<br>
2: No database path supplied<br>

