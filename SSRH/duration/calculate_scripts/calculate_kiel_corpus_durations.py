import re, os, sys
# import pandas as pd

from config import KIEL_CORPUS_PATH
from data_structures.Interval import Interval

# ---------------------------------------------------------------------------- #

class WordDurations:
    """
    Class to store phoneme info based on word, syllable position, etc
    """
    def __init__(self, word, segment = '', realization = '', basic = ''):
        self.word = str(word)
        self.segment = str(segment)
        self.realization = str(realization)
        self.basic = str(basic)
    def __str__(self):
        return f"Word: {self.word}\tsegment: {self.segment}\trealization: {self.realization}"
        

class Realization:
    """
    Class to store realization segment and their duration
    """
    def __init__(self, element = '', duration = 0):
        self.element = element
        self.duration = duration
    def __str__(self):
        return f"element: {self.element}\tduration: {self.duration}"

# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
def extract_elements_from_line(master_list: list, line_list: list, line: str):
    """
    Extract elements from line into the master list
    """
    for i in range(len(line_list)):
        if "%" not in line_list[i] and "&" not in line_list[i]:
            master_list.append(line_list[i])
    return master_list


def read_input(in_folder_name = KIEL_CORPUS_PATH):
    """
    read in all .s1h files from folder as list of WordDuration objects
    """
    intervals = []
    for file_name in os.listdir(in_folder_name):
        if not file_name.endswith('.s1h'):
            continue

        with open(os.path.join(in_folder_name, file_name), 'r', encoding='utf8') as in_file:
            is_orig_tier = False
            is_segment_tier = False
            is_realized_tier = False
            is_duration_tier = False
            
            original_tier = []
            segment_tier = []
            realized_tier = []
            duration_tier = {}
            
            word_durations = []
            
            for i, line in enumerate(in_file):
                if i == 1:
                    is_orig_tier = True
                    orig_tier_list = line.strip('\n').rstrip(' ').split(' ')[2:]

                    original_tier = extract_elements_from_line(original_tier, orig_tier_list, line)

                        
                elif line.startswith('oend'):
                    is_orig_tier = False
                    is_segment_tier = True
                
                elif line.startswith('kend'):
                    is_segment_tier = False
                    is_realized_tier = True

                elif line.startswith('hend'):
                    is_realized_tier = False
                    is_duration_tier = True
                    
                    
                elif is_orig_tier:
                    orig_tier_list = line.strip('\n').rstrip(' ').split(' ')[8:]
                    original_tier = extract_elements_from_line(original_tier, orig_tier_list, line)

                elif is_segment_tier:
                    segment_tier_list = line.strip('\n').split(' ' * 2)[1:]
                    segment_tier = extract_elements_from_line(segment_tier, segment_tier_list, line)
                
                elif is_realized_tier:
                    realized_tier_list = line.strip('\n').split(' ' * 2)[1:]
                    realized_tier = extract_elements_from_line(realized_tier, realized_tier_list, line)

                elif is_duration_tier:
                    line_list = line.split()
                    item = Realization()
                    item = Realization(element, duration_tier[element])
                    duration_tier.append(item)

        new_realization_tier = []
        # to do: fill the realized tier with duration info extracted from duration_tier
        for i, element in duration_tier:
            print(realized_tier)
            item = Realization(element, duration_tier[element])

            new_realization_tier.append(item)
        for item in list(zip(original_tier, segment_tier, new_realization_tier)):
            current_durations = WordDurations(word = item[0], segment = item[1], realization = item[2])
            word_durations.append(current_durations)
        

    return word_durations

# ---------------------------------------------------------------------------- #

output = read_input()


for item in output:
    print(item)
