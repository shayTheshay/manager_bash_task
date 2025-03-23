#!/bin/bash
#Enter a file
read -p "Enter a file: " file
#a) check if the file exist and print line by line
        if [[ -f "$file" ]]; then
        awk '{print NR": "$0}' "$file"
#b) Count the lines 
        echo "in $file you have $(wc -l < "$file") total lines"
#	word number
	echo "in $file you have $(wc -w < "$file") total words"
#       total file size
        echo "file size: $(du -h "$file" | cut -f1)"
#2c) adding search term
read -p "enter search term: " search_term
found=0
#search the search_term 
awk -v term="$search_term" '{
		for (i=1; i<=NF; i++) {
		if ($i == term) {
		   print "true, word num " i " line " NR
	           found=1 
				 	}
				}
			     }
	END {
			if (found == 0) {
                                print "sorry sreach term was not found"
	    }
	    }' "$file"
else
	echo "file does not exist"	
                         fi
