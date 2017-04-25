# dbmod
Database modification script

# Currently supported features

## get
### Will read from selected column
Syntax is the following: `get table modifier1 modifier-value1 modifierN modifier-valueN column1 columnN`

Where modifier is any of the following: WHERE, AND, OR, IN and their corresponding NOT(such as WHERE NOT)
Where modifier-value is a declaration of a variable, such as `LastName='Smith'`

### Examples

Return all information about the user with id 5, if his name is Adam.<br>
`dbmod.sh "db" "get" "myTable" "WHERE" "id=5" "AND" "FirstName='Adam'" "*"`<br><br>

Return only id and lastname from any user named Ethan.<br>
`dbmod.sh "db" "get" "myTable" "WHERE" "FirstName='Ethan'" "id" "LastName"`<br><br>

## insert
### Will insert value(s) into column.
Syntax is the following: `insert Table column1 column2 columnN value1 value2 valueN`<br><br>

### Examples
Create a new entry containing address, first and lastname.<br>
`dbmod.sh "db" "insert" "myTable" "FirstName" "LastName" "Address" "John" "Smith" "387 6th Ave"`<br><br>

## update
### Will update information.
Syntax is the following: `update table modifier1 modifier-value1 modifier2 modifier-value2 modifierN modifier-valueN column1 column2 columnN value1 value2 valueN`


### Examples
Change username of a user with id 233 to 'Example'<br>
`dbmod.sh "myTable" "update" "test" "WHERE" "id=233" "Username='Example'"`


## delete
### Deletes specified information
Syntax is the following: `delete table modifier1 modifier-value1 modifier2 modifier-value2 modifierN modifier-valueN`

## createTable
### Creates table with given attributes
Syntax is the following: `createTable table "column1 datatype" "column2 datatype" "columnN datatype"`

### Examples
Create a table named 'Customers' with three columns: id(primary key), last and first name. <br>
`dbmod.sh "createTable" "Customers" "id INTEGER PRIMARY KEY" "FirstName TEXT" "LastName TEXT"`<br><br>

## prune
### drops specified table
Syntax is the following: `prune table`

## executeCustomQuery
### Will execute any query given.
Syntax should be formatted for sqlite3

## getTables
### lists tables in database

## getTableInfo
### lists information about specified table



