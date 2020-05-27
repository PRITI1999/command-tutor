#!/bin/bash

#This function picks a command randomly from the command array
generate_new_command(){

	#Generate a random number between 0 and noOfCommands
	randomNumber=$(($RANDOM%noOfCommands))

	#the random new Command
	newCommand=${commandArray[randomNumber]}
}

#This function extracts info from man page and prints it
manedit() {

	#Extract name section from man page
	name_sec=`man "$newCommand" |col -bx|awk -v S="NAME" '$0 ~ S{cap="true";} $0 !~ S && /^[A-Z ]+$/ {cap="false"} $0 !~ S && !/^[A-Z ]+$/ {if(cap == "true")print}'| head -5`
	
       	#Extract two lines of description from man page
	desc_sec=`man "$newCommand" |col -bx|awk -v S="DESCRIPTION" '$0 ~ S {cap="true";} $0 !~ S && /^[A-Z ]+$/ {cap="false"} $0 !~ S && !/^[A-Z ]+$/ {if(cap == "true")print}'|awk -vRS="." 'NR<=2' ORS="."| head -5  `
	
	#Print italic date
	echo -e "\e[1;3m\e[1;38m `date`\e[0m"

	#Print the command
	echo -e "\n\e[1;37m Let's have a look at\e[1;5m\e[1;39m $newCommand \e[0m\n"
	#Print the name Section 
	echo -e "\e[1;35m$name_sec\n" 

	#Print description
	echo -e "\e[1;47m\e[1;4m\e[1;31m Description \e[0m\n"
	echo -e "\e[1;36m$desc_sec \e[0m\n"
}

#command holds the list of files present in /usr/bin as string
command=`ls /usr/bin`

#Split the single string to an array{commandArray} containing list of files
commandArray=(${command})

#noOfCommands to hold the length of the array
noOfCommands=${#commandArray[@]}

generate_new_command

`man $newCommand&>/dev/null` 
status=$?

#Loop till man page exists for newCommand
while test $status -ne 0
do
	generate_new_command
	`man $newCommand&>/dev/null` 
	status=$?
done

manedit
