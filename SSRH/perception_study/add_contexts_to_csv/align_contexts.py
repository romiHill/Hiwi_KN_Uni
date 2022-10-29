import csv
import re


REGEX_CONTEXT = re.compile('[^_]*_[^_]*_[^_]*(?=\.wav)')

def read_files():
    with open('contexts.csv', mode = 'r', newline='') as inFile:
        contexts = csv.reader(inFile, delimiter=';')
        contexts_dict = {}
        for row in contexts:
            key = row[1] + '_' + row[2]
            contexts_dict[key] = row[0]
    with open('filenames', mode = 'r', newline='') as inFile:
        filenames = []
        for row in inFile:
            row = row.strip('\n')
            filenames.append(row)
    
    return contexts_dict, filenames
    

def main():
    # read in contexts and filenames
    contexts_dict, filenames = read_files()

    with open('items_text.csv', mode = 'w') as outFile:
        out_csv_writer = csv.writer(outFile, delimiter=';')
        out_csv_writer.writerow(['name', 'type', 'content', 'alignment'])
        for filename in filenames:
            if filename == 'fakes':
                continue
            substring = re.search(REGEX_CONTEXT, filename).group(0)
            out_csv_writer.writerow([f'<{filename}>', 'text', f'<{contexts_dict[substring]}>', 'left'])


if __name__ == "__main__":
    main()