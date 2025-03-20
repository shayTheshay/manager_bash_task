#!/bin/bash


echo "These are the files by size bigger to smaller"
ls -lhS | awk 'NR>1 {print $5, $9}' | while read size file; do
        echo "File:$file, Size:$size"
done

list_files_asc_size=$(ls -hS)

echo "----------------------"

sort_files_extensions_count=$(ls -X | sed 's/.*\.//' | sort | uniq -c )
echo "The count of files by extension is:"
echo $sort_files_extensions_count

echo "The files extensions total sizes are:"
list_file_extensions=$(ls -X | sed 's/.*\.//' | sort)

declare -A extensions

for ext in $list_file_extensions; do
	extension[$ext]=0
done
ls -lhS | awk 'NR>1 {print $5, $9}' | while read size file; do
	ext=$(echo "$file" | sed 's/.*\.//')
	extensions[$ext]=$((extensions[$ext] + size))
	
done

for ext in "${!extensions[@]}"; do
	echo "$ext: ${extensions[$ext]}"
done

echo "-----------------------"

echo "The total size of the folder is"
folder_total_size=$(du -sk | awk '{print $1}')

echo $folder_total_size
