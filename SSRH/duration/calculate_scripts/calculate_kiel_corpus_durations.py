# ---------------------------------------------------------------------------- #
# ------ LIBRARIES ------ #
# ---------------------------------------------------------------------------- #
import re, os, sys
# import pandas as pd

from config import KIEL_CORPUS_PATH
from data_structures.Interval import Interval

# ---------------------------------------------------------------------------- #
# ------ COMPILE REGEX ------ #
# ---------------------------------------------------------------------------- #

IGNORE_IN_TRANSCRIPTION_REGEX = re.compile(r"(<\w*>|<%>|<:.*>|^&.*|[.,;?!%]|\w*:)")

TIER_TYPE_REGEX = re.compile(r"(kend|oend|hend)")
# ---------------------------------------------------------------------------- #
# ------ CLASSES ------ #
# ---------------------------------------------------------------------------- #

class WordDurations:
    """
    Class to store phoneme info based on word, syllable position, etc
    """
    def __init__(self, word, segment = '', realized_durations = '', basic = ''):
        self.word = str(word)
        self.segment = str(segment)
        self.realized_durations = list(realized_durations)
        self.basic = str(basic)
    def __repr__(self):
        return f"Word: {self.word}\tsegments: {self.segment}\trealized_durations:\n"
        

class RealizedDuration:
    """
    Class to store realization segment and their duration
    """
    def __init__(self, segment = '', duration = 0):
        self.segment = segment
        self.duration = duration
    def __str__(self):
        return f"\t\t\tsegment: {self.segment}\tduration: {self.duration}\n"

# ---------------------------------------------------------------------------- #


# ---------------------------------------------------------------------------- #
# ------ HELPER FUNCTIONS ------ #
# ---------------------------------------------------------------------------- #

def extract_elements_from_line(master_list: list, line_list: list, line: str):
    """
    Extract elements from line into the master list
    """
    for i in range(len(line_list)):
        if not re.fullmatch(IGNORE_IN_TRANSCRIPTION_REGEX, line_list[i]):
            master_list.append(line_list[i])
    return master_list

# ---------------------------------------------------------------------------- #

def change_flags(input_dict: dict, line: str):
    """
    change tier type dictionary, to keep track of current tier
    """
    # set all values in dictionary to False
    input_dict = dict.fromkeys(input_dict, False)
    if line.startswith('oend'):
        input_dict['segment_tier'] = True
    
    elif line.startswith('kend'):
        input_dict['realized_tier'] = True

    elif line.startswith('hend'):
        input_dict['duration_tier'] = True
        is_duration_tier = True
    
    return input_dict

# ---------------------------------------------------------------------------- #
def extract_durations_from_line(duration_tier, line, prev_start_time):
    """
    extract segment and its duration from line
    return duration tier (list of RealizedDurations objects) and the start time of the segment (float)
    """
    line_list = line.split()
    prev_duration = float(line_list[2]) - prev_start_time
    item = RealizedDuration()
    item = RealizedDuration(line_list[1], 0)
    if len(duration_tier) != 0:
        duration_tier[-1].duration = prev_duration
    duration_tier.append(item)
    prev_start_time = float(line_list[2])

    return duration_tier, prev_start_time

# ---------------------------------------------------------------------------- #

def link_realizations_and_durations(realized_tier, duration_tier):
    """
    link realization tier with duration information
    Input: list of strings, list of RealizedDurations objects
    Output: list of lists (per word) of RealizedDuration objects
    """
    output_list = []
    for i, element in enumerate(realized_tier):
        if ' ' in element:
            inner_list = []
            for item in element.split():
                for i, duration_info in enumerate(duration_tier):
                    if item in duration_info.segment:
                        inner_list.append(duration_info)
                        duration_tier = duration_tier[i:]
                        break
            output_list.append(inner_list)
        else:
            print(f'{file_name} has an uneven number of elements in realized tier and duration tier, please fix')
            sys.exit(1)
    return output_list, duration_tier

# ---------------------------------------------------------------------------- #

def read_input(in_folder_name = KIEL_CORPUS_PATH):
    """
    read in all .s1h files from folder as list of WordDuration objects
    """
    intervals = []
    for file_name in os.listdir(in_folder_name):
        if not file_name.endswith('.s1h'):
            continue

        with open(os.path.join(in_folder_name, file_name), 'r', encoding='utf8') as in_file:
            tier_type = {'orig_tier': False, 'segment_tier': False, 'realized_tier': False, 'duration_tier': False}
            
            original_tier = []
            segment_tier = []
            realized_tier = []
            duration_tier = []

            prev_start_time = 0
            
            word_durations = []
            
            for i, line in enumerate(in_file):
                if i == 1:
                    tier_type['orig_tier'] = True
                    orig_tier_list = line.strip('\n').rstrip(' ').split(' ')[2:]
                    original_tier = extract_elements_from_line(original_tier, orig_tier_list, line)

                elif re.search(TIER_TYPE_REGEX, line):
                    tier_type = change_flags(tier_type, line)

                elif tier_type['orig_tier']:
                    orig_tier_list = line.strip('\n').rstrip(' ').split(' ')[8:]
                    original_tier = extract_elements_from_line(original_tier, orig_tier_list, line)
                    print(line, orig_tier_list)

                elif tier_type['segment_tier']:
                    segment_tier_list = line.strip('\n').split(' ' * 2)[1:]
                    segment_tier = extract_elements_from_line(segment_tier, segment_tier_list, line)
                
                elif tier_type['realized_tier']:
                    realized_tier_list = line.strip('\n').split(' ' * 2)[1:]
                    realized_tier = extract_elements_from_line(realized_tier, realized_tier_list, line)

                elif tier_type['duration_tier']:
                    duration_tier, start_time = extract_durations_from_line(duration_tier, line, prev_start_time)
                    prev_start_time = start_time
        # link realized segments with their duration (so duration is associated with segment, and also the word position within the sentence)
        realizations_and_durations_tier, duration_tier = link_realizations_and_durations(realized_tier, duration_tier)

        # create list of WordDurations, which contains info on word, segment, and durations of each segment
        for item in list(zip(original_tier, segment_tier, realizations_and_durations_tier)):
            current_durations = WordDurations(word = item[0], segment = item[1], realized_durations = item[2])
            word_durations.append(current_durations)

    return word_durations

# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# ------ MAIN FUNCTION ------ #
# ---------------------------------------------------------------------------- #

def main():
    output = read_input()

    for word in output:
        print(word)
        for realized_durations in word.realized_durations:
            print(realized_durations)

# ---------------------------------------------------------------------------- #

if __name__ == "__main__":
    main()