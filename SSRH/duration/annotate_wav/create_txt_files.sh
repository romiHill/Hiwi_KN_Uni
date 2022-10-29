#! /bin/bash
# in file separate is ;
while IFS=";" read -r name_col type_col content_col alignment_col
do
	echo ${content_col:1:${#content_col}-2} > ${name_col:1:${#name_col}-2}
# ignore header line
done < <(tail -n +2 items_text.csv)
