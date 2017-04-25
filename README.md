# dbmod
Database modification script

# Currently supported features

## get
### Will read from selected column
Syntax is the following: `get table modifier1 modifier-value1 modifierN modifier-valueN column1 columnN`

Where modifier is any of the following: WHERE, AND, OR, IN and their corresponding NOT(such as WHERE NOT)
Where modifier-value is a declaration of a variable, such as `LastName='Smith'`

Example: `dbmod.sh "db" "get" "myTable" "WHERE" "id=5" "AND" "FirstName='Adam'" "*"`<br>
Example: `dbmod.sh "db" "get" "myTable" "WHERE" "FirstName='Ethan'" "id" "LastName"`

## insert
### Will insert value(s) into column.
Syntax is the following: `insert table column1 column2 columnN value1 value2 valueN`

Example: `dbmod.sh "db" "insert" "test" "FirstName" "LastName" "Address" "John" "Smith" "387 6th Ave"`

## update
### Will update information.
Syntax is the following: `update table modifier1 modifier-value1 modifier2 modifier-value2 modifierN modifier-valueN column1 column2 columnN value1 value2 valueN`

## delete
### Deletes specified information

## executeCustomQuery
### Will execute any query given.

## createTable
### Creates table with given attributes

## prune
### drops specified table

## getTables
### lists tables in database

## getTableInfo
### lists information about specified table



