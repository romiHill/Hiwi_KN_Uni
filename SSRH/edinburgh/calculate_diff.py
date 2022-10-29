
"""
Calculate duration differences between segments
"""
# ------------------------------------------------------------------------ #
# ------------ LIBRARIES ------------ #
# ------------------------------------------------------------------------ #
import re

# ------------------------------------------------------------------------ #
# ------------ CONSTANTS ------------ #
# ------------------------------------------------------------------------ #
FILENAME = "/Users/romihill/Developer/git/KN_Uni/Hiwi/edinburgh/Sp2_Sn113_ff_aa.TextGrid"

AUTO_TIER_NAME = "auto-durabs"

MANUAL_TIER_NAME = "manual-durabs"

# ------------------------------------------------------------------------ #
# ------------ CLASSES ------------ #
# ------------------------------------------------------------------------ #

class Interval:
    """
    Class to store start point, end point, and label or an interval
    """
    def __init__(self, start_point = 0.0, end_point = 0.0, label = ""):
        self.start_point = float(start_point)
        self.end_point = float(end_point)
        self.label = str(label)
    def __str__(self):
        return f'start_point: {self.start_point}\nend_point: {self.end_point}\nlabel: {self.label}\n'

# ------------------------------------------------------------------------ #
class TierType:
    """
    Check whether Tier is auto or manual
    """
    def __init__(self, is_auto: bool, is_manual: bool):
        self.is_auto = is_auto
        self.is_manual = is_manual
    def __str__(self):
        return f'is_auto: {self.is_auto}\nis_manual: {self.is_manual}'


# ------------------------------------------------------------------------ #

# ------------------------------------------------------------------------ #
# ------------ HELPER FUNCTIONS ------------ #
# ------------------------------------------------------------------------ #
def is_substring(string_one, string_two):
    """
    Check whether either string is a substring of the other
    """
    if string_one in string_two:
        return True
    elif string_two in string_one:
        return True
    return False


def check_tier_name(line: str, tier_name: TierType):
    """
    Check whether the current tier is the desired auto or manual tier
    """
    if AUTO_TIER_NAME in line:
        tier_name.is_auto = True
        tier_name.is_manual = False
        return tier_name
    elif MANUAL_TIER_NAME in line:
        tier_name.is_auto = False
        tier_name.is_manual = True
        return tier_name
    else:
        tier_name.is_auto = False
        tier_name.is_manual = False
        return tier_name

# ------------------------------------------------------------------------ #
def extract_info(interval, line):
    """
    Extract relevant information from line and add it to Interval object
    """
    if 'xmin = ' in line:
        start_point = re.sub(r'.*xmin = (\d*\.\d*)', '\\1', line)
        interval.start_point = float(start_point)
    elif 'xmax = ' in line:
        end_point = re.sub(r'.*xmax = (\d*\.\d*)', '\\1', line)
        interval.end_point = float(end_point)
    elif 'text = ' in line:
        label = re.sub(r'.*text = "(.*)"', '\\1', line)
        label = label.strip()
        if label:
            interval.label = label
    return interval

# ------------------------------------------------------------------------ #

def read_file(in_file_name = FILENAME):
    """
    read in textgrid file as Interval object
    """
    with open(in_file_name, 'r') as in_file:
        # booleans to check whether tiers are auto or manual
        is_auto_tier = False
        is_manual_tier = False
        
        # initialise variables
        current_tier_name = TierType(False, False)
        auto_intervals = []
        manual_intervals = []
        current_interval = Interval()
        for line in in_file:
            # entered new tier
            if 'name' in line:
                current_tier_name = check_tier_name(line, current_tier_name)
            if current_tier_name.is_auto or current_tier_name.is_manual:
                # fill in Interval object with xmin, xmax, label info
                current_interval = extract_info(current_interval, line)
                # text is non-empty, so need to store associated info and move onto next interval
                if current_interval.label:
                    if current_tier_name.is_auto:
                        auto_intervals.append(current_interval)
                    elif current_tier_name.is_manual:
                        manual_intervals.append(current_interval)
                    # reset Interval object
                    current_interval = Interval()
    return auto_intervals, manual_intervals

# ------------------------------------------------------------------------ #
def evaluate_errors(auto_intervals, manual_intervals):
    """
    Evaluate types of errors between auto and manual
    """
    # missing intervals
    j = 0
    for i in range(len(auto_intervals)):
        if not is_substring(auto_intervals[i].label, manual_intervals[i].label):
            for offsetIndex in range(1, 10):
                if is_substring(auto_intervals[i+1].label, manual_intervals[i+offsetIndex].label):
                    print(f'here: {manual_intervals[i+offsetIndex-1].label}')
                    j += offsetIndex - 1
                    break
        j += 1




# ------------------------------------------------------------------------ #
# ------------ MAIN FUNCTION ------------ #
# ------------------------------------------------------------------------ #
def main():
    auto_intervals, manual_intervals = read_file()
    evaluate_errors(auto_intervals, manual_intervals)

if __name__ == '__main__':
    main()