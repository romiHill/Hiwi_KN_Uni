for file in *.wav.txt; do 
    echo mv -- "$file" "${file%.wav.txt}.txt"
done
