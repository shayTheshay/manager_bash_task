#!/bin/bash

#This is part 1/{a,b,c/i/{1,2}}

#First function prints the 5 and 9 column for the size and file, bigger first
function file_size_desc {
	echo "These are the files by size bigger to smaller"
	ls -lhS | awk 'NR>1 {print $5, $9}' | while read size file; do #ls -lhS = listing by Size in Human like view with long listing
	        echo "$file, $size" #NR>1 only process lines where the line number of records(line number) is greater than 1, skips the first line "total ...something"
	done
}

function count_files_total_size {
	while read size file; do
	        ext=$(echo "$file" | sed 's/.*\.//') #extract only the extantions of the current file
		size_in_mb=$(echo "scale=6; $size / 1024 / 1024 " | bc) #We take the size, remember we need it in MB, we tke the byte we have and /1024/1024 -> scale=num means num numbers after point 
	        extensions[$ext]=$(echo "${extensions[$ext]} + $size_in_mb" | bc) #bc means evaluating by a calculator
	done < <(ls -lS | awk 'NR>1 {print $5, $9}')
	while read count file_extension; do
	        echo "$count .$file_extension ${extensions[$file_extension]} MB" #Showing How many files of type, the type, what size in mb does it have
	done <<< "$sort_files_extensions_count" #Takes it from this variable
}

function folder_total_size {
	echo "The total size of the folder by using du"
	folder_size=$(du -mhs | awk '{print $1}') #du check the data size -mhs mb human summaeize
	echo $folder_size
	size_number_folder=$(echo "$folder_size" | grep -o '[0-9.]*') #originally used grep with 0-9 but added the . because I found out it makes problems with the decimal point when taking bigger file with 1.3M or 0.7M, the point makes problem if it is not there
	k_m_g=$(echo "$folder_size" | grep -o '[KMG]') #I know these are the specific values I have so I took them inro the switch case, added k so it looks good
	case $k_m_g in
		K)
		size_number_folder=$(echo "$size_number_folder * 1" | bc)
		;;
		M)
		size_number_folder=$(echo "$size_number_folder * 1024" | bc)
		;;
		G)
		size_number_folder=$(echo "$size_number_folder * 1024 *1024" | bc)
		;;
	esac
	if (( $(echo "$size_number_folder > 500" | bc) )); then # I originally used [[ ]] but! because this is not integer it made problems with decimal points, the conclusion was to move to bc -> can handle mathematic float
		echo -e "Hey, please consider deleting some files using\na.Our delete script\nb.Compressing some files"
	fi
}

# The program actually starts from here and activates some functions
echo "Hi this is the utility script! Here you can get information about file sizes"
echo -e "Choose action: \n1.list files, sorted desc by size\n2.count files by extension and total size(X .txt Y MB)\n3.Show folder total size"
read -p "enter a number: " action_number

sort_files_extensions_count=$(ls -X | sed 's/.*\.//' | sort | uniq -c )
list_file_extensions=$(ls -X | sed 's/.*\.//' | sort | uniq )
# the sed s/.*.\// makes it so only the ending is kept without the dot=> jpg, txt

declare -A extensions  #We create a dynamic array so we can use the file extentions as keys, after that we run 
for ext in $list_file_extensions; do
	extensions[$ext]=0
done

if [[ "$action_number" =~ ^[0-9]+$ ]]; then #starts with a number between 0 and 9 -> + is can be more than one -> $ ends with 
	if [[ $action_number -eq 1 ]]; then
		file_size_desc #First task, gives the size of files in descending order 
	elif [[ $action_number -eq 2 ]]; then
		count_files_total_size #count the files in total by the file extensions
	elif [[ $action_number -eq 3 ]]; then
		folder_total_size # gives total size of files, if bigger than 300k ask if the user wants to compress/delete
	else
		echo "You are wrong about the number, no action selected"
	fi
else
	echo "Please try again later, you need to input a number"
fi
