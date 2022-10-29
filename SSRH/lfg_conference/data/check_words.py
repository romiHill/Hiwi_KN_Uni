import re, sys

def extract_lexicon(filename):
    out_lst = []
    with open(filename, 'r') as in_file:
        is_in_lexicon = False
        for line in in_file:
            # check if we're in the lexicon section of the file
            if 'LEXICON' in line:
                is_in_lexicon = True
                continue
            # end lexicon section
            elif '----' in line:
                is_in_lexicon = False
            # extract word from lexicon
            if is_in_lexicon:
                match = re.match('[^\s"\.,]+', line)
                if match is not None:
                    out_lst.append(match.group(0))
    return out_lst

def words_to_set(filename):
    out_set = set()
    with open(filename, 'r') as in_file:
        for line in in_file:
            for word in line.split():
                out_set.add(word.strip('.,\n'))
    return out_set

def main():
    first_file = extract_lexicon('grammar-ver1.lfg')
    # first_file = words_to_set('sentences.txt')
    second_file = extract_lexicon('gendat.lfg')

    for word in second_file:
        if word not in first_file:
            print(word)


if __name__ == "__main__":
    main()