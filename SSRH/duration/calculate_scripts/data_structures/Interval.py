# to do: may need to add info about previous and following segment, 
# ------ location of segment within word, syllable structure, etc

class Interval:
    """
    Class to store start point, end point, duration, and label of an interval
    """
    def __init__(self, start_point = 0.0, end_point = 0.0, label = ""):
        self.start_point = float(start_point)
        self.end_point = float(end_point)
        self.duration = -1
        self.label = str(label)
    def calculate_duration(self):
        return (self.end_point - self.start_point)
    def __str__(self):
        return f'start_point: {self.start_point}\nend_point: {self.end_point}\nlabel: {self.label}\nduration: {self.duration}'

