for file in *.wav.txt; do 
    mv -- "$file" "${file%.wav.txt}.txt"
done
