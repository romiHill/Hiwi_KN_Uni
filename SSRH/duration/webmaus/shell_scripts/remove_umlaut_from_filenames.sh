for file in ../annotations_as_txt/*; do 
    mv -- "$file" "${file//ä/ae}"
done

