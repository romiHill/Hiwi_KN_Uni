
"""
Calculate durations of segments
"""
# ------------------------------------------------------------------------ #
# ------------ LIBRARIES ------------ #
# ------------------------------------------------------------------------ #
import re, os, sys
import pandas as pd

from config import INPUT_PATH, PHONE_TIER

# ------------------------------------------------------------------------ #
# ------------ CLASSES ------------ #
# ------------------------------------------------------------------------ #

class Interval:
    """
    Class to store start point, end point, duration, and label of an interval
    """
    # to do: may need to add info about previous and following segment, 
    # ------ location of segment within word, syllable structure, etc
    def __init__(self, start_point = 0.0, end_point = 0.0, label = ""):
        self.start_point = float(start_point)
        self.end_point = float(end_point)
        self.duration = -1
        self.label = str(label)
    def calculate_duration(self):
        return (self.end_point - self.start_point)
    def __str__(self):
        return f'start_point: {self.start_point}\nend_point: {self.end_point}\nlabel: {self.label}\nduration: {self.duration}'


# ------------------------------------------------------------------------ #

# ------------------------------------------------------------------------ #
def extract_info(interval, line):
    """
    Extract relevant information from line and add it to Interval object
    """
    if 'xmin = ' in line:
        start_point = re.sub(r'.*xmin = (\d*\.*\d*)', '\\1', line)
        interval.start_point = float(start_point)
    elif 'xmax = ' in line:
        end_point = re.sub(r'.*xmax = (\d*\.*\d*)', '\\1', line)
        interval.end_point = float(end_point)
    elif 'text = ' in line:
        label = re.sub(r'.*text = "(.*)"', '\\1', line)
        label = label.strip()
        if label:
            interval.label = label
    return interval


# ------------------------------------------------------------------------ #

def read_input(in_folder_name = INPUT_PATH):
    """
    read in all textgrid files from folder as list of Interval objects
    """
    intervals = []
    for file_name in os.listdir(in_folder_name):
        if not file_name.endswith('.TextGrid'):
            continue

        with open(os.path.join(in_folder_name, file_name), 'r', encoding='utf8') as in_file:
            is_phone_tier = False
            current_interval = Interval()
            for line in in_file:
                # entered tier with phone segments
                if PHONE_TIER in line:
                    is_phone_tier = True
                # no longer in phone tier
                elif 'name = ' in line:
                    is_phone_tier = False
                
                # extract info if in phone tier
                if is_phone_tier:
                    current_interval = extract_info(current_interval, line)
                # label has been filled, this interval is complete
                if current_interval.label:
                    # calculate duration and store it in the object
                    current_interval.duration = current_interval.calculate_duration()
                    # add to list of interval objects and clear current interval
                    intervals.append(current_interval)
                    current_interval = Interval()
    return intervals


# ------------------------------------------------------------------------ #
# ------------ MAIN FUNCTION ------------ #
# ------------------------------------------------------------------------ #
def main():

    # read in list of interval objects
    segment_intervals = read_input()

    # convert list of interval objects to dataframe
    master_df = pd.DataFrame([interval.__dict__ for interval in segment_intervals])

    # create dictionary of dataframes based on values in 'label' column
    all_segments_df = {elem : pd.DataFrame() for elem in master_df.label.unique()}

    # fill values based on key
    for key in all_segments_df.keys():
        all_segments_df[key] = master_df[:][master_df.label == key]



    

if __name__ == '__main__':
    main()