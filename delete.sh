#! /bin/bash
read -p "are you sure? y/n: " answer
if [[ $answer == y ]]; then
	read -p "enter the path of the folder: " path
	echo -e "choose one option:\n 1 - delete all contents of the folder.\n 2 - delete file of extension. \n"
	read option
	if [[ $option == 1 ]]; then
		du -sh "$path"
		cd "$path"
		echo  items to be deleted:
		num_of_items= ls -l | wc -l
		rm -r "$path"
	elif [[ $option == 2 ]]; then
		read -p "enter the extension: " extension
		cd "$path"
		rm *.$extension
	else
		echo error
	fi
fi
		
