#!/bin/bash

echo "These are the files by size bigger to smaller"
ls -lhS | awk 'NR>1 {print $5, $9}' | while read size file; do
        echo "$file, $size"
done

sort_files_extensions_count=$(ls -X | sed 's/.*\.//' | sort | uniq -c )
list_file_extensions=$(ls -X | sed 's/.*\.//' | sort | uniq )


echo "The counted files and total size by extension are:"
declare -A extensions
for ext in $list_file_extensions; do
	extensions[$ext]=0
done

while read size file; do
	ext=$(echo "$file" | sed 's/.*\.//')
	extensions[$ext]=$((extensions[$ext] + size))
done < <(ls -lhS | awk 'NR>1 {print $5, $9}')

while read count file_extension; do
	echo "$count .$file_extension ${extensions[$file_extension]} MB"
done <<< "$sort_files_extensions_count"

echo "The total size of the folder is by du"
folder_total_size=$(du -sk | awk '{print $1}')
echo "The total size using
echo $folder_total_size
