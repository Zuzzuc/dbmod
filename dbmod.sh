#!/bin/bash
# License: The MIT License (MIT)
# Author Zuzzuc https://github.com/Zuzzuc/
#
# This script is used to modify databases.

set -f # Note that noglob is active! Some regex operations might not work as intented.

# Exit codes

# 1=Unknown operation
# 2=No db path supplied


# Basic functions

sanitizeFilePath(){
	# Usage is $1, where $1 is the text to sanitize.
	echo "$1" | sed 's%\\%%g' | sed -e 's%[[:space:]]*$%%'
}

stripFromStringBeginning(){
	#Usage is $1 and $2, where $1 is the string to modify and $2 is the number of chars to remove
	echo "$1" | sed -E "s/^.{$2}//"
}

turnToUpperCase(){
	#Usage is $1, where $1 is the string to be converted to uppercase.
	echo "$1" | tr '[:lower:]' '[:upper:]'
}


# Pre exec var set
if [ "$1" != "" ];then
	db="$(sanitizeFilePath "$1")"
	if [ ! -f "$db" ];then
		touch "$db"
	fi
	shift # We dont need to use it anymore
else
	exit 2
fi


# Advanced functions

unsetAll(){
	# Unsets all commonly used variables. This is good to use if running this script inline.
	unset cols
	unset vals
	unset count
	unset dbexec
	unset modifier
	unset table
}

executeCustomQuery(){ 
	# Usage is $1, where $1 is the custom query to execute. 
	# This assumes the database path is already set in $db
	sqlite3 "$db" "$1"
}

createTable(){
	#Usage is $@, where $1 is the table name and each following arg is an column name(eg (id INTEGER PRIMARY KEY, f TEXT or l TEXT)
	# This assumes the database path is already set in $db
	# NOTE: This will format the input, since it is known to be columns.
	table="$1" && shift
	
	for i in "$@"; do
		if [ "$1" != "" ]; then
       		dbexec+=",$1"
       		shift
       	fi
    done
    dbexec="$(stripFromStringBeginning "$dbexec" "1")"

	sqlite3 "$db" "CREATE TABLE $table ($dbexec);"
	
}

