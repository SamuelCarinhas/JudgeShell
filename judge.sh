#!/bin/bash

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'
NO_COLOR='\033[0m'

clear
codeFile=$1

fileName=${codeFile%.*}
fileCreated=""

command=""

if [[ $codeFile == *.cpp ]]
then
	g++ $codeFile
	command="./a.out "
	fileCreated="a.out"
elif [[ $codeFile == *.c ]]
then
	gcc $codeFile
	command="./a.out "
	fileCreated="a.out"
elif [[ $codeFile == *.py ]]
then
	command="python3 $codeFile "
elif [[ $codeFile == *.java ]]
then
	javac $codeFile
	command="java $fileName"
	fileCreated="$fileName.class"
else
	echo "Your file extension is not supported."
fi

echo -e "${LIGHT_CYAN}[⏲️ ] ${ORANGE}Compiling $codeFile..."
sleep 0.5
echo -e "${LIGHT_CYAN}[✅] ${LIGHT_GREEN}$codeFile Compiled.${CYAN}"
sleep 2

clear


cat <<"EOF"
       _           _            
      | |         | |           
      | |_   _  __| | __ _  ___ 
  _   | | | | |/ _` |/ _` |/ _ \
 | |__| | |_| | (_| | (_| |  __/
  \____/ \__,_|\__,_|\__, |\___|
                      __/ |     
                     |___/      
                                                (   ) )
                                                 ) ( (    
   __          ____                    __      _______)_
  / /  __ __  / __/__ ___ _  __ _____ / /   '-|---------|  
 / _ \/ // / _\ \/ _ `/  ' \/ // / -_) /   ( C|/\/\/\/\/|
/_.__/\_, / /___/\_,_/_/_/_/\_,_/\__/_/     '-./\/\/\/\/|
     /___/                                    '_________'
                                               '-------'

EOF

i=0
for file in `ls ./dataset/*.in`
do
	start=`date +%s%N`
	$command < $file > sol.out
	end=`date +%s%N`
	elapsed=$((end-start))
	conversion=1000000000
	runtime=$(bc <<< "scale=3 ; $elapsed / $conversion")
	second="output"
	outputFile="${file/input/$second}"
	second=".out"
	outputFile="${outputFile/.in/$second}"
	result="${LIGHT_GREEN}[✓] Accepted"
	cmp --silent $outputFile sol.out || result="${LIGHT_RED}[✗] Wrong Answer"
	i=$((i+1))
	echo -e "${LIGHT_CYAN}[${YELLOW}$i${LIGHT_CYAN}] ${NO_COLOR}Running test case: ${ORANGE}${file#./dataset/} ${DARK_GRAY}| $result ${NO_COLOR}[${runtime}s]"
	cmp --silent $outputFile sol.out
	t=$?
	if [[ $t == 1 ]]
	then
		if [[ $2 == "-debug" ]]
		then
			echo -e "${LIGHT_GRAY}Expected Output:"
			cat $outputFile
			echo -e "${DARK_GRAY}----------------"
			echo -e "${LIGHT_GRAY}Given Output:"
			cat sol.out
		fi
	fi
done


if [[ $fileCreated != "" ]]
then
	rm $fileCreated
	rm sol.out
fi
