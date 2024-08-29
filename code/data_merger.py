'''
data_merger.py
A very simple script that merges multiple word lists into one
'''
import csv

base_language = "English"
data_directory_path = "../data/"
data_dict = {
  "Bislama": ["bislama_asjp.csv"],
  "Pijin": ["pijin_asjp.csv", "Pijin_100.csv", "pijin_webonary.csv"],
  "Tok Pisin": ["tok_pisin_asjp.csv", "tok_pisin_swadesh_200.csv", "tok_pisin_word_list.csv"],
  "Torres Creole": ["torres_creole_asjp.csv", "torres_creole_word_list.csv", "torres_creole_glosbe.csv"]
}
min_translations_for_inclusion = 4

total_vocabulary = []

#Identifying all unique words in the input files
for language in data_dict:
    for data_file in data_dict[language]:
        with open(data_directory_path + data_file, encoding = 'cp850') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                current_word = row[0].lower()
                if current_word not in total_vocabulary:
                    total_vocabulary.append(current_word)

merged_list = []

#Adding a header for the csv file
merged_list.append(base_language + "," + ",".join(data_dict.keys()))

#Grouping the translations by language and adding them to the merged data
for word in total_vocabulary:
    all_word_translations = []
    translation_counter = 0
    for language in data_dict:
        local_word_translations = []
        for data_file in data_dict[language]:
            with open(data_directory_path + data_file, encoding = 'cp850') as csv_file:
                csv_reader = csv.reader(csv_file, delimiter=',')
                line_count = 0
                for row in csv_reader:
                    if row[0].lower() == word:
                        if row[1].lower() not in local_word_translations:
                            local_word_translations.append(row[1].lower())
        if local_word_translations == []:
            all_word_translations.append("")
        else:
            translation_counter += 1
            all_word_translations.append("/".join(local_word_translations))
    if translation_counter >= min_translations_for_inclusion:
        merged_list.append(word + "," + ",".join(all_word_translations))

# Sort the list alphabetically
merged_list = sorted(merged_list)              
print(merged_list)

# Writing the merged data to a csv file
with open(data_directory_path + 'merged_data_4_nobis.csv', 'w', encoding = 'cp850') as f:
    for line in merged_list:
        f.write(f"{line}\n")