insert(){
	# Usage is $@, where $1 is the table name and the remaining variables are the column names and values, in that order.
	# This assumes the database path is already set in $db
	# NOTE: This will format the input. It will shift past the table name, and will take the first half of the remaining arguments as column names, and the rest as values.
	table="$1" && shift
	
	count=0
	breaktime=$((${#@}/2))
		
	while [ $count -lt $breaktime ];do
		cols+=",$1"
		count=$(($count+1))
		shift
	done
	cols="$(stripFromStringBeginning "$cols" "1")"
	
	count=0
	while [ $count -lt $breaktime ];do
		vals+=",'$1'"
		count=$(($count+1))
		shift
	done
	vals="$(stripFromStringBeginning "$vals" "1")"

	sqlite3 "$db" "INSERT INTO $table ($cols) VALUES ($vals);"

}

get(){
	# Usage is $@, where $1 is the table, the following are conditions and its values and the rest is columns..
	# This means an example with the usage of where and or could look like this:
	## get "table" "WHERE" "id=5" "AND" "FirstName='Adam'" "*"
	### This will output all data from the user Adam if he has id 5.
	
		
	table="$1" && shift
	
	break=1
	while [ $break -ne 0 ];do
		
		if [ "$(turnToUpperCase "$1")" == "WHERE" ] || [ "$(turnToUpperCase "$1")" == "AND" ] || [ "$(turnToUpperCase "$1")" == "OR" ] || [ "$(turnToUpperCase "$1")" == "LIKE" ] ||[ "$(turnToUpperCase "$1")" == "WHERE NOT" ] || [ "$(turnToUpperCase "$1")" == "AND NOT" ] || [ "$(turnToUpperCase "$1")" == "OR NOT" ] || [ "$(turnToUpperCase "$1")" == "NOT LIKE" ];then
			modifier+="$1 $2 " 
			shift && shift
		# Make it so if it is 'IN', require next one to be fully prefixed, eg "('Kalmar', 'Uppsala')"
		elif [ "$(turnToUpperCase "$1")" == "IN" ];then
			modifier+="$1 $2 "
			shift && shift
		else
			break=0
		fi
	done
	
	for i in "$@"; do
		if [ "$1" != "" ]; then
       		cols+=",$1"
       		shift
       	fi
    done
	cols="$(stripFromStringBeginning "$cols" "1")"

	sqlite3 "$db" "SELECT $cols FROM $table $modifier;"

}

update(){
	# Usage is $@, where $1 is the table, the following are conditions and its values and the rest is columns.

	
	table="$1" && shift
	
	break=1
	while [ $break -ne 0 ];do
		
		if [ "$(turnToUpperCase "$1")" == "WHERE" ] || [ "$(turnToUpperCase "$1")" == "AND" ] || [ "$(turnToUpperCase "$1")" == "OR" ] || [ "$(turnToUpperCase "$1")" == "LIKE" ] ||[ "$(turnToUpperCase "$1")" == "WHERE NOT" ] || [ "$(turnToUpperCase "$1")" == "AND NOT" ] || [ "$(turnToUpperCase "$1")" == "OR NOT" ] || [ "$(turnToUpperCase "$1")" == "NOT LIKE" ];then
			modifier+="$1 $2 " 
			shift && shift
		# Make it so if it is 'IN', require next one to be fully prefixed, eg "('Kalmar', 'Uppsala')"
		elif [ "$(turnToUpperCase "$1")" == "IN" ];then
			modifier+="$1 $2 "
			shift && shift
		else
			break=0
		fi
	done
	
	for i in "$@"; do
		if [ "$1" != "" ]; then
       		vals+=",$1"
       		shift
       	fi
    done
	vals="$(stripFromStringBeginning "$vals" "1")"

	
	sqlite3 "$db" "UPDATE $table SET $vals $modifier;"
	
}

prune(){
	# Usage is $1, where $1 is the table to drop.
	
	sqlite3 "$db" "DROP TABLE $1;"
	
}

delete(){
	# Usage is $@, where $1 is the table, the following are conditions and its values.

	
	table="$1" && shift
	
	break=1
	while [ $break -ne 0 ];do
		
		if [ "$(turnToUpperCase "$1")" == "WHERE" ] || [ "$(turnToUpperCase "$1")" == "AND" ] || [ "$(turnToUpperCase "$1")" == "OR" ] || [ "$(turnToUpperCase "$1")" == "LIKE" ] ||[ "$(turnToUpperCase "$1")" == "WHERE NOT" ] || [ "$(turnToUpperCase "$1")" == "AND NOT" ] || [ "$(turnToUpperCase "$1")" == "OR NOT" ] || [ "$(turnToUpperCase "$1")" == "NOT LIKE" ];then
			modifier+="$1 $2 " 
			shift && shift
		elif [ "$(turnToUpperCase "$1")" == "IN" ];then
			modifier+="$1 $2 "
			shift && shift
		else
			break=0
		fi
	done

	echo will exec "$db" "DELETE FROM $table $modifier;"

	sqlite3 "$db" "DELETE FROM $table $modifier;"
	
}

getTableInfo(){
	# Usage is $1, where $1 is the table to look up
	sqlite3 "$db" "PRAGMA table_info($1);"
}

getTables(){
	# No input. 
	# Note that the output will be whitespace separerad. 
	sqlite3 "$db" ".tables"
}

# main
if [ "$1" == "get" ] || [ "$1" == "update" ] || [ "$1" == "insert" ] || [ "$1" == "createTable" ] || [ "$1" == "delete" ] || [ "$1" == "prune" ] || [ "$1" == "getTables" ] || [ "$1" == "getTableInfo" ] || [ "$1" == "executeCustomQuery" ];then
	"$@"
	unsetAll
else
	echo "'$1' is not a function"
	exit 1
fi