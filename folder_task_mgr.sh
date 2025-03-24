#!/bin/bash
folder_option="a"
while [[ $folder_option != 0 ]]
do
echo "WELCOME TO FOLDER MANAGER
========================="
echo ""     
echo "Please choose from following options:

     1.) Folder information (files list, extension summary, total size)
     2.) File reader (contents, counts and search functionality)
     3.) Folder delete functions (either whole or specific)

For quitting manager, please choose 0."
read folder_option
case $folder_option in
1 )
    ./utility.sh ; read ;;
2 )
    ./read.sh ; read ;;
3 )
    ./delete.sh ; read ;;
0 )
    exit 0 ;;
* )
    echo "Please choose only either one of the numbers 1, 2, 3." ; read ;;
esac
clear
done
