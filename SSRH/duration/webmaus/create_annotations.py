# ------------------------------------------------------------------------ #
# ------------ LIBRARIES ------------ #
# ------------------------------------------------------------------------ #

import os

# ------------------------------------------------------------------------ #
# ------------ CONSTANTS ------------ #
# ------------------------------------------------------------------------ #
MAPPING_DICTIONARY = {'Anwalt_Diva': 'Das Gericht war daher sehr überrascht, als der Anwalt der Diva widersprach', 'Fahrer_Dame': 'Um alles mitzubekommen, musste der Fahrer der Dame zuhören', 'Onkel_Nonne': 'Alle freuten sich, als der Onkel der Nonne gratulierte', 'Schwager_Tante': 'Um rechtzeitig fertig zu werden, musste der Schwager der Tante helfen', 'Gaertner_Oma': 'Die Enkel waren daher überrascht, als der Gärtner der Oma zustimmte', 'Partner_Freundin': 'Jeder bemerkte, dass der Partner der Freundin fehlt', 'Diener_Graefin': 'Keiner dachte sich etwas dabei, als der Diener der Gräfin folgte', 'Lehrer_Schwaebin': 'Alle hörten gespannt zu, als der Lehrer der Schwäbin antwortete', 'Rabe_Heldin': 'Die Anwesenden waren sehr überrascht, dass der Rabe der Heldin gehorchte'}

INPUT_PATH = '/Users/romihill/Developer/git/Hiwi/SSRH/duration/webmaus/annotations_as_txt/'

def fill_annotation_in_file(identifier, file_path):
    """
    Fill .txt files in folder with annotations of accompanying .wav files
    """
    with open(file_path, 'w', encoding='utf8') as in_file:
        in_file.write(MAPPING_DICTIONARY[identifier])

def identify_files(in_folder):
    """
    Find .txt files in folder, and identify which annotation the file should take
    """
    for file_name in os.listdir(INPUT_PATH):
        if not file_name.endswith('.txt'):
            continue
        elif 'Anwalt_Diva' in file_name:
            fill_annotation_in_file('Anwalt_Diva', os.path.join(INPUT_PATH, file_name))
        elif 'Fahrer_Dame' in file_name:
            fill_annotation_in_file('Fahrer_Dame', os.path.join(INPUT_PATH, file_name))
        elif 'Onkel_Nonne' in file_name:
            fill_annotation_in_file('Onkel_Nonne', os.path.join(INPUT_PATH, file_name))
        elif 'Schwager_Tante' in file_name:
            fill_annotation_in_file('Schwager_Tante', os.path.join(INPUT_PATH, file_name))
        elif 'Gaertner_Oma' in file_name:
            fill_annotation_in_file('Gaertner_Oma', os.path.join(INPUT_PATH, file_name))
        elif 'Partner_Freundin' in file_name:
            fill_annotation_in_file('Partner_Freundin', os.path.join(INPUT_PATH, file_name))
        elif 'Diener_Graefin' in file_name:
            fill_annotation_in_file('Diener_Graefin', os.path.join(INPUT_PATH, file_name))
        elif 'Lehrer_Schwaebin' in file_name:
            fill_annotation_in_file('Lehrer_Schwaebin', os.path.join(INPUT_PATH, file_name))
        elif 'Rabe_Heldin' in file_name:
            fill_annotation_in_file('Rabe_Heldin', os.path.join(INPUT_PATH, file_name))
        else:
            print(f'{file_name} does not have the correct filename/context. Please fix')
            

def main():
    identify_files(INPUT_PATH)


if __name__ == '__main__':
    main